require 'rails_helper'

RSpec.describe 'bulk discount new' do
  before(:each)do
    @merchant1 = Merchant.create!(name: 'RadioShack')
    @merchant2 = Merchant.create!(name: 'General Store')

    @bd_22 = @merchant2.bulk_discounts.create!(name: '30-3s All Today!', quantity: 30, percentage: 33.33)
  end 

  describe 'US2-create new discount' do
    it 'has a blank form the user can input values into' do
      visit("/merchant/#{@merchant2.id}/bulk_discounts/new")
      
      expect(page).to have_content(@merchant2.name)

      expect(page).to have_field('Name', with: '')
      expect(page).to have_field('Quantity Threshold', with: '')
      expect(page).to have_field('Percentage', with: '')
    end

    it 'saves valid input and redirects user to the discount index page, where new entry is displayed' do
      visit(merchant_bulk_discounts_path(@merchant2))
      expect(page).to have_content(@bd_22.name)
      expect(page).to_not have_content('Your Xmas is Today!')

      visit("/merchant/#{@merchant2.id}/bulk_discounts/new")

      fill_in('Name', with: 'Your Xmas is Today!')
      fill_in('Quantity Threshold', with: '50')
      fill_in('Percentage', with: '5.00')
      click_button("Create Discount")
      # save_and_open_page
      visit(merchant_bulk_discounts_path(@merchant2))
      expect(page).to have_content('Your Xmas is Today!')
    end

  end
end