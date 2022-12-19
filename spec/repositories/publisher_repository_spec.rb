require 'rails_helper'

RSpec.describe PublisherRepository, type: :repository do
  let!(:publisher) { Publisher.create!(name: "McSweeney’s") }

  describe "with" do
    it { expect(PublisherRepository.with(publisher.name)).to include(publisher) }
    it { expect(PublisherRepository.with(publisher.name.downcase)).to include(publisher) }
    it { expect(PublisherRepository.with(publisher.name.reverse)).to_not include(publisher) }
  end

  describe "[]" do
    it { expect(PublisherRepository[publisher.name]).to be_a(Publisher).and have_attributes(name: publisher.name) }
  end

  describe "<<" do
    it { expect(PublisherRepository << publisher).to be_a(PublisherRepository) }
    it { expect { PublisherRepository << publisher.tap { publisher.name = "Changed" } }.to change { publisher.reload.name } }

    context "with new publisher" do
      context "different name" do
        let(:new_publisher) { Publisher.new(name: "Different") }
        it { expect { PublisherRepository << new_publisher}.to change(Publisher, :count) }
      end

      context "but same name" do
        let(:new_publisher) { Publisher.new(name: publisher.name) }
        it { expect { PublisherRepository << new_publisher }.to_not change(Publisher, :count) }
        it { expect { PublisherRepository << new_publisher }.to change { new_publisher.errors.where(:name, :taken) } }
      end
    end
  end
end
