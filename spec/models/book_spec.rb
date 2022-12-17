require 'rails_helper'

RSpec.describe Book, type: :model do
  include_context "with book params"
  subject { Book.new(book_params) }

  it { is_expected.to have_attributes(publisher_name: publisher.name) }

  context 'validations' do
    it { is_expected.to validate_presence_of(:authors) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:list_price) }
    it { is_expected.to validate_presence_of(:publication_year) }
    it { is_expected.to validate_presence_of(:isbn13) }
    it { is_expected.to validate_length_of(:isbn13).is_at_most(17) }
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
