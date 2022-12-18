require "rails_helper"

RSpec.describe ISBN, type: :model do
  include_context "with book params"
  let(:normalized_isbn13) { ISBN.normalize(isbn13) }

  describe "valid?" do
    context "with ISBN-13" do
      it { expect(ISBN.valid?(isbn13)).to be_truthy }
    end

    context "with invalid ISBN-13" do
      it { expect(ISBN.valid?(isbn13.next)).to be_falsey }
    end
  end

  describe "invalid?" do
    context "with ISBN-13" do
      it { expect(ISBN.invalid?(isbn13)).to be_falsey }
    end

    context "with invalid ISBN-13" do
      it { expect(ISBN.invalid?(isbn13.next)).to be_truthy }
    end
  end

  describe "normalize" do
    it { expect(ISBN.normalize("123-456-789-x")).to eq("123456789X") }
  end

  describe "digitize" do
    it { expect(ISBN.digitize("123456789X")).to eq([1,2,3,4,5,6,7,8,9,0]) }
  end

  describe "checksum_thirteen" do
    it { expect(ISBN.checksum_thirteen [9,7,8,0,3,0,6,4,0,6,1,5]).to eq 7 }
  end

  describe "check_thirteen" do
    it "checks last digit" do 
      expect(ISBN.check_thirteen(*ISBN.digitize(normalized_isbn13))).to eq(true)
      expect(ISBN.check_thirteen(*ISBN.digitize(normalized_isbn13.next))).to eq(false)
    end
  end

  describe "thirteen" do
    it { expect(ISBN.thirteen(isbn13)).to eq(normalized_isbn13) }
  end

  describe "ten" do
    it { expect(ISBN.ten(isbn13)).to start_with(normalized_isbn13[3, 9]) }
  end
end
