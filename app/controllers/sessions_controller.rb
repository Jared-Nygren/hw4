class SessionsController < ApplicationController
  def new
  end

  def create
  # Authenticate the user
    # 1. Try to find the user by their unique identifier
    @user = User.find_by({ "email" => params["email"] })

    # 2. If the user exists -> check if they know their password
    if @user != nil
      # 3. If they know their password -> login is successful
      if BCrypt::Password.new(@user["password"]) == params["password"]
        session["user_id"] = @user["id"]
        flash["notice"] = "Welcome, #{@user["first_name"]}, login successful."
        redirect_to "/places"
      else
        # 4b. If the user doesn't know their password -> login fails
        flash["notice"] = "Invalid email or password. Please try again."
        redirect_to "/sessions/new"
      end
    else
      # 4a. If the user doesn't exist -> login fails
      flash["notice"] = "Invalid email or password. Please try again."
      redirect_to "/sessions/new"
    end
  end

  def destroy
    # Logout the user
    flash["notice"] = "Goodbye."
    session["user_id"] = nil
    redirect_to "/login"
  end
end
  