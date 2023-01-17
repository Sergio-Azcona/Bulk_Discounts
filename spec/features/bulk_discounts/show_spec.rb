require 'rails_helper'

RSpec.describe 'Bulk Discount Show Page' do
    before(:each)do
      @merchant1 = Merchant.create!(name: 'RadioShack')
      @merchant2 = Merchant.create!(name: 'General Store')
      @merchant3 = Merchant.create!(name: 'Office Space')

      @bd_1 = @merchant1.bulk_discounts.create!(name: 'One-Ten', quantity: 100, percentage: 10.00)
      @bd_2 = @merchant1.bulk_discounts.create!(name: 'Half Off Second 50!', quantity: 100, percentage: 50.00)
      @bd_3 = @merchant1.bulk_discounts.create!(name: '90 for 30s All Day!', quantity: 90, percentage: 30.30)
      @bd_4 = @merchant1.bulk_discounts.create!(name: '50s BLOWOUT!', quantity: 50, percentage: 50.50)
      @bd_5 = @merchant1.bulk_discounts.create!(name: 'Five-4Five', quantity: 50, percentage: 45.45)
      @bd_6 = @merchant1.bulk_discounts.create!(name: 'Spirit of 1966', quantity: 66, percentage: 19.66)
      @bd_21 = @merchant2.bulk_discounts.create!(name: 'One-Ten', quantity: 100, percentage: 10.00)
      @bd_22 = @merchant2.bulk_discounts.create!(name: '30-3s All Today!', quantity: 30, percentage: 33.33)
      @bd_23 = @merchant2.bulk_discounts.create!(name: '40-Today!', quantity: 40, percentage: 40.40)
      @bd_24 = @merchant2.bulk_discounts.create!(name: 'Fifty for Five', quantity: 50, percentage: 5.00)
      @bd_31 = @merchant3.bulk_discounts.create!(name: '90/90 Customer Club!', quantity: 90, percentage: 90.00)

      visit(merchant_bulk_discount_path(@merchant2, @bd_23))
  end

  describe 'US 4, Show page attributes displayed and edit discount function' do
    describe 'when user click the edit link, they are routed to a new page with a form to edit the discount' do
      it 'show page - has links to edit existing discount, creat new discount, return to discount index, or delete current discount' do
        expect(page).to have_link("Edit #{@bd_23.name}", href: "/merchant/#{@merchant2.id}/bulk_discounts/#{@bd_23.id}/edit")
        expect(page).to have_link("Create Discount", href: "/merchant/#{@merchant2.id}/bulk_discounts/new")
        expect(page).to have_link("Discounts Index", href: "/merchant/#{@merchant2.id}/bulk_discounts")
        expect(page).to have_link("DELETE #{@bd_23.name}", href: "/merchant/#{@merchant2.id}/bulk_discounts/#{@bd_23.id}")
      end

      it "displays the bulk discount's quantity threshold and percentage discount" do
        expect(page).to have_content(@merchant2.name)
        expect(page).to have_content(@bd_23.name)
        expect(page).to have_content(@bd_23.quantity)
        expect(page).to have_content(@bd_23.percentage)
      end
    end
  end
end
