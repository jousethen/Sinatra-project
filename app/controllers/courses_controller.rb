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
    if session[:user_id]
      @course = Course.find_by_slug(params[:slug])
      erb :"courses/show"
    else
      erb :"teachers/login"
    end
  end

  get '/courses/:slug/edit' do
    if session[:user_id]
      @course = Course.find_by_slug(params[:slug])
      @students = Student.all
      erb :"courses/edit"
    else
      erb :"teachers/login"
    end
  end

  post '/courses/new' do 
    course = Course.find_by(name: params[:course][:name])
      if course 
        redirect "/courses/#{course.slug}"
      else
        course = Course.create(name: params[:course][:name], teacher_id: session[:user_id])

        params[:course][:students].each do |student|
          StudentCourse.create(student_id: student, course_id: course.id)
        end

        redirect "/courses/#{course.slug}"
      end
  end

  patch '/courses/:slug' do
    course = Course.find_by_slug(params[:slug])

    student_courses = []
    
    params[:course][:students].each do |student|
      student_courses  << StudentCourse.create(student_id: student, course_id: course.id)
    end
    course.update(name: params[:course][:name], student_courses: student_courses)
    course.save

    redirect "/courses/#{course.slug}"
    
  end


end