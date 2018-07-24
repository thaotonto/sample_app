class FollowersController < ApplicationController
  before_action :find_user

  def index
    @title = t "users.follower"
    @users = @user.followers.page params[:page]
  end
end
