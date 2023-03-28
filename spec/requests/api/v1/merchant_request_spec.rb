require 'rails_helper'

RSpec.describe 'Merchant API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 3)

    get api_v1_merchants_path

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants.count).to eq(3)

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(Integer)

      expect(merchant).to have_key(:name)
      expect(merchant[:name]).to be_a(String)
    end
  end

  it 'can get one merchant by its id' do
    merchant1 = create(:merchant, id: 1)
    merchant2 = create(:merchant, id: 2)

    get api_v1_merchant_path(merchant1)

    merchant = JSON.parse(response.body, symbolize_names: true)
   
    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to eq(merchant1.id)

    expect(merchant).to have_key(:name)
    expect(merchant[:name]).to eq(merchant1.name)
  end

  it 'can get all items for a merchant' do
    merchant = create(:merchant)
    item1 = create(:item, merchant_id: merchant.id)
    item2 = create(:item, merchant_id: merchant.id)
    item3 = create(:item, merchant_id: merchant.id)

    get api_v1_merchant_items_path(merchant)

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items.count).to eq(3)
    expect(items.first[:id]).to eq(item1.id)
    expect(items.last[:id]).to eq(item3.id)
  end
end