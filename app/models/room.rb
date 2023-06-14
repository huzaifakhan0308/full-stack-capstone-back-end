class Room < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: 'users_id'
  has_many :reservations, foreign_key: 'rooms_id', dependent: :destroy
  validates :room_name, :description, :room_service, :beds, :image_url, presence: true
  after_create :increment_user_rooms_count
  after_destroy :decrement_user_rooms_count
  private
  def increment_user_rooms_count
    user.increment!(:rooms_count)
  end
  def decrement_user_rooms_count
    user.decrement!(:rooms_count)
  end
end