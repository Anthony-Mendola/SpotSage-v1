class PagesController < ApplicationController
  def home
    @parkings = Parking.where(active: true).limit(3)
  end

#used session to remember user's search criteria, so they don't have retype the loc again.
  def search
    if params[:search].present? && params[:search].strip != ""
      session[:loc_search] = params[:search]
    end

    #displays all the parking spaces near the location search
    if session[:loc_search] && session[:loc_search] != ""
      @parkings_address = Parking.where(active: true).near(session[:loc_search], 2, order: 'distance')
    else
      @parkings_address = Parking.where(active: true).all #if no loc provided, displays all active listings
    end

    #uses ransack gem to apply search filters to search
    @search = @parkings_address.ransack(params[:q])
    @parkings = @search.result
    #turn to array
    @arrParkings = @parkings.to_a

    #time frame search
    if (params[:start_at] && params[:end_at] && !params[:start_at].empty? && !params[:end_at].empty?)

      start_at = Date.parse(params[:start_at])
      end_at = Date.parse(params[:end_at])

      @parkings.each do |parking|

        not_available = parking.reservations.where(
          "(? <= start_at AND start_at <= ?)
          OR (? <= end_at AND end_at <= ?)
          OR (start_at < ? AND ? < end_at)",
          start_at, end_at,
          start_at, end_at,
          start_at, end_at
        ).limit(1)
        #if date not available, removes listing from array above.
        if not_available.length > 0
          @arrParkings.delete(parking)
        end
      end
    end

  end
end
