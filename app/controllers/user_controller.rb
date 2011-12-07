class UserController < ApplicationController
  def index
    @user  = Twitter.user(session[:user_id]) if signed_in?
    respond_to do |format|
      format.html # index.html.haml
    end
  end

  def login
  end
end
