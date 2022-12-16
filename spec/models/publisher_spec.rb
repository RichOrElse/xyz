require 'rails_helper'

RSpec.describe Publisher, type: :model do
  subject { Publisher.new(name: 'XYZ') }

  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end

  context 'database' do
    it { is_expected.to have_db_column(:name).with_options(null: false) }
    it { is_expected.to have_db_index('lower(name)').unique }
  end
end
