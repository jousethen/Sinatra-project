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
      redirect '/index'
    else
      erb :"teachers/login"
    end 
  end

  get '/signup' do
    if session[:user_id]
      redirect '/index'
    else
      erb :"teachers/signup"
    end 
  end

  post '/login' do
    teacher = Teacher.find_by(email: params[:email])
    
    if teacher && teacher.authenticate(params[:password])
      session[:user_id] = teacher.id
      redirect '/index'
    else
      redirect '/login'
    end
  end

  post '/signup' do
    teacher = Teacher.find_by(id: params[:id])
    
    if teacher && teacher.authenticate(params[:password])
      session[:user_id] = teacher.id
      redirect '/index'
    else
      redirect '/login'
    end
  end

end