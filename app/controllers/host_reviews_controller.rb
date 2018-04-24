class HostReviewsController < ApplicationController

  def create
    #Checks if the reservation exists (parking_id, guest_id, host_id)
    #if it exists, checks if the current host already reviewed the guest in this reservation

    @reservation = Reservation.where(
                  id: host_review_params[:reservation_id],
                  parking_id: host_review_params[:parking_id],
                  user_id: host_review_params[:guest_id]
                 ).first

   if !@reservation.nil?

    @has_reviewed = HostReview.where(
                      reservation_id: @reservation.id,
                      guest_id: host_review_params[:guest_id]
                    ).first

    if @has_reviewed.nil?
        # Allow to review
        @host_review = current_user.host_reviews.create(host_review_params)
        flash[:success] = "Review created..."
    else
        # Already reviewed
        flash[:success] = "You already reviewed this reservation"
      end
    else
      flash[:alert] = "Reservation not found"
    end

    redirect_back(fallback_location: request.referer)
  end

  def destroy
      @host_review = Review.find(params[:id])
      @host_review.destroy

      redirect_back(fallback_location: request.referer, notice: "Deleted...!")
    end


  private
    def host_review_params
      params.require(:host_review).permit(:comment, :star, :parking_id, :reservation_id, :guest_id)
    end
end
