class Review < ApplicationRecord
  belongs_to :parking
  belongs_to :reservation
end
