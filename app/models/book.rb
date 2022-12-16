class Book < ApplicationRecord
  belongs_to :publisher
  belongs_to :author

  validates :isbn13, :title, :list_price, :publication_year, presence: true
  validates :isbn13, uniqueness: { case_sensitive: false }, length: { maximum: 17 }
end
