class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @parkings = @user.parkings

    #shows all the guest reviews if the user is a host
    @guest_reviews = Review.where(type: "GuestReview", host_id: @user.id)

    #shows all the host reviews if the user is a guest
    @guest_reviews = Review.where(type: "HostReview", guest_id: @user.id)
  end
end
