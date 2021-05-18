class TeachersController < ApplicationController
    get '/' do
        erb :"teachers/homepage"
    end
end