class TeachersController < ApplicationController
  get '/' do
    if session[:user_id]
      erb :"teachers/index"
    else
      erb :"teachers/login"
    end
  end

  get '/login' do
    if session[:user_id]
      erb :"teachers/index"
    else
      erb :"teachers/login"
    end 
    
  end

  post '/login' do
    teacher = Teacher.find(params[:id])
    binding.pry
    if teacher && teacher.authenticate(params[:password])
      session[:user_id] = teacher.id
      redirect '/index'
    else
      redirect '/login'
    end
  end

end