class SessionsController < ApplicationController
  def create
    #raise request.env['omniauth.auth']['credentials']['token']
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    session[:fb_token] = env['omniauth.auth']['credentials']['token']
    redirect_to root_url, notice: "Signed in"
  end

  def destroy
    reset_session
    redirect_to root_url, notice: "Signed out"
  end
end
