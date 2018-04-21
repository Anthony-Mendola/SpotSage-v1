class ReservationsController < ApplicationController
  before_action :authenticate_user!

  def create
    parking = Parking.find(params[:parking_id])

    if current_user == parking.user
      flash[:alert] = "You cannot book your own property!"
    else
      start_at = Date.parse(reservation_params[:start_at])
      end_at = Date.parse(reservation_params[:end_at])
      days = (end_at - start_at).to_i + 1

      @reservation = current_user.reservations.build(reservation_params)
      @reservation.parking = parking
      @reservation.price = parking.price
      @reservation.total = parking.price * days
      @reservation.save

      flash[:notice] = "Booked Successfully!"
    end
    redirect_to parking
  end

  def your_trips
    @trips = current_user.reservations.order(start_at: :asc)
  end

  def your_reservations
    @parkings = current_user.parkings
  end

  private
    def reservation_params
      params.require(:reservation).permit(:start_at, :end_at)
    end
end
