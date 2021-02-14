class Photo < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  attachment :image
  
  validates :title, :body, :image, presence: true
end
