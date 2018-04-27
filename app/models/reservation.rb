class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :parking

  after_create_commit :create_notification

  private

  def created_notifcation
    type = self.room.Instant? ? "New Booking" : "New Request"
    guest = User.find(self.user_id)

    Notification.create(content: "#{type} from #{guest.fullname}", user_id: self.room.user_id)
  end
end
