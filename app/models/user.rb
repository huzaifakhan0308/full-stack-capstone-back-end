class User < ApplicationRecord
  has_secure_password
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :reservations, foreign_key: 'users_id', dependent: :destroy
  has_many :rooms, foreign_key: 'users_id', dependent: :destroy

  validates :username, presence: true, uniqueness: true
end
