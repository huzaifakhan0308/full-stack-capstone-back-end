class Room < ApplicationRecord
  belongs_to :user
  has_many :reservations
  has_many :users, through: :reservations

  validates :room_name, :description, :room_service, :beds, :image_url, presence: true
end
