class CoursesController < ApplicationController
  get '/courses/new' do
    if session[:user_id]
      @students = Student.all
      erb :"courses/new"
    else
      erb :"teachers/login"
    end
  end

  post '/courses/new' do 
    course = Course.find_by(name: params[:course][:name])
      if course 
        redirect "/courses/#{course.slug}"
      else
        course = Course.create(name: params[:course][:name])

        params[:course][:students].each do |student|
          StudentCourse.create(student_id: student, course_id: course.id)
        end

        redirect "/courses/#{course.slug}"
      end
    
  end


end