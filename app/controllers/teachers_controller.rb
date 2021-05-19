require 'rack-flash'

class TeachersController < ApplicationController

use Rack::Flash

  get '/' do
    # session.delete(:user_id)

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
      flash[:message] = "Error authenticating user."
      redirect '/login'
    end
  end

  post '/signup' do
    teacher = Teacher.find_by(email: params["teacher"]["email"])
    
    if params["teacher"]["password"] != params["c_password"]
      flash[:message] = "Passwords do not match."
      redirect '/signup'
    end

    if teacher 
      flash[:message] = "User already exists. Please login to continue"
      redirect '/login'
    else
      teacher = Teacher.create(params["teacher"])
      session[:user_id] = teacher.id
      redirect '/'
    end
  end

end