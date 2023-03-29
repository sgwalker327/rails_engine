class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    # if params[:item_id]
    #   merchant = Item.find(params[:item_id]).merchant
    #   render json: MerchantSerializer.new(merchant)
    # else
      render json: MerchantSerializer.new(Merchant.find(params[:id]))
    
  end
end