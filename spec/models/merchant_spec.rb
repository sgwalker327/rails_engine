require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many(:items) }
    it { should have_many(:invoices) }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:customers).through(:invoices) }
  end

  describe 'class methods' do
    describe '.name_search' do
      it 'returns the first merchant that matches the search term, case insensitive, alphabetical order' do
        merchant1 = create(:merchant, name: 'Walmart')
        merchant2 = create(:merchant, name: 'Walgreens')
        merchant3 = create(:merchant, name: "It's a Puzzle Store")

        expect(Merchant.name_search('Wal')).to eq(merchant2)
      end
    end
  end
end