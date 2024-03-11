class SessionsController < ApplicationController
  # Shows the login form
  def new
  end

  # Handles the login process
  def create
    # Finds the user with the given email address.
    @user = User.find_by({ "email" => params["email"] })

    # Checks if the user exists.
    if @user != nil
      # If the user exists, checks if the given password matches the stored one.
      if BCrypt::Password.new(@user["password"]) == params["password"]
        # If the password matches, logs the user in and shows a welcome message.
        session["user_id"] = @user["id"]
        flash["notice"] = "Welcome, #{@user["first_name"]}, login successful."
        redirect_to "/places"
      else
        # If the password doesn't match, tells the user the login failed.
        flash["notice"] = "Invalid email or password. Please try again."
        redirect_to "/sessions/new"
      end
    else
      # If the user doesn't exist, tells the user the login failed.
      flash["notice"] = "Invalid email or password. Please try again."
      redirect_to "/sessions/new"
    end
  end

  # Handles the logout process
  def destroy
    # Logs the user out by clearing their session and shows a goodbye message.
    flash["notice"] = "Goodbye."
    session["user_id"] = nil
    redirect_to "/login"
  end
end

  