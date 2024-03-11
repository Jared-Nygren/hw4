class PlacesController < ApplicationController
  # This part lists all places for the logged-in user.
  def index
    # Checks if the user is not logged in.
    if session["user_id"].nil?
      # If not logged in, shows a message and sends them to the login page.
      flash["notice"] = "You must be logged in to view places"
      redirect_to "/login"
    else
      # If logged in, finds and shows all places created by the user.
      @places = Place.where(user_id: session["user_id"])
    end
  end

  # This part shows details for a single place.
  def show
    # Checks if the user is not logged in.
    if session["user_id"].nil?
      # Shows a message and sends them to the login page if not logged in.
      flash["notice"] = "You must be logged in to view a place"
      redirect_to "/login"
    else
      # Finds a specific place that belongs to the logged-in user.
      @place = Place.find_by({ "id" => params["id"], "user_id" => session["user_id"] })
      if @place.nil?
        # If the place doesn't exist or isn't the user's, shows a message and redirects.
        flash["notice"] = "You are not authorized to view this place"
        redirect_to places_path
      else
        # If the place is found, shows all entries related to this place.
        @entries = Entry.where({ "place_id" => @place["id"] })
      end
    end
  end

  # Prepares to show the form to create a new place.
  def new
    # Makes a new, empty place ready to be filled in with details.
    @place = Place.new
  end

  # Processes the form to add a new place.
  def create
    # Checks if the user is not logged in.
    if session["user_id"].nil?
      # Shows a message and redirects to the login page if not logged in.
      flash["notice"] = "You must be logged in to create a new place"
      redirect_to "/login"
    else
      # Creates a new place with the provided details from the form.
      @place = Place.new(place_params)
      # Assigns the logged-in user's ID to this new place.
      @place["user_id"] = session["user_id"]
      if @place.save
        # If the place is saved successfully, shows a success message and goes to the list of places.
        flash["success"] = "Place successfully created"
        redirect_to places_path
      else
        # If saving fails, shows an error and displays the form again.
        flash.now["error"] = "Failed to create place"
        render :new
      end
    end
  end

  # This part specifies which details about a place are safe to send to the website.
  private

  def place_params
    # Allows only the name of the place to be submitted.
    params.require(:place).permit(:name)
  end
end

