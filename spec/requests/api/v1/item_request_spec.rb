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
    
    expect(items[:data]).to be_an(Array)
    expect(items[:data].count).to eq(5)
    expect(items[:data][0].size).to eq(3)
    expect(items[:data][0][:attributes].size).to eq(4)
    expect(items[:data][0][:type]).to eq('item')
    expect(items[:data][0][:attributes].keys).to eq([:name, :description, :unit_price, :merchant_id])

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
    
    expect(item[:data]).to be_a(Hash)
    expect(item[:data][:id]).to eq(item1.id.to_s)
    expect(item[:data].size).to eq(3)
    expect(item[:data].keys).to eq([:id, :type, :attributes])
    expect(item[:data][:type]).to eq('item')
    expect(item[:data][:attributes].keys).to eq([:name, :description, :unit_price, :merchant_id])
    expect(item[:data][:attributes][:name]).to eq(item1.name)
    expect(item[:data][:attributes][:description]).to eq(item1.description)
    expect(item[:data][:attributes][:unit_price]).to eq(item1.unit_price)
    expect(item[:data][:attributes][:merchant_id]).to eq(item1.merchant_id)
  end

  it 'can create a new item' do
    merchant = create(:merchant)
    item1 = ({ name: "Item 1",
                description: "Description 1",
                unit_price: 1.00,
                merchant_id: merchant.id })

    headers = {"CONTENT_TYPE" => "application/json"}
      
    post api_v1_items_path(item1)
    
    new_item = Item.last

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item).to be_a(Hash)
    expect(item[:data].keys).to eq([:id, :type, :attributes])
    expect(item[:data][:type]).to eq("item")
    expect(item[:data][:attributes].keys).to eq([:name, :description, :unit_price, :merchant_id])
    expect(item[:data][:attributes][:name]).to eq("Item 1")
    expect(item[:data][:attributes][:description]).to eq("Description 1")
    expect(item[:data][:attributes][:unit_price]).to eq(1.00)
    expect(item[:data][:attributes][:merchant_id]).to eq(merchant.id)
  end

  it 'does not create an item if the params are incorrect' do
    merchant = create(:merchant)
    item1 = ({ name: "Item 1",
                description: "Description 1",
                unit_price: "five",
                merchant_id: merchant.id })

    headers = {"CONTENT_TYPE" => "application/json"}
      
    post api_v1_items_path(item1)

    expect(response).to have_http_status(400)
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

  it 'does not update an item if the merchant is invalid' do
    merchant = create(:merchant)
    item1 = create(:item, merchant_id: merchant.id)
    new_attributes = { merchant_id: "beaver" }
  
    patch api_v1_item_path(item1), params: new_attributes
    
    expect(response).to have_http_status(400)
  end

  it 'can get merchant data for an item' do
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    item1 = create(:item, merchant_id: merchant1.id)
    item2 = create(:item, merchant_id: merchant2.id)

    get api_v1_item_merchant_path(item1)

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)
    
    expect(merchant[:data]).to be_a(Hash)
    expect(merchant[:data].keys).to eq([:id, :type, :attributes])
    expect(merchant[:data][:attributes].keys).to eq([:name])
    expect(merchant[:data][:attributes][:name]).to eq(merchant1.name)
    expect(merchant[:data][:attributes][:name]).to_not eq(merchant2.name)
  end

  it "Won't create an item if all attributes are missing" do
    merchant = create(:merchant)
    item1 = ({ name: "",
                description: "",
                unit_price: "",
                merchant_id: "" })

    headers = {"CONTENT_TYPE" => "application/json"}
      
    post api_v1_items_path(item1)
    
    expect(response).to have_http_status(400)
  end

  it 'can find all items by name (case insensitive, alphabetical order, first result)' do
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    merchant3 = create(:merchant)
    item1 = create(:item, name: 'bike', merchant_id: merchant1.id)
    item2 = create(:item, name: 'block',merchant_id: merchant1.id)
    item3 = create(:item, name: 'Bark', merchant_id: merchant2.id)
    item4 = create(:item, name: 'Branch', merchant_id: merchant2.id)
    item5 = create(:item, name: 'clock', merchant_id: merchant3.id)
    item6 = create(:item, name: 'Desk', merchant_id: merchant3.id)

    get "/api/v1/items/find_all?name=b"

    expect(response).to be_successful
    
    items = JSON.parse(response.body, symbolize_names: true)
    # require 'pry'; binding.pry
    expect(items[:data]).to be_a(Array)
    expect(items[:data].size).to eq(4)
    expect(items[:data][0].keys).to include(:id, :type, :attributes)
    expect(items[:data][0][:type]).to eq('item')
    expect(items[:data][0][:attributes].size).to eq(4)
    expect(items[:data][0][:attributes].keys).to include(:name, :description, :unit_price, :merchant_id)
    expect(items[:data][0][:attributes][:name]).to eq(item3.name)
    expect(items[:data][1][:attributes][:name]).to eq(item1.name)
    expect(items[:data][2][:attributes][:name]).to eq(item2.name)
    expect(items[:data][3][:attributes][:name]).to eq(item4.name)
  end

  #tests below currently not passing postman tests
  it 'returns an error when no fragment is found' do
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    merchant3 = create(:merchant)
    item1 = create(:item, name: 'bike', merchant_id: merchant1.id)
    item2 = create(:item, name: 'block',merchant_id: merchant1.id)
    item3 = create(:item, name: 'Bark', merchant_id: merchant2.id)
    item4 = create(:item, name: 'Branch', merchant_id: merchant2.id)
    item5 = create(:item, name: 'clock', merchant_id: merchant3.id)
    item6 = create(:item, name: 'Desk', merchant_id: merchant3.id)

    get "/api/v1/items/find_all?name=but"
   
    expect(response.status).to eq(200)
  end

  it 'returns an error when nothing is searched' do
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    merchant3 = create(:merchant)
    item1 = create(:item, name: 'bike', merchant_id: merchant1.id)
    item2 = create(:item, name: 'block',merchant_id: merchant1.id)
    item3 = create(:item, name: 'Bark', merchant_id: merchant2.id)
    item4 = create(:item, name: 'Branch', merchant_id: merchant2.id)
    item5 = create(:item, name: 'clock', merchant_id: merchant3.id)
    item6 = create(:item, name: 'Desk', merchant_id: merchant3.id)

    get '/api/v1/items/find_all?name=""'

    expect(response.status).to eq(200)
  end

  it 'returns a list of items with a unit price greater than or equal to a given price' do
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    merchant3 = create(:merchant)
    item1 = create(:item, name: "Pin", unit_price: 2.00, merchant_id: merchant1.id)
    item2 = create(:item, name: "picture", unit_price: 4.50, merchant_id: merchant1.id)
    item3 = create(:item, name: "apron", unit_price: 8.00, merchant_id: merchant2.id)
    item4 = create(:item, name: "Ab wheel", unit_price: 10.00, merchant_id: merchant2.id)
    item5 = create(:item, name: "Brush", unit_price: 15.00, merchant_id: merchant3.id)
    item6 = create(:item, name: "Shorts", unit_price: 20.00, merchant_id: merchant3.id)

    get '/api/v1/items/find_all?min_price=8.00'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)
    
    expect(items[:data]).to be_a(Array)
    expect(items[:data].size).to eq(4)
    expect(items[:data][0].keys).to include(:id, :type, :attributes)
    expect(items[:data][0][:type]).to eq('item')
    expect(items[:data][0][:attributes].size).to eq(4)
    expect(items[:data][0][:attributes].keys).to include(:name, :description, :unit_price, :merchant_id)
    expect(items[:data][0][:attributes][:name]).to eq(item4.name)
    expect(items[:data][1][:attributes][:name]).to eq(item3.name)
    expect(items[:data][2][:attributes][:name]).to eq(item5.name)
    expect(items[:data][3][:attributes][:name]).to eq(item6.name)
  end

  it 'returns a list of items with a unit price less than or equal to a given price' do
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    merchant3 = create(:merchant)
    item1 = create(:item, name: "Pin", unit_price: 2.00, merchant_id: merchant1.id)
    item2 = create(:item, name: "picture", unit_price: 4.50, merchant_id: merchant1.id)
    item3 = create(:item, name: "apron", unit_price: 8.00, merchant_id: merchant2.id)
    item4 = create(:item, name: "Ab wheel", unit_price: 10.00, merchant_id: merchant2.id)
    item5 = create(:item, name: "Brush", unit_price: 15.00, merchant_id: merchant3.id)
    item6 = create(:item, name: "Shorts", unit_price: 20.00, merchant_id: merchant3.id)

    get '/api/v1/items/find_all?max_price=8.00'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)
    
    expect(items[:data]).to be_a(Array)
    expect(items[:data].size).to eq(3)
    expect(items[:data][0].keys).to include(:id, :type, :attributes)
    expect(items[:data][0][:type]).to eq('item')
    expect(items[:data][0][:attributes].size).to eq(4)
    expect(items[:data][0][:attributes].keys).to include(:name, :description, :unit_price, :merchant_id)
    expect(items[:data][0][:attributes][:name]).to eq(item3.name)
    expect(items[:data][1][:attributes][:name]).to eq(item2.name)
    expect(items[:data][2][:attributes][:name]).to eq(item1.name)
  end

  it 'returns a list of items with a unit price less than or equal to a given price' do
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    merchant3 = create(:merchant)
    item1 = create(:item, name: "Pin", unit_price: 2.00, merchant_id: merchant1.id)
    item2 = create(:item, name: "picture", unit_price: 4.50, merchant_id: merchant1.id)
    item3 = create(:item, name: "apron", unit_price: 8.00, merchant_id: merchant2.id)
    item4 = create(:item, name: "Ab wheel", unit_price: 10.00, merchant_id: merchant2.id)
    item5 = create(:item, name: "Brush", unit_price: 15.00, merchant_id: merchant3.id)
    item6 = create(:item, name: "Shorts", unit_price: 20.00, merchant_id: merchant3.id)

    get '/api/v1/items/find_all?max_price=15.00&min_price=5.00'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)
    
    expect(items[:data]).to be_a(Array)
    expect(items[:data].size).to eq(3)
    expect(items[:data][0].keys).to include(:id, :type, :attributes)
    expect(items[:data][0][:type]).to eq('item')
    expect(items[:data][0][:attributes].size).to eq(4)
    expect(items[:data][0][:attributes].keys).to include(:name, :description, :unit_price, :merchant_id)
    expect(items[:data][0][:attributes][:name]).to eq(item4.name)
    expect(items[:data][1][:attributes][:name]).to eq(item3.name)
    expect(items[:data][2][:attributes][:name]).to eq(item5.name)
  end

  it 'returns an array when name and price are searced at the same time' do
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    merchant3 = create(:merchant)
    item1 = create(:item, name: "Pin", unit_price: 2.00, merchant_id: merchant1.id)
    item2 = create(:item, name: "picture", unit_price: 4.50, merchant_id: merchant1.id)
    item3 = create(:item, name: "apron", unit_price: 8.00, merchant_id: merchant2.id)
    item4 = create(:item, name: "Ab wheel", unit_price: 10.00, merchant_id: merchant2.id)
    item5 = create(:item, name: "Brush", unit_price: 15.00, merchant_id: merchant3.id)
    item6 = create(:item, name: "Shorts", unit_price: 20.00, merchant_id: merchant3.id)

    get '/api/v1/items/find_all?name="a"&min_price=5.00'
    # require 'pry'; binding.pry
    expect(response.status).to eq(400)
    # require 'pry'; binding.pry
  end

  it 'returns an error when a price less than 0 is searched' do
    get '/api/v1/items/find_all?min_price=-8.00'

    expect(response.status).to eq(400)
  end
end