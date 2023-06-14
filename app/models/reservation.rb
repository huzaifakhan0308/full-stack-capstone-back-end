class Reservation < ApplicationRecord
  belongs_to :rooms, class_name: 'Room'
  belongs_to :users, class_name: 'User'
  validates :from_date, :to_date, :city, presence: true
end