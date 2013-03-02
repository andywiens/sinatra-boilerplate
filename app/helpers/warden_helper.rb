# the following helpers were taken from 
# http://mikeebert.tumblr.com/post/27097231613/wiring-up-warden-sinatra
helpers do
  # a more meaningful way to ask
  def warden_handler
    env['warden']
  end

  # a way to see the current_user
  def current_user
    warden_handler.user
  end

  # check authentication status, and redirect if necessary
  def check_authentication
    redirect '/login' unless warden_handler.authenticated?
  end
end
