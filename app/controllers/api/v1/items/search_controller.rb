class Api::V1::Items::SearchController < ApplicationController
  def index
    if params[:name] && (params[:min_price] || params[:max_price])
      render json: { errors: 'Invalid Search' }, status: 400
    elsif params[:min_price].to_f > 0 && params[:max_price].to_f > 0
      item = Item.price_range_search(params[:min_price], params[:max_price])
      render json: ItemSerializer.new(item)
    elsif params[:name]
      item = Item.name_search(params[:name])
      render json: ItemSerializer.new(item)
    elsif params[:min_price].to_f > 0
      item = Item.min_price_search(params[:min_price])
      render json: ItemSerializer.new(item)
    elsif params[:max_price].to_f > 0
      item = Item.max_price_search(params[:max_price])
      render json: ItemSerializer.new(item)
    else
      render json: { errors: 'Invalid Search' }, status: 400
    end
  end
end