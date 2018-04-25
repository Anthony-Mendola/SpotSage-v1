class ParkingsController < ApplicationController
  before_action :set_parking, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:show]
  before_action :is_authorized, only: [:listing, :pricing, :description, :photo_upload, :amenities, :location, :update, :destroy]


  def index
    @parkings = current_user.parkings
  end

  def new
    @parking = current_user.parkings.build
  end

  def create
    @parking = current_user.parkings.build(parking_params)
    if @parking.save
      redirect_to listing_parking_path(@parking), notice: "Saved..."
    else
      flash[:alert] = "Something went wrong..."
      render :new
  end
end

  def show
    @photos = @parking.photos
    @guest_reviews = @parking.guest_reviews
  end

  def listing
  end

  def pricing
  end

  def description
  end

  def photo_upload
      @photos = @parking.photos
  end

  def amenities
  end

  def location
  end

  def update
    new_params = parking_params
    new_params = parking_params.merge(active: true) if is_ready_parking
    if @parking.update(new_params)
      flash[:notice] = "Saved..."
    else
      flash[:alert] = "Something went wrong..."
    end
    redirect_back(fallback_location: request.referer)
  end

  def destroy
  @parking.destroy
  flash[:notice] = "Successfully deleted that listing"
  redirect_to parkings_path
end

  def preload
    today = Date.today
    reservations = @parking.reservations.where("start_at >= ? OR end_at >= ?", today, today)

    render json: reservations
  end

  def preview
    start_at = Date.parse[params[:start_at]]
    end_at = Date.parse[params[:end_at]]

    output = {
      conflict: is_conflict(start_at, end_at, @parking)
    }

    render json: output
end

  private

    def is_conflict(start_at, end_at, parking)
      check = parking.reservations.where("? < start_at AND end_at < ?", start_at, end_at)
      check.size > 0? true : false
    end

    def set_parking
      @parking = Parking.find(params[:id])
    end

    def is_ready_parking
    !@parking.active && !@parking.price.blank? && !@parking.listing_name.blank? && !@parking.photos.blank? && !@parking.address.blank?
  end

    def parking_params
      params.require(:parking).permit(:space_type, :area, :square_footage, :spaces, :accessibility,
      :listing_name, :summary, :address, :is_electric, :is_water, :is_heating, :price, :active)
    end

    def is_authorized
      redirect_to root_path, alert: "You don't have permission" unless current_user.id == @parking.user_id
    end
end
