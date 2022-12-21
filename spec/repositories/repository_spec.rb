require 'rails_helper'

RSpec.describe Repository, type: :repository do
  subject(:repository) { Repository.new(Publisher.all) }
  let(:attributes) { { name: "Some Publisher" } }
  let(:last_publisher) { publishers.last }
  let(:publisher) { publishers.first }
  let!(:publishers) do
    Publisher.create! ["Paste Magazine", "Publishers Weekly", "Graywolf Press"].map { |name| { name: name } }
  end

  describe "with" do
    it { expect(repository.with(publisher.id)).to include(publisher) }
    it { expect(repository.with(last_publisher.id.next)).to be_empty }
  end

  describe "without" do
    it { expect(repository.without(publisher.id)).to_not include(publisher) }
    it { expect(repository.without(last_publisher.id.next)).to include(publisher, last_publisher) }
  end

  describe "at" do
    it { expect(repository.at(publisher.id)).to eq(publisher) }
    it { expect(repository.at(last_publisher.id.next)).to be_nil }
  end

  describe "fetch" do
    it { expect(repository.fetch(publisher.id)).to eq(publisher) }
    it { expect(repository.fetch(last_publisher.id.next)).to be_nil }
    it { expect(repository.fetch(last_publisher.id.next, :fallback)).to eq :fallback }
  end

  describe "<<" do
    it { expect(repository << last_publisher).to eq(repository) }
    it { expect { repository << Publisher.new(attributes) }.to change(Publisher, :count) }
    it { expect { repository << Publisher.new(name: "") }.to_not change(Publisher, :count) }
    it { expect { repository << publisher.tap { publisher.attributes = attributes } }.to change { publisher.reload.name } }
  end
end
