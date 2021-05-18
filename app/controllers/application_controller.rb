require './config/environment'

class ApplicationController < Sinatra::Base

  configure do 
    set :views, 'app/views'
    enable :sessions 
    set :sessions_secret, "password_security"
  end

end