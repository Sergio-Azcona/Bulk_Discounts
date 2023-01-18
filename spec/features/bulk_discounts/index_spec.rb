require 'rails_helper'

RSpec.describe 'bulk discount index' do
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

    @item_1 = @merchant1.items.create!(name: "radio", description: "Listen to live broadcasts anywhere", unit_price: 60)
    @item_2 = @merchant1.items.create!(name: "batteries", description: "Power up today", unit_price: 11)
    @item_3 = @merchant1.items.create!(name: "cups", description: "drink from this", unit_price: 2)
    @item_4 = @merchant2.items.create!(name: "batteries", description: "Listen to live broadcasts anywhere", unit_price: 13)
    @item_5 = @merchant2.items.create!(name: "cups", description: "for drinks!", unit_price: 1)
    @item_6 = @merchant2.items.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10)
    @item_7 = @merchant3.items.create!(name: "batteries", description: "Power up today", unit_price: 50)
    @item_8 = @merchant3.items.create!(name: "Light Bulb", description: "Bright", unit_price: 40)

    @customer_1 = Customer.create!(first_name: 'Alpha', last_name: 'Smith')
    @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Cruz')
    @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
    @customer_4 = Customer.create!(first_name: 'Samwise', last_name: 'Abbot')
    @customer_5 = Customer.create!(first_name: 'Dragorn', last_name: 'Elessar')
    @customer_6 = Customer.create!(first_name: 'Zoey', last_name: 'Zander')

    @inv_1 = Invoice.create!(customer_id: @customer_1.id, status: 1,  created_at: "2012-03-27 14:54:09")
    @inv_2 = Invoice.create!(customer_id: @customer_2.id, status: 1,  created_at: "2012-03-27 14:54:09" )
    @inv_3 = Invoice.create!(customer_id: @customer_3.id, status: 2,  created_at: Time.now - 3.years)
    @inv_4 = Invoice.create!(customer_id: @customer_6.id, status: 2,  created_at: 72.hours.ago)
    @inv_5 = Invoice.create!(customer_id: @customer_5.id, status: 1)
    @inv_6 = Invoice.create!(customer_id: @customer_4.id, status: 1,  created_at: 57.days.ago)
    @inv_7 = Invoice.create!(customer_id: @customer_1.id, status: 1)
    @inv_8 = Invoice.create!(customer_id: @customer_3.id, status: 1)

    @ii_1 = InvoiceItem.create!(invoice_id: @inv_1.id, item_id: @item_3.id, quantity: 350, unit_price: @item_3.unit_price, status: 1)
    @ii_2 = InvoiceItem.create!(invoice_id: @inv_4.id, item_id: @item_2.id, quantity: 80, unit_price: @item_2.unit_price, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @inv_1.id, item_id: @item_3.id, quantity: 125, unit_price: @item_3.unit_price, status: 0)
    @ii_4 = InvoiceItem.create!(invoice_id: @inv_4.id, item_id: @item_5.id, quantity: 350, unit_price: @item_5.unit_price, status: 1)
    @ii_5 = InvoiceItem.create!(invoice_id: @inv_2.id, item_id: @item_3.id, quantity: 111, unit_price: @item_3.unit_price, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @inv_6.id, item_id: @item_5.id, quantity: 125, unit_price: @item_5.unit_price, status: 2)
    @ii_7 = InvoiceItem.create!(invoice_id: @inv_2.id, item_id: @item_2.id, quantity: 55, unit_price: @item_2.unit_price, status: 1)
    @ii_8 = InvoiceItem.create!(invoice_id: @inv_2.id, item_id: @item_3.id, quantity: 100, unit_price: @item_3.unit_price, status: 0)
    @ii_9 = InvoiceItem.create!(invoice_id: @inv_6.id, item_id: @item_2.id, quantity: 55, unit_price: @item_2.unit_price, status: 1)
    @ii_10 = InvoiceItem.create!(invoice_id: @inv_5.id, item_id: @item_3.id, quantity: 319, unit_price: @item_3.unit_price, status: 0)
    @ii_11 = InvoiceItem.create!(invoice_id: @inv_4.id, item_id: @item_2.id, quantity: 102, unit_price: @item_2.unit_price, status: 1)
    @ii_12 = InvoiceItem.create!(invoice_id: @inv_5.id, item_id: @item_6.id, quantity: 190, unit_price: @item_6.unit_price, status: 0)
    @ii_13 = InvoiceItem.create!(invoice_id: @inv_4.id, item_id: @item_5.id, quantity: 101, unit_price: @item_5.unit_price, status: 2)
    @ii_14 = InvoiceItem.create!(invoice_id: @inv_6.id, item_id: @item_1.id, quantity: 99, unit_price: @item_1.unit_price, status: 2)
    @ii_15 = InvoiceItem.create!(invoice_id: @inv_7.id, item_id: @item_7.id, quantity: 80, unit_price: @item_7.unit_price, status: 1)
    @ii_16 = InvoiceItem.create!(invoice_id: @inv_8.id, item_id: @item_8.id, quantity: 29, unit_price: @item_8.unit_price, status: 0)
    @ii_17 = InvoiceItem.create!(invoice_id: @inv_7.id, item_id: @item_7.id, quantity: 51, unit_price: @item_7.unit_price, status: 2)
    @ii_18 = InvoiceItem.create!(invoice_id: @inv_7.id, item_id: @item_3.id, quantity: 49, unit_price: @item_3.unit_price, status: 0)
    @ii_19 = InvoiceItem.create!(invoice_id: @inv_8.id, item_id: @item_2.id, quantity: 29, unit_price: @item_2.unit_price, status: 1)
    @ii_20 = InvoiceItem.create!(invoice_id: @inv_3.id, item_id: @item_1.id, quantity: 101, unit_price: @item_1.unit_price, status: 0)
    @ii_21 = InvoiceItem.create!(invoice_id: @inv_4.id, item_id: @item_5.id, quantity: 99, unit_price: @item_5.unit_price, status: 2)

    @transaction_1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @inv_1.id)
    @transaction_2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @inv_2.id)
    @transaction_3 = Transaction.create!(credit_card_number: 234092, result: 0, invoice_id: @inv_3.id,  created_at: Time.now - 3.years)
    @transaction_4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @inv_4.id)
    @transaction_5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @inv_5.id)
    @transaction_6 = Transaction.create!(credit_card_number: 879799, result: 0, invoice_id: @inv_6.id,  created_at: 55.days.ago)
    @transaction_7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @inv_3.id,  created_at: Time.now - 2.years)
    @transaction_8 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @inv_6.id,  created_at: 44.days.ago)
    @transaction_9 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @inv_7.id)
    @transaction_10 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @inv_8.id)
  
    visit(merchant_bulk_discounts_path(@merchant2))
  end

  describe "US1-Index displays all discounts" do
    describe 'displays attributes and values (i.e. percentage discount and quantity thresholds) with each discount' do
      it "displays a functioning link to each bulk discount's show page to each bulk discount" do
        expect(page).to have_content(@merchant2.name)
        # save_and_open_page
        expect(page).to have_content(@bd_21.name)
        expect(page).to have_content(@bd_22.quantity)
        expect(page).to have_content(@bd_24.percentage)
        expect(page).to have_link("Discount: #{@bd_21.name}", href: "/merchant/#{@merchant2.id}/bulk_discounts/#{@bd_21.id}")
        
        within("#Discount-#{@bd_23.id}") do
          expect(page).to_not have_content(@bd_21.name)
          expect(page).to have_content(@bd_23.name)
          expect(page).to have_content(@bd_23.quantity)
          expect(page).to have_content(@bd_23.percentage)
          expect(page).to have_link("Discount: #{@bd_23.name}", href: "/merchant/#{@merchant2.id}/bulk_discounts/#{@bd_23.id}")
        end
      end
      it 'routes user to the requested show page when they clink the discount name link' do
        expect(current_path).to eq("/merchant/#{@merchant2.id}/bulk_discounts")
        
        click_link("Discount: #{@bd_23.name}")
        expect(current_path).to eq("/merchant/#{@merchant2.id}/bulk_discounts/#{@bd_23.id}")
      end
    end
  end

  describe "US2-Link to create discount" do
    it "has a link to create a new discount" do
      expect(page).to have_link("Create Discount", href: "/merchant/#{@merchant2.id}/bulk_discounts/new")
      # save_and_open_page
      click_link("Create Discount")
      expect(current_path).to eq("/merchant/#{@merchant2.id}/bulk_discounts/new")
    end
  end

  describe "US3-Delete a Discount" do
    it 'displays a link to delete each discount' do
      within("#Discount-#{@bd_23.id}") do
        expect(page).to have_content(@bd_23.name)
        expect(page).to have_content(@bd_23.quantity)
        expect(page).to have_content(@bd_23.percentage)
        expect(page).to have_link("Discount: #{@bd_23.name}", href: "/merchant/#{@merchant2.id}/bulk_discounts/#{@bd_23.id}")
        expect(page).to have_link("DELETE #{@bd_23.name}", href: "/merchant/#{@merchant2.id}/bulk_discounts/#{@bd_23.id}")
      end
    end

    it 'removes the record when delete is clicked and returns user to the discount index page' do
      click_link("DELETE #{@bd_23.name}")

      expect(current_path).to eq("/merchant/#{@merchant2.id}/bulk_discounts")
      expect(page).to_not have_content(@bd_23.name)
      expect(page).to have_content("Update Successful")
    end
  end

  describe 'holidays displayed' do
    it 'displays holidays visible' do
      expect(page).to have_content(@holidays)
      # expect(page).to have_content(@holidays.date)
    end
  end
end