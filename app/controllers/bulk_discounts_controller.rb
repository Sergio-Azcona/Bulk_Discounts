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
    @new_discount = @merchant.bulk_discounts.new
  end

  def create
    @merchant = Merchant.find(params[:merchant_id]) 
    @new_discount = @merchant.bulk_discounts.create(discount_params)

    if @new_discount.save
      flash.notice = "Update Successful"
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      flash.notice = "Unsuccessful - Please Try Again"
      render :new
    end
  end
  
  def edit
    @merchant = Merchant.find(params[:merchant_id]) 
    @editing_discount = @merchant.bulk_discounts.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id]) 
    @editing_discount = @merchant.bulk_discounts.find(params[:id])
    @editing_discount.update(discount_params)

    if @editing_discount.save
      flash.notice = "Update Successful"
      redirect_to merchant_bulk_discount_path(@merchant, @editing_discount)
    else
      flash.notice = "Unsuccessful - Please Try Again"
      render :edit
    end
  end

  def destroy
    @merchant = Merchant.find(params[:merchant_id]) 
    @deleting_discount = @merchant.bulk_discounts.find(params[:id])
    @deleting_discount.destroy
    
    flash.notice = "Update Successful"
    redirect_to merchant_bulk_discounts_path(@merchant)
  end




  private

  def discount_params
    params.permit(:name, :quantity, :percentage)
  end
end