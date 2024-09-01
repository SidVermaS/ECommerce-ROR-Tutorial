class Book < ApplicationRecord
  validates :title, presence: true, length: { minimum: 2, maximum: 32 }
  belongs_to :author
end
