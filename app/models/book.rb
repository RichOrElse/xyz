class Book < ApplicationRecord
  attribute :list_price, :decimal

  belongs_to :publisher
  has_and_belongs_to_many :authors

  validates :isbn13, :title, :list_price, :publication_year, :authors, presence: true
  validates :isbn13, length: { maximum: 17 }
end
