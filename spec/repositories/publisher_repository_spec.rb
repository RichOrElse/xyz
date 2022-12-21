require 'rails_helper'

RSpec.describe PublisherRepository, type: :repository do
  let!(:publisher) { Publisher.create!(name: "McSweeney’s") }
  let(:new_publisher) { Publisher.new(name: "Different") }

  describe "with" do
    it { expect(PublisherRepository.with(publisher.name)).to include(publisher) }
    it { expect(PublisherRepository.with(publisher.name.downcase)).to include(publisher) }
    it { expect(PublisherRepository.with(publisher.name.reverse)).to_not include(publisher) }
  end

  describe "fetch_or_add_with" do
    it { expect(PublisherRepository.fetch_or_add_with(publisher.name)).to eq(publisher) }
    it { expect(PublisherRepository.fetch_or_add_with(new_publisher.name)).to have_attributes(name: new_publisher.name) }
  end

  describe "fetch_or_build_with" do
    it { expect(PublisherRepository.fetch_or_build_with(publisher.name)).to eq(publisher) }
    it { expect(PublisherRepository.fetch_or_add_with("")).to have_attributes(name: "") }
  end

  describe "<<" do
    it { expect(PublisherRepository << publisher).to be_a(PublisherRepository) }
    it { expect { PublisherRepository << publisher.tap { publisher.name = "Changed" } }.to change { publisher.reload.name } }

    context "with new publisher" do
      it { expect { PublisherRepository << new_publisher}.to change(Publisher, :count) }

      context "but same name" do
        let(:new_publisher) { Publisher.new(name: publisher.name) }
        it { expect { PublisherRepository << new_publisher }.to_not change(Publisher, :count) }
        it { expect { PublisherRepository << new_publisher }.to change { new_publisher.errors.where(:name, :taken) } }
      end
    end
  end
end
