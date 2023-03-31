class Api::V1::Merchants::SearchController < ApplicationController
  def show
    merchant = Merchant.name_search(params[:name])
    if merchant.nil?
      render json: { errors: 'Invalid Search', data: {} }, status: 200
    else
      render json: MerchantSerializer.new(merchant)
    end
  end
end