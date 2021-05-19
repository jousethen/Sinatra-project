class TeachersController < ApplicationController


  get '/' do
    session.delete(:error_message)
    @session = session

    if session[:user_id]
      erb :"teachers/index"
    else
      erb :"teachers/login"
    end
  end

  get '/login' do
    @session = session
    if session[:user_id]
      redirect '/index'
    else
      erb :"teachers/login"
    end 
  end

  get '/signup' do
    @session = session
    if session[:user_id]
      redirect '/index'
    else
      erb :"teachers/signup"
    end 
  end

  post '/login' do
    teacher = Teacher.find_by(email: params[:email])
    
    if teacher && teacher.authenticate(params[:password])
      session[:error_message].delete
      session[:user_id] = teacher.id
      redirect '/index'
    else
      session[:error_message] = "Error authenticating user."
      @session = session
      redirect '/login'
    end
  end

  post '/signup' do
    teacher = Teacher.find_by(email: params[[teacher][email]])
    
    if teacher 
      session[:error_message] = "User already exists. Please login to continue"
      redirect '/login'
    else
      session[:error_message].delete
      teacher = Teacher.create(params[teacher])
      session[:user_id] = teacher.id
    end
  end

end