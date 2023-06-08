class User < ApplicationRecord
  has_many :reservations, dependent: :destroy
  has_many :rooms, through: :reservations

  validates :username, :password, presence: true
  validates :email, presence: true, uniqueness: true
end
