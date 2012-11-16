class StaticPagesController < ApplicationController
  def index
    @leaders = User.leaders
  end
end
