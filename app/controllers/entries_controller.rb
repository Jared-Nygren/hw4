class EntriesController < ApplicationController
  def index
    if session["user_id"].nil?
      flash["notice"] = "You must be logged in to view entries"
      redirect_to "/login"
    else
      @entries = Entry.where(user_id: session["user_id"])
    end
  end

  def new
    if session["user_id"].nil?
      flash["notice"] = "You must be logged in to add a new entry"
      redirect_to "/login"
    else
      @place_id = params[:place_id]
      @entry = Entry.new
    end
  end

  def create
    if session["user_id"].nil?
      flash["notice"] = "You must be logged in to add a new entry"
      redirect_to "/login"
    else
      @entry = Entry.new(entry_params.merge(user_id: session["user_id"]))
      
      # Attach the uploaded image if present
      if params[:entry][:uploaded_image].present?
        @entry.uploaded_image.attach(params[:entry][:uploaded_image])
      end
      
      # Ensure place_id is present and corresponds to a valid Place
      if @entry.place_id.blank? || !Place.exists?(id: @entry.place_id, user_id: session["user_id"])
        flash.now[:error] = "Invalid or missing place."
        render :new and return
      end

      if @entry.save
        flash[:notice] = "Entry successfully created"
        redirect_to place_path(@entry.place_id) # Redirect to the place show page
      else
        flash.now[:error] = "Failed to create entry"
        render :new
      end
    end
  end

  private

  def entry_params
    params.require(:entry).permit(:title, :description, :occurred_on, :place_id)
  end
end






# class EntriesController < ApplicationController
#   def index
#     if session["user_id"].nil?
#       flash["notice"] = "You must be logged in to view entries"
#       redirect_to "/login"
#     else
#       @entries = Entry.where(user_id: session["user_id"])
#     end
#   end

#   def new
#     if session["user_id"].nil?
#       flash["notice"] = "You must be logged in to add a new entry"
#       redirect_to "/login"
#     else
#       @place_id = params[:place_id]
#       @entry = Entry.new
#     end
#   end

#   def create
#     Rails.logger.debug "Received params: #{params.inspect}"
#     if session["user_id"].nil?
#       flash["notice"] = "You must be logged in to add a new entry"
#       redirect_to "/login"
#     else
#       @entry = Entry.new({
#         "title" => params["title"],
#         "description" => params["description"],
#         "occurred_on" => params["occurred_on"],
#         "place_id" => params["place_id"], # Include place_id in the creation
#         "user_id" => session["user_id"] # Ensuring the entry is associated with the current user
#       })
  
#       # Check if an image was uploaded
#       if params[:uploaded_image].present?
#         @entry.uploaded_image.attach(params[:uploaded_image])
#       end
  
#       if @entry.save
#         Rails.logger.debug "Place ID: #{@entry.place_id}" # Log place_id after entry is saved
#         flash["notice"] = "Entry successfully created"
#         redirect_to place_path(@entry.place_id) # Adjust the redirect to show the place
#       else
#         flash.now["error"] = "Failed to create entry"
#         render :new
#       end
#     end
#   end   
# end  
