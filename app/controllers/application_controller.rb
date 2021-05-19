require './config/environment'

class ApplicationController < Sinatra::Base
  set :views, proc {File.join(root,'../views/')}

  configure do 
  #  set :views, 'app/views'
    set :public_folder, 'public'
    enable :sessions 
    set :sessions_secret, "password_security"
  end

end