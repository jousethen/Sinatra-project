require 'rack-flash'

class StudentsController < ApplicationController
  use Rack::Flash

  get '/students/new' do
    if session[:user_id]
      @teacher = Teacher.find(session[:user_id])
      @courses = @teacher.courses
      erb :"students/new"
    else
      erb :"teachers/login"
    end
  end

  get '/students/id' do
    if session[:user_id] && @course.teacher_id == session[:user_id]
      erb :"students/show"
    else
      flash[:message] = "Access Denied"
      redirect "/"
    end
  end

  get '/students/:slug/edit' do
    @course = Course.find_by_slug(params[:slug])
    @students = Student.all
    if session[:user_id] && @course.teacher_id == session[:user_id]
      erb :"students/edit"
    else
      flash[:message] = "Access Denied"
      redirect "/"
    end
  end

  post '/students/new' do 
    course = Course.find_by(name: params[:course][:name])

    # Check if course with same name already exists
    if course 
      flash[:message] = "Course Name Already Taken"
      redirect "/students/new"
    else
      # create new course with students
      course = Course.create(name: params[:course][:name], teacher_id: session[:user_id])

      params[:course][:students].each do |student|
        StudentCourse.create(student_id: student, course_id: course.id)
      end

      redirect "/students/#{course.slug}"
    end
  end

  patch '/students/:slug' do
    # check if course name already exists
    exist = Course.find_by(name: params[:course][:name])
    if exist && exist.teacher_id != session[:user_id]
      flash[:message] = "Course name already exists. Please choose a different name."
      redirect "/students/#{params[:slug]}/edit"
    end

    # find currently worked on course
    course = Course.find_by_slug(params[:slug])
    student_students = []
    
    # get student_students
    params[:course][:students].each do |student|
      student_students  << StudentCourse.create(student_id: student, course_id: course.id)
    end
    
    # update course
    course.update(name: params[:course][:name], student_students: student_students)
    course.save

    redirect "/students/#{course.slug}"
    
  end

  delete '/students/:slug' do
    course = Course.find_by_slug(params[:slug])
    
    if session[:user_id] == course.teacher_id
      flash[:message] = "#{course.name} Deleted"
      course.destroy
      redirect '/'
    else
      flash[:message] = "Access Denied"
      redirect "/students/#{params[:slug]}"
    end
  end
end