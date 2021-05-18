class TeachersController < ApplicationController
  get '/' do
    if session[:user_id]
      erb :"teachers/index"
    else
      erb :"teachers/login"
    end
  end
end