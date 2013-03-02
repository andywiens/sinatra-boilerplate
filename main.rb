require 'sinatra'
require 'sinatra/static_assets'
require 'warden'
require 'data_mapper'
require 'colorize'

# DataMapper setup
DataMapper::Logger.new(STDOUT, :info)
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/database.db")

# DataMapper::Model.raise_on_save_failure = true 

configure do
  set :views, ['views/layouts', 'views/pages', 'views/partials']
  #enable :sessions
end

Dir["./app/models/*.rb"].each { |file| require file }
Dir["./app/helpers/*.rb"].each { |file| require file }
Dir["./app/managers/*.rb"].each { |file| require file }
Dir["./app/controllers/*.rb"].each { |file| require file }

before "/*" do 
  if mobile_request?
    set :erb, :layout => :mobile
  else
    set :erb, :layout => :layout
  end
end

DataMapper.auto_upgrade!
