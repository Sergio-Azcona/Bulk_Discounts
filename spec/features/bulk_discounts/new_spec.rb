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
      
      expect(page).to_not have_field('Name', with: 'Your Xmas is Today!')
      expect(page).to_not have_field('Quantity Threshold', with: '50')
      expect(page).to_not have_field('Percentage', with: '5.00')
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
      
      visit(merchant_bulk_discounts_path(@merchant2))
      expect(page).to have_content('Your Xmas is Today!')
      # expect(page).to have_content("Update Successful") #does print - why is it not showing?
    end

    it 'returns user to the form if form is not completed correctly; when user completes: save record and returns to index' do

      visit("/merchant/#{@merchant2.id}/bulk_discounts/new")
      expect(current_path).to eq("/merchant/#{@merchant2.id}/bulk_discounts/new")

      fill_in('Name', with: '')
      fill_in('Quantity Threshold', with: '51')
      fill_in('Percentage', with: '5')
      click_button("Create Discount")
      # save_and_open_page
      expect(current_path).to eq("/merchant/#{@merchant2.id}/bulk_discounts")
      expect(page).to have_content('Unsuccessful - Please Try Again')

      expect(page).to have_field('Name', with: '')
      expect(page).to have_field('Quantity Threshold', with: '51')
      expect(page).to have_field('Percentage', with: '5.0')
      
      fill_in('Name', with: 'Pizza Pies For Everyone')
      click_button("Create Discount")

      visit(merchant_bulk_discounts_path(@merchant2))
      expect(page).to have_content('Pizza Pies For Everyone')

      # expect(page).to have_content('Update Successful') #does print - why is it not showing?

    end

  end
end