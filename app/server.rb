require 'data_mapper'
require 'sinatra'
require './app/models/link.rb'
require './lib/user.rb'
require './app/helpers/helper'
require 'rack-flash'


env = ENV['RACK_ENV'] || 'development'

DataMapper.setup(:default, "postgres://localhost/bookmark_manager_new_#{env}")

require './app/models/link'

DataMapper.finalize

DataMapper.auto_upgrade!

enable :sessions
set :session_secret, 'super secret'
use Rack::Flash



get '/' do
  @links = Link.all
  erb :index
end

post '/links' do
  url = params["url"]
  title = params["title"]
  tags = params["tags"].split(" ").map{|tag| Tag.first_or_create(text: tag)}
  Link.create(:url => url, title: title, tags: tags)
  redirect to('/')
end


get '/tags/:text' do
  tag = Tag.first(text: params[:text])
  @links = tag ? tag.links : []
  erb :index
end

get '/users/new' do
  erb :"users/new"
end

post '/users' do
  @user =User.create(:email => params[:email],
              :password => params[:password],
              :password_confirmation =>  params[:password_confirmation])

  if @user.save
    session[:user_id] = @user.id
    redirect to('/')
  else
    flash[:notice] = "Sorry, your passowrds don't match"
    erb :"users/new"
  end
end

