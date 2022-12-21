require 'rails_helper'

RSpec.describe AuthorRepository, type: :repository do
  let(:author_params) { { first_name: "Arthur", middle_name: "C.", last_name: "Clark" } }
  let(:author_full_name) { "Arthur C. Clark" }
  let!(:author) { Author.create!(author_params) }

  describe "with" do
    it { expect(AuthorRepository.with(author_full_name)).to include(author) }
    it { expect(AuthorRepository.with(author_full_name.downcase)).to include(author) }
  end

  describe "build_with" do
    it { expect(AuthorRepository.build_with(author_full_name)).to be_kind_of(Author).and have_attributes(author_params) }
  end
end
