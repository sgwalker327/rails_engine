class Api::V1::Merchants::SearchController < ApplicationController
  def index
    @merchants = Merchant.name_search(params[:name])
    render json: MerchantSerializer.new(@merchants)
  end
end