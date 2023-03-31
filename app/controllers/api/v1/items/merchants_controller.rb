class Api::V1::Items::MerchantsController < ApplicationController
  def show
    item = Item.find(params[:item_id])
    if item.merchant.nil?
      render json: { errors: 'No Merchant Found' }, status: 404
    else
      render json: MerchantSerializer.new(item.merchant)
    end
  end
end