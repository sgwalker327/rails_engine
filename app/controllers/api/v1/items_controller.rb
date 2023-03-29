class Api::V1::ItemsController < ApplicationController
  def index
      @items = Item.all
    # end
    render json: ItemSerializer.new(Item.all)
  end

  def show
    item = Item.find(params[:id])
    render json: ItemSerializer.new(item)
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: 201
    else
      render json: { error: 'Invalid Data' }, status: 400
    end
  end

  def update
    item = Item.find(params[:id])
    
      if item.update(item_params)
        render json: ItemSerializer.new(item), status: 201
      else
        render json: { error: 'Invalid Data' }, status: 400
      end
  end

  def destroy
    render json: Item.destroy(params[:id])
  end

  private
  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end