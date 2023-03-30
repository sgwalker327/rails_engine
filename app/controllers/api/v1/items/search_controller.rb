class Api::V1::Items::SearchController < ApplicationController
  def index
    if params[:min_price] && params[:max_price]
      @item = Item.price_range_search(params[:min_price], params[:max_price])
    elsif params[:name]
      @item = Item.name_search(params[:name])
    elsif params[:min_price]
      @item = Item.min_price_search(params[:min_price])
    elsif params[:max_price]
      @item = Item.max_price_search(params[:max_price])
    else
      render json: { error: 'Invalid Search' }, status: 200
    end
    render json: ItemSerializer.new(@item)
  end
end