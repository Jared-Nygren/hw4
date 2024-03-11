class UsersController < ApplicationController
  # Shows the sign-up form.
  def new
  end

  # Processes the sign-up form submission.
  def create
    # Creates a new, empty user.
    @user = User.new
    # Sets the user's details based on what they entered in the form.
    @user["username"] = params["username"]
    @user["first_name"] = params["first_name"]
    @user["last_name"] = params["last_name"]
    @user["email"] = params["email"]
    # Encrypts the password the user entered before storing it to keep it secure.
    @user["password"] = BCrypt::Password.create(params["password"])
    # Saves the user to the database.
    @user.save
    # Redirects to the login page, so the user can now log in with their new account.
    redirect_to "/login"
  end
end

