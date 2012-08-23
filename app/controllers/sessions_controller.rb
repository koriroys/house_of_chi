class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(env["omniauth.auth"])
    # caching fb token to let me run rake tasks. should probably limit this to just me
    # TODO: find a better way
    session[:user_id] = user.id
    user.update_attribute :fb_token, env['omniauth.auth']['credentials']['token']
    redirect_to root_url, notice: "Signed in"
  end

  def destroy
    reset_session
    redirect_to root_url, notice: "Signed out"
  end
end
