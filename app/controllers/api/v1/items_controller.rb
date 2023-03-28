class Api::V1::ItemsController < ApplicationController
  def index
    if params[:merchant_id]
      @merchant = Merchant.find(params[:merchant_id])
      @items = @merchant.items
    else
      @items = Item.all
    end
    render json: @items
  end

  def show
    render json: Item.find(params[:id])
  end
end