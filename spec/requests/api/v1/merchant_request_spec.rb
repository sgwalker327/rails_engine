require 'rails_helper'

RSpec.describe 'Merchant API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 3)

    get api_v1_merchants_path

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)
    
    expect(merchants[:data]).to be_an(Array)
    expect(merchants[:data].size).to eq(3)
    expect(merchants[:data][0].keys).to eq([:id, :type, :attributes])
    expect(merchants[:data][0][:attributes][:name]).to eq(Merchant.first.name)
  end

  it 'can get one merchant by its id' do
    merchant1 = create(:merchant, id: 1)
    merchant2 = create(:merchant, id: 2)

    get api_v1_merchant_path(merchant1)

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant[:data][:type]).to eq('merchant')
    expect(merchant[:data][:attributes].size).to eq(1)
    expect(merchant[:data][:attributes][:name]).to eq(merchant1.name)
  end

  it 'can get all items for a merchant' do
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)

    item1 = create(:item, merchant_id: merchant1.id)
    item2 = create(:item, merchant_id: merchant1.id)
    item3 = create(:item, merchant_id: merchant2.id)

    get api_v1_merchant_items_path(merchant1)

    items = JSON.parse(response.body, symbolize_names: true)
    # require 'pry'; binding.pry
    expect(items[:data].size).to eq(2)
    expect(items[:data].first[:id]).to eq(item1.id.to_s)
    expect(items[:data].last[:id]).to eq(item2.id.to_s)
    expect(items[:data].first[:attributes].size).to eq(4)
    expect(items).to_not include(item3)
  end
end