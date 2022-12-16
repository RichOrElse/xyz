class Publisher < ApplicationRecord
  has_many :books

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
