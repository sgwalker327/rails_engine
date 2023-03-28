require 'rails_helper'

RSpec.describe 'Items API' do
  it "sends a list of items" do
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    create_list(:item, 3, merchant_id: merchant1.id)
    create_list(:item, 2, merchant_id: merchant2.id)

    get api_v1_items_path

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)
    # require 'pry'; binding.pry
    expect(items.count).to eq(5)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(Integer)

      expect(item).to have_key(:name)
      expect(item[:name]).to be_an(String)

      expect(item).to have_key(:description)
      expect(item[:description]).to be_an(String)

      expect(item).to have_key(:unit_price)
      expect(item[:unit_price]).to be_an(Float)

      expect(item).to have_key(:merchant_id)
      expect(item[:merchant_id]).to be_an(Integer)
    end
  end

  it 'sends one item by its id' do
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    item1 = create(:item, merchant_id: merchant1.id)
    item2 = create(:item, merchant_id: merchant1.id)
    item3 = create(:item, merchant_id: merchant2.id)

    get api_v1_item_path(item1)

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item).to have_key(:merchant_id)
    expect(item[:merchant_id]).to eq(item1.merchant_id)
  end

  it 'can create a new item' do
    merchant = create(:merchant)
    item1 = { name: "Item 1", description: "Description 1", unit_price: 1.00, merchant_id: merchant.id }

    post api_v1_items_path(item1)

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item).to have_key(:id)
    expect(item[:name]).to eq("Item 1")
    expect(item[:description]).to eq("Description 1")
    expect(item[:unit_price]).to eq(1.00)
    expect(item[:merchant_id]).to eq(merchant.id)
  end

  it 'can update an existing item' do
    merchant = create(:merchant)
    item1 = create(:item, name: 'Old Name', merchant_id: merchant.id)
    item2 = create(:item, name: 'Thing-a-ma-gig', merchant_id: merchant.id)
    new_attributes = { name: 'New Name' }

    patch api_v1_item_path(item1), params: new_attributes

    expect(response).to be_successful

    item = Item.find_by(id: item1.id)
    
    expect(response).to be_successful
    expect(item[:name]).to_not eq('Old Name')
    expect(item[:name]).to eq('New Name')
    expect(item[:name]).to_not eq('Thing-a-ma-gig')
  end

  it 'can destroy an item' do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)

    expect(Item.count).to eq(1)

    delete api_v1_item_path(item)

    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(item.id).to raise_error(ActiveRecord::RecordNotFound)}
  end
end