class EntriesController < ApplicationController
  
  # The index action displays a list of entries to the user.
  def index
    # Check if the user is logged in by seeing if their user_id is stored in the session.
    if session["user_id"].nil?
      # If not logged in, show a notice and redirect them to the login page.
      flash["notice"] = "You must be logged in to view entries"
      redirect_to "/login"
    else
      # If logged in, find all entries belonging to the user and store them in a variable.
      @entries = Entry.where(user_id: session["user_id"])
    end
  end

  # The new action sets up the form for adding a new entry.
  def new
    # Again, check if the user is logged in.
    if session["user_id"].nil?
      # If not, notify and redirect to login.
      flash["notice"] = "You must be logged in to add a new entry"
      redirect_to "/login"
    else
      # If logged in, prepare a new Entry object and store the place_id from the request parameters.
      @place_id = params[:place_id]
      @entry = Entry.new
    end
  end

  # The create action processes the form submission to add a new entry.
  def create
    # Check for user login status.
    if session["user_id"].nil?
      # Notify and redirect to login if not logged in.
      flash["notice"] = "You must be logged in to add a new entry"
      redirect_to "/login"
    else
      # If logged in, create a new Entry object with parameters from the form, adding the user_id from the session.
      @entry = Entry.new(entry_params.merge(user_id: session["user_id"]))
      
      # If an image was uploaded with the entry, attach it to the entry.
      if params[:entry][:uploaded_image].present?
        @entry.uploaded_image.attach(params[:entry][:uploaded_image])
      end
      
      # Validate the place_id to ensure it exists and belongs to the current user.
      if @entry.place_id.blank? || !Place.exists?(id: @entry.place_id, user_id: session["user_id"])
        flash.now[:error] = "Invalid or missing place."
        render :new and return # Render the form again if validation fails.
      end

      # Save the entry. If successful, notify the user and redirect to the entry's place page.
      if @entry.save
        flash[:notice] = "Entry successfully created"
        redirect_to place_path(@entry.place_id) # Redirect to the place's show page.
      else
        # If saving fails, show the form again with an error message.
        flash.now[:error] = "Failed to create entry"
        render :new
      end
    end
  end

  private

  # Added this in with Chat GPT troubleshooting 
  # This method lists the safe information that can be sent to the website
  # It's a security feature to prevent malicious data from being submitted.
  def entry_params
    params.require(:entry).permit(:title, :description, :occurred_on, :place_id)
  end
end







