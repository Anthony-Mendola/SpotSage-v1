class Parking < ApplicationRecord
  belongs_to :user
  has_many :photos
  has_many :reservations

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  validates :space_type, presence: true
  validates :area, presence: true
  validates :square_footage, presence: true
  validates :spaces, presence: true
  validates :accessibility, presence: true

  def cover_photo(size)
      if self.photos.length > 0
        self.photos[0].image.url(size)
      else
        "blank.jpg"
      end
    end
end
