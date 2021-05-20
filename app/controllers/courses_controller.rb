require 'rack-flash'

class CoursesController < ApplicationController
  use Rack::Flash

  get '/courses/new' do
    if session[:user_id]
      @students = Student.all
      erb :"courses/new"
    else
      erb :"teachers/login"
    end
  end

  get '/courses/:slug' do
    @course = Course.find_by_slug(params[:slug])
    
    if session[:user_id] && @course.teacher_id == session[:user_id]
      erb :"courses/show"
    else
      flash[:message] = "Access Denied"
      redirect "/"
    end
  end

  get '/courses/:slug/edit' do
    @course = Course.find_by_slug(params[:slug])
    @students = Student.all
    if session[:user_id] && @course.teacher_id == session[:user_id]
      erb :"courses/edit"
    else
      flash[:message] = "Access Denied"
      redirect "/"
    end
  end

  post '/courses/new' do 
    course = Course.find_by(name: params[:course][:name])

    # Check if course with same name already exists
    if course 
      flash[:message] = "Course Name Already Taken"
      redirect "/courses/new"
    else
      # create new course with students
      course = Course.create(name: params[:course][:name], teacher_id: session[:user_id])

      params[:course][:students].each do |student|
        StudentCourse.create(student_id: student, course_id: course.id)
      end

      redirect "/courses/#{course.slug}"
    end
  end

  patch '/courses/:slug' do
    # check if course name already exists
    exist = Course.find_by(name: params[:course][:name])
    if exist && exist.teacher_id != session[:user_id]
      flash[:message] = "Course name already exists. Please choose a different name."
      redirect "/courses/#{params[:slug]}/edit"
    end

    # find currently worked on course
    course = Course.find_by_slug(params[:slug])
    student_courses = []
    
    # get student_courses
    params[:course][:students].each do |student|
      student_courses  << StudentCourse.create(student_id: student, course_id: course.id)
    end
    
    # update course
    course.update(name: params[:course][:name], student_courses: student_courses)
    course.save

    redirect "/courses/#{course.slug}"
    
  end

  delete '/courses/:slug' do
    course = Course.find_by_slug(params[:slug])
    
    if session[:user_id] == course.teacher_id
      flash[:message] = "#{course.name} Deleted"
      course.destroy
      redirect '/'
    else
      flash[:message] = "Access Denied"
      redirect "/courses/#{params[:slug]}"
    end
  end
end