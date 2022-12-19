class Author < ApplicationRecord
  include ComposingOf[full_name: FullName]

  has_and_belongs_to_many :books

  validates :first_name, :last_name, presence: true
end
