class Api::V1::ItemsController < ApplicationController
  def index
    if params[:merchant_id]
      merchant = Merchant.find(params[:merchant_id])
      @items = merchant.items
    else
      @items = Item.all
    end
    render json: @items
  end

  def show
    render json: Item.find(params[:id])
  end

  def create
    render json: Item.create(item_params)
  end

  def update
    render json: Item.update(item_params)
  end

  def destroy
    render json: Item.destroy(params[:id])
  end

  private
  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end