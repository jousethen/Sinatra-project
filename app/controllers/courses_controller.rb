class CoursesController < ApplicationController
  get '/courses/new' do
    if session[:user_id]
      erb :"courses/new"
    else
      erb :"teachers/login"
    end
  end


end