require 'rails_helper'

RSpec.describe 'Bulk Discount Edit Page' do
    before(:each)do
      @merchant1 = Merchant.create!(name: 'RadioShack')
      @merchant2 = Merchant.create!(name: 'General Store')
      @merchant3 = Merchant.create!(name: 'Office Space')

      @bd_21 = @merchant2.bulk_discounts.create!(name: 'One-Ten', quantity: 100, percentage: 10.00)
      @bd_22 = @merchant2.bulk_discounts.create!(name: '30-3s All Today!', quantity: 30, percentage: 33.33)
      @bd_23 = @merchant2.bulk_discounts.create!(name: '40-Today!', quantity: 40, percentage: 40.40)
      @bd_24 = @merchant2.bulk_discounts.create!(name: 'Fifty for Five', quantity: 50, percentage: 5.00)

      visit(edit_merchant_bulk_discount_path(@merchant2, @bd_23))
  end

  describe 'US-5,edit discount function' do
    describe 'when user click the edit link, they are routed to a new page with a form to edit the discount' do
      it 'when user click the edit link, the new page has a pre-poluated form with the current attribute values' do
                
        expect(page).to have_field('Name', with: "#{@bd_23.name}")
        expect(page).to have_field('Quantity Threshold', with: "#{@bd_23.quantity}")
        expect(page).to have_field('Percentage', with: "#{@bd_23.percentage}")
      end 

      it 'returns the user to the discount show page when user click Update Discount, where the updated values are visable' do
  
        fill_in('Name', with: 'Hot Pizza Pies All Day and All Night')
        fill_in('Quantity Threshold', with: '500')
        fill_in('Percentage', with: '32')
        click_button("Update Discount")

        expect(current_path).to eq("/merchant/#{@merchant2.id}/bulk_discounts/#{@bd_23.id}")
        expect(page).to have_content("Update Successful")

        expect(page).to have_content('Hot Pizza Pies All Day and All Night')
        expect(page).to have_content('500')
        expect(page).to have_content('32')
      end 
    end 
  end
end