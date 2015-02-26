require 'sinatra'
require 'data_mapper'
# require 'rack'

env = ENV['RACK_ENV'] || 'development'

DataMapper.setup(:default, "postgres://localhost/bookmark_manager_new_#{env}")

require './app/models/link'


DataMapper.finalize


DataMapper.auto_upgrade!


get '/' do
 @links = Link.all
 erb :index
end

post '/links' do
 url = params["url"]
 title = params["title"]
 Link.create(url: url, title: title)
 redirect to('/')


end


