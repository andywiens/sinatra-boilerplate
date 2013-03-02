# uncomment for non-Warden application
# get "/" do
#   erb :index
# end

# uncomment for Warden authentication 
get '/' do
  redirect '/login' unless env['warden'].user
  erb :home
end 
