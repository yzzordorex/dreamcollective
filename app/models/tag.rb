class Tag < ApplicationRecord
  has_many :taggings
  has_many :dreams, through: :taggings
end
