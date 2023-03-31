require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_numericality_of(:merchant_id) }
  end

  describe 'class methods' do
    describe '.name_search' do
      it 'returns all items that matches the search term, case insensitive, alphabetical order' do
        merchant1 = create(:merchant)
        merchant2 = create(:merchant)
        merchant3 = create(:merchant)
        item1 = create(:item, name: 'bike', merchant_id: merchant1.id)
        item2 = create(:item, name: 'block', merchant_id: merchant1.id)
        item3 = create(:item, name: 'Bark', merchant_id: merchant2.id)
        item4 = create(:item, name: 'Branch', merchant_id: merchant2.id)
        item5 = create(:item, name: 'clock', merchant_id: merchant3.id)
        item6 = create(:item, name: 'Desk', merchant_id: merchant3.id)
        
        expect(Item.name_search('b')).to eq([item3, item1, item2, item4])
      end
    end

    describe '.min_price_search' do
      it 'returns all items that are greater than or equal to the min price, alphabetical order, case insensitive' do
        merchant1 = create(:merchant)
        merchant2 = create(:merchant)
        merchant3 = create(:merchant)
        item1 = create(:item, name: "Pin", unit_price: 2.00, merchant_id: merchant1.id)
        item2 = create(:item, name: "picture", unit_price: 4.50, merchant_id: merchant1.id)
        item3 = create(:item, name: "apron", unit_price: 8.00, merchant_id: merchant2.id)
        item4 = create(:item, name: "Ab wheel", unit_price: 10.00, merchant_id: merchant2.id)
        item5 = create(:item, name: "Brush", unit_price: 15.00, merchant_id: merchant3.id)
        item6 = create(:item, name: "Shorts", unit_price: 20.00, merchant_id: merchant3.id)

        expect(Item.min_price_search(10.00).compact).to eq([item4, item5, item6])
      end
    end

    describe '.max_price_search' do
      it 'returns all items that are less than or equal to the max price, alphabetical order, case insensitive' do
        merchant1 = create(:merchant)
        merchant2 = create(:merchant)
        merchant3 = create(:merchant)
        item1 = create(:item, name: "Pin", unit_price: 2.00, merchant_id: merchant1.id)
        item2 = create(:item, name: "picture", unit_price: 4.50, merchant_id: merchant1.id)
        item3 = create(:item, name: "apron", unit_price: 8.00, merchant_id: merchant2.id)
        item4 = create(:item, name: "Ab wheel", unit_price: 10.00, merchant_id: merchant2.id)
        item5 = create(:item, name: "Brush", unit_price: 15.00, merchant_id: merchant3.id)
        item6 = create(:item, name: "Shorts", unit_price: 20.00, merchant_id: merchant3.id)

        expect(Item.max_price_search(10.00).compact).to eq([item4, item3, item2, item1])
      end
    end

    describe '.max_price_search' do
      it 'returns all items that are less than or equal to the max price, alphabetical order, case insensitive' do
        merchant1 = create(:merchant)
        merchant2 = create(:merchant)
        merchant3 = create(:merchant)
        item1 = create(:item, name: "Pin", unit_price: 2.00, merchant_id: merchant1.id)
        item2 = create(:item, name: "picture", unit_price: 4.50, merchant_id: merchant1.id)
        item3 = create(:item, name: "apron", unit_price: 8.00, merchant_id: merchant2.id)
        item4 = create(:item, name: "Ab wheel", unit_price: 10.00, merchant_id: merchant2.id)
        item5 = create(:item, name: "Brush", unit_price: 15.00, merchant_id: merchant3.id)
        item6 = create(:item, name: "Shorts", unit_price: 20.00, merchant_id: merchant3.id)

        expect(Item.price_range_search(3.00, 15.00).compact).to eq([item4, item3, item5, item2])
      end
    end
  end
end