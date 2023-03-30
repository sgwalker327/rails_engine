class Api::V1::Merchants::SearchController < ApplicationController
  def index
    merchant = Merchant.name_search(params[:name])
    # require 'pry'; binding.pry
    if merchant.nil?
      render json: { error: 'Invalid Search' }, status: 400
    else
      render json: MerchantSerializer.new(merchant)
    end
  end
end