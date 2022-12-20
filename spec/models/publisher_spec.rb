require 'rails_helper'

RSpec.describe Publisher, type: :model do
  subject { Publisher.new(name: 'XYZ') }

  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  context 'database' do
    it { is_expected.to have_many :books }
    it { is_expected.to have_db_column(:name).with_options(null: false) }
    xit { is_expected.to have_db_index('lower(name)').unique }
  end
end
