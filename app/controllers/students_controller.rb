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

  get '/students/:id' do
    if session[:user_id]
      @student = Student.find(params[:id])
      erb :"students/show"
    else
      flash[:message] = "Access Denied"
      redirect "/"
    end
  end

  post '/students/new' do 
    student = Student.create(name: params[:student][:name])

    params[:students][:courses].each do |course|
      StudentCourse.create(student_id: student.id, course_id: course.id)
    end

    redirect "/students/#{student.id}"
    end
  end
end