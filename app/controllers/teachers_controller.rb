require 'rack-flash'

class TeachersController < ApplicationController

use Rack::Flash

  get '/' do
    if session[:user_id]
      @teacher = Teacher.find(session[:user_id])
      erb :"teachers/index"
    else
      erb :"teachers/login"
    end
  end

  get '/login' do
    if session[:user_id]
      redirect '/'
    else
      erb :"teachers/login"
    end 
  end

  get '/logout' do
    if session[:user_id]
      erb :"teachers/logout"
    else
      redirect "/"
    end
  end

  get '/signup' do
    if session[:user_id]
      redirect '/'
    else
      erb :"teachers/signup"
    end 
  end

  post '/login' do
    teacher = Teacher.find_by(email: params[:email])
    
    # check if teacher exists and passwords match
    if teacher && teacher.authenticate(params[:password])
      session[:user_id] = teacher.id
      redirect '/'
    else
      flash[:message] = "Error authenticating user."
      redirect '/login'
    end
  end

  post '/signup' do
    teacher = Teacher.find_by(email: params["teacher"]["email"])
    
    # CHeck if password and confirmation work
    if params["teacher"]["password"] != params["c_password"]
      flash[:message] = "Passwords do not match."
      redirect '/signup'
    end

    # Check if teacher exists, if not, create
    if teacher 
      flash[:message] = "User already exists. Please login to continue"
      redirect '/login'
    else
      teacher = Teacher.create(params["teacher"])
      session[:user_id] = teacher.id
      redirect '/'
    end
  end

  post '/logout' do
    if session[:user_id]
      session.clear
    end

    redirect "/"
  end

end