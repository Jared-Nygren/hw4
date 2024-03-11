class ApplicationController < ActionController::Base
  before_action :current_user

  def current_user
    puts "----- this code runs at the beginning of the request"
    # Find logged-in user
    @current_user = User.find_by({ "id" => session["user_id"] })
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "Logged out successfully"
  end
end
