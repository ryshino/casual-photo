class User < ApplicationRecord
  has_many :photos, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  validates :profile, length: { maximum: 280 }
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  
  attachment :profile_image

  has_secure_password
      
  def already_favorited?(favorite, current_user_id)
    favorite.pluck(:user_id).include?(current_user_id)
  end
end
