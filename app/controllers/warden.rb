# Warden routes
# Two sets of pages and routes: 
#   user (for login and sign up) and 
#   admin (for managing accounts)

# -------------------------------------
# user routes
# -------------------------------------

# display the login page
get '/login/?' do
  erb :'/user/login'
end
 
# a successful login redirects to the application index page
# a failed login redirects to the login page
post '/login/?' do
  if warden_handler.authenticate
    redirect '/'
  else
    redirect '/user/login'
  end
end
 
# not a page per se, logout removes the session and redirects to the 
# application home page
get '/logout/?' do
  warden_handler.logout
  redirect '/'
end

# display the sign up page to allow a new account to be created
get '/signup' do
  @user = User.new
  erb :'/user/signup'
end

# add account created by user
# massive kludge. not DRY. Ick.
post '/signup/new' do
  logger.info 'adding new user'
  logger.info "name: #{params[:fname]} #{params[:lname]}"
  logger.info "email: #{params[:email]}"
  logger.info "password: #{params[:password]}"
  logger.info "confirm: #{params[:password_confirmation]}"

  @user = User.create(:fname => params[:fname], 
                      :lname => params[:lname],
                      :email => params[:email], 
                      :password => params[:password], 
                      :password_confirmation => params[:password_confirmation])
 
  if @user.save
    logger.info 'new account created successfully'
    redirect '/'
  else
    logger.error 'account creation failed. Sad Panda'.red

    error = String.new
    @user.errors.each do |e|
      error << "#{e[0]}\n"
    end
    raise ArgumentError, error

    erb :'/signup'
  end
end
 
# -------------------------------------
# admin routes
# -------------------------------------

# admin/index displays all current accounts
get '/accounts/?' do
  @users = User.all(:order => [ :lname.asc ])
 
  erb :'/admin/index'
end
 
# admin/new allows administration to add a new account
get '/account/new' do
  @user = User.new
 
  erb :'/admin/new'
end
 
# admin/edit allows an account to be edited or deleted
get '/account/:id/edit' do
  @user = User.get(params[:id])
  erb :'/admin/edit'
end
 
# account/add creates a new account
post '/account/add' do
  logger.info 'adding new user'
  logger.info "name: #{params[:fname]} #{params[:lname]}"
  logger.info "email: #{params[:email]}"
  logger.info "password: #{params[:password]}"
  logger.info "confirm: #{params[:password_confirmation]}"

  @user = User.create(:fname => params[:fname], 
                      :lname => params[:lname],
                      :email => params[:email], 
                      :password => params[:password], 
                      :password_confirmation => params[:password_confirmation])
 
  if @user.save
    logger.info 'new user saved successfully'
    redirect '/accounts'
  else
    logger.error 'new user failed to save. Sad Panda'.red

    error = String.new
    @user.errors.each do |e|
      error << "#{e[0]}\n"
    end
    raise ArgumentError, error

    erb :'/accounts/new'
  end
end
 
# account/:id updates the account
put '/account/:id' do
  logger.info "updating account"
  @user = User.get(params[:id])
 
  if @user.update(:fname => params[:fname],
                  :lname => params[:lname], 
                  :email => params[:email], 
                  :password => params[:password], 
                  :password_confirmation => params[:password_confirmation])
    logger.info "update for account #{params[:id]} successful"
    redirect '/accounts'
  else
    logger.error "account update failed".red
    userid = params[:id]
    redirect "/account/#{userid}/edit"
  end
end

# account/:id/delete displays the account delete confirmation page
get '/account/:id/delete' do
  @user = User.get(params[:id])

  erb :'/admin/delete'
end
 
# delete /account/:id destroys the account
delete '/account/:id' do
  @user = User.get(params[:id])
  @user.destroy!
 
  redirect '/accounts'
end
