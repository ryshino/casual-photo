class Photo < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  attachment :image
  
  validates :title, :body, :image, presence: true
  validates :title, length: { maximum: 20 }
  validates :body, length: { maximum: 150 }
end
