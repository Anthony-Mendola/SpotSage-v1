class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @parkings = @user.parkings
  end
end
