class PlacesController < ApplicationController
  def index
    if session["user_id"].nil?
      flash["notice"] = "You must be logged in to view places"
      redirect_to "/login"
    else
      @places = Place.where(user_id: session["user_id"])
    end
  end

  def show
    if session["user_id"].nil?
      flash["notice"] = "You must be logged in to view a place"
      redirect_to "/login"
    else
      @place = Place.find_by({ "id" => params["id"], "user_id" => session["user_id"] })
      if @place.nil?
        flash["notice"] = "You are not authorized to view this place"
        redirect_to places_path
      else
        @entries = Entry.where({ "place_id" => @place["id"] })
      end
    end
  end

  def new
    @place = Place.new
  end

  def create
    if session["user_id"].nil?
      flash["notice"] = "You must be logged in to create a new place"
      redirect_to "/login"
    else
      @place = Place.new(place_params)
      @place["user_id"] = session["user_id"] # Assigning the logged-in user's ID to the new place
      if @place.save
        flash["success"] = "Place successfully created"
        redirect_to places_path
      else
        flash.now["error"] = "Failed to create place"
        render :new
      end
    end
  end
  private

  def place_params
    params.require(:place).permit(:name)
  end
end

