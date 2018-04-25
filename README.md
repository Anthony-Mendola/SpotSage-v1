# README

## About
SpotSage is a full-stack web application originally created as my rails project as a student of Flat Iron School. I was inspired by the difficult parking situation here in NYC and wanted to create something that people can actually use to find parking easily. My vision for the app was to make it the airbnb or bookings.com version of parking. Many of my style elements were inspired from airbnb's github style guide.

## Technologies

* Ruby on Rails
* HTML
* CSS
* Bootstrap
* SqlLite
* JQuery
* AWS S3 (setup for asset storage)
* **APIs:** Google Maps, Google Places

### Features
- User Authentication using Devise
- Sign-up with Facebook
- Using smtp for user sign-up confirmation email
- Pages to edit profile, create/edit listing, & reservations
- Search parking spaces with Google Maps and filter results
- Uploading photos with AJAX
- Reviews on listings
- JQuery User Interface controls



## Issue 1 that was overcome
Figuring out the best way to reserve a parking space and not let another user reserve it for the same date. I used JQuery and AJAX. For this to work, when a parking space listing page is loaded, a request is sent to AJAX. In my controller, I used a preload action which gets the specific listing and it's reservations . Then it returns the reservations to JQuery DatePicker in JSON format. The reserved dates are then disabled/grayed out in the DatePicker calendar.
Sample of the code:
````
In reservations view form:
$.ajax({
  url: '<%= preload_parking_path(@parking) %>', #Runs the preload action in the controller with params parking_id
  dateTyp: 'json',
  success: function(data) {
  #data variable above is the reservation in JSON   
  #below loops through each reservation and pushes unavailableDates to datepicker
  $.each(data, function(arrID, arrValue) {
      for(var d = new Date(arrValue.start_at); d <= new Date(arrValue.end_at); d.setDate(d.getDate() + 1)) {
        unavailableDates.push($.datepicker.formatDate('d-m-yy', d));
      }
  });

  In ParkingsController:
  def preload
  @parking = Parking.find(params[:id])
    today = Date.today
    reservations = @parking.reservations.where("start_at >= ? OR end_at >= ?", today, today)

    render json: reservations
  end
 ````
## Issue 2 that was overcome

Used AJAX & JSON to improve the google maps and filter search feature so that the page doesn't need to be reloaded for results.

## What's next for the app?

Adding time limits to reservations
Messaging
