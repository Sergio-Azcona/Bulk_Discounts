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
    @merchant = Merchant.find(params[:merchant_id]) 
    @discount = @merchant.bulk_discounts.new
    # require 'pry';binding.pry
  end

  def create
    @merchant = Merchant.find(params[:merchant_id]) 
    @discount = @merchant.bulk_discounts.create(discount_params)

    if @discount.save
      flash.notice = "Update Successful"
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      flash.notice = "NOT Successful. Please Try Again"
      render :new
    end
  end




  private

  def discount_params
    params.permit(:name, :quantity, :percentage)
  end
end