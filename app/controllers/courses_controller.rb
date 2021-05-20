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
    binding.pry
  end


end