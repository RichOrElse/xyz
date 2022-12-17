require 'rails_helper'

RSpec.describe Book, type: :model do
  subject { Book.new(publisher: publisher, authors: [author], isbn13: isbn13, title: title, publication_year: 2022, list_price: 3000) }
  let(:author) { Author.new(first_name: "Rainer", middle_name: "Steel", last_name: "Rilke") }
  let(:publisher) { Publisher.new(name: "McSweeney's") }
  let(:isbn13) { "978-1-60309-398-9" }
  let(:title) { "The Underwater Welder" }

  context 'validations' do
    it { is_expected.to validate_presence_of(:authors) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:list_price) }
    it { is_expected.to validate_presence_of(:publication_year) }
    it { is_expected.to validate_presence_of(:isbn13) }
    it { is_expected.to validate_length_of(:isbn13).is_at_most(17) }
    it { is_expected.to validate_uniqueness_of(:isbn13).case_insensitive }
  end

  context 'database' do
    it { is_expected.to belong_to :publisher }
    it { is_expected.to have_and_belong_to_many :authors }
    it { is_expected.to have_db_column(:title).with_options(null: false) }
    it { is_expected.to have_db_column(:isbn13).with_options(null: false) }
    it { is_expected.to have_db_index(:title) }
    it { is_expected.to have_db_index("upper(replace(isbn13,'-',''))").unique }
  end
end
