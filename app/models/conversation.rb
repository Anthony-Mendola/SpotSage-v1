class Conversation < ApplicationRecord
  belongs_to :sender, foreign_key: :sender_id, class_name: "User"
  belongs_to :recipient, foreign_key: :recipient_id, class_name: "User"

  has_many :messages, dependent: :destroy
  validates_uniqueness_of :sender_id, :recipient_id

#returns entire convo regarless if sender or recipient
  scope :involving, -> (user) {
    where("conversations.sender_id = ? OR conversations.recipient_id = ?", user.id, user.id)
  }

#checks if there is a conversation existing between 2 users
  scope :between -> (user_A, user_B) {
    where("(conversations.sender_id = ? OR conversations.recipient_id = ?) OR conversations.sender_id = ? OR conversations.recipient_id = ?", user_A, user_B, user_B, user_A)
  }
end
