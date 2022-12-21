require 'rails_helper'

RSpec.describe AuthorRepository, type: :repository do
  let(:author_params) { { first_name: "Arthur", middle_name: "C.", last_name: "Clark" } }
  let!(:author) { Author.create!(author_params) }

  describe "with" do
    it { expect(AuthorRepository.with("Arthur C. Clark")).to include(author) }
    it { expect(AuthorRepository.with("Arthur C. Clark".downcase)).to include(author) }
    it { expect(AuthorRepository.with("Arthur Clark")).to include(author) }
  end
end
