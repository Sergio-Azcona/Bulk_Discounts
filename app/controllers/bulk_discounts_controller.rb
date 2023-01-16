class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id]) 
  end

  def show
    @merchant = Merchant.find(params[:merchant_id]) 
    @discount = @merchant.bulk_discounts.find(params[:id])
    # require 'pry';binding.pry
  end

  def new
  end

  def create
  end
end