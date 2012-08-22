class SessionsController < ApplicationController
  def create
    #raise request.env['omniauth.auth']['credentials']['token']
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    session[:fb_token] = env['omniauth.auth']['credentials']['token']
    # caching fb token to let me run rake tasks. should probably limit this to just me
    # TODO: find a better way
    user.update_attribute :fb_token, session[:fb_token]
    redirect_to root_url, notice: "Signed in"
  end

  def destroy
    reset_session
    redirect_to root_url, notice: "Signed out"
  end
end
