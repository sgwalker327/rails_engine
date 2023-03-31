class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    merchant = Merchant.find(params[:merchant_id])
    if merchant.items.empty?
      render json: { errors: 'No Items Found' }, status: 404
    else
      render json: ItemSerializer.new(merchant.items)
    end
  end
end