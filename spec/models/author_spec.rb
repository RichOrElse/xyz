require 'rails_helper'

RSpec.describe Author, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to allow_value("", nil).for(:middle_name) }
  end

  context 'database' do
    it { is_expected.to have_db_column(:first_name).with_options(null: false) }
    it { is_expected.to have_db_column(:last_name).with_options(null: false) }
    it { is_expected.to have_db_column(:middle_name) }
  end
end
