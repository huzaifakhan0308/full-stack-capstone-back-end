class User < ApplicationRecord
  has_secure_password
  has_many :reservations, foreign_key: 'users_id', dependent: :destroy
  has_many :rooms, foreign_key: 'users_id', dependent: :destroy

  validates :username, presence: true, uniqueness: true
end
