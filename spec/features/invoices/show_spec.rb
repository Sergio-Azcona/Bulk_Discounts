require 'rails_helper'

RSpec.describe 'invoices show' do

  describe 'inherited tests' do
    before :each do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @merchant2 = Merchant.create!(name: 'Jewelry')
  
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
      @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
      @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)
      @item_7 = Item.create!(name: "Scrunchie", description: "This holds up your hair but is bigger", unit_price: 3, merchant_id: @merchant1.id)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
  
      @item_5 = Item.create!(name: "Bracelet", description: "Wrist bling", unit_price: 200, merchant_id: @merchant2.id)
      @item_6 = Item.create!(name: "Necklace", description: "Neck bling", unit_price: 300, merchant_id: @merchant2.id)
  
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
      @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
      @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
      @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
      @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Kuhn')
  
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-28 14:54:09")
      @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
      @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
      @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
      @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
      @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 2)
  
      @invoice_8 = Invoice.create!(customer_id: @customer_6.id, status: 1)
  
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_2 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 2)
      @ii_3 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_2.id, quantity: 2, unit_price: 8, status: 2)
      @ii_4 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_3.id, quantity: 3, unit_price: 5, status: 1)
      @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1)
      @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_7.id, quantity: 1, unit_price: 3, status: 1)
      @ii_8 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_8.id, quantity: 1, unit_price: 5, status: 1)
      @ii_9 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1)
      @ii_10 = InvoiceItem.create!(invoice_id: @invoice_8.id, item_id: @item_5.id, quantity: 1, unit_price: 1, status: 1)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 12, unit_price: 6, status: 1)
  
      @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
      @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_2.id)
      @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_3.id)
      @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_4.id)
      @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_5.id)
      @transaction6 = Transaction.create!(credit_card_number: 879799, result: 0, invoice_id: @invoice_6.id)
      @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_7.id)
      @transaction8 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_8.id)
    end

    it "shows the invoice information" do
      visit merchant_invoice_path(@merchant1, @invoice_1)

      expect(page).to have_content(@invoice_1.id)
      expect(page).to have_content(@invoice_1.status)
      expect(page).to have_content(@invoice_1.created_at.strftime("%A, %B %-d, %Y"))
    end

    it "shows the customer information" do
      visit merchant_invoice_path(@merchant1, @invoice_1)

      expect(page).to have_content(@customer_1.first_name)
      expect(page).to have_content(@customer_1.last_name)
      expect(page).to_not have_content(@customer_2.last_name)
    end

    it "shows the item information" do
      visit merchant_invoice_path(@merchant1, @invoice_1)

      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@ii_1.quantity)
      expect(page).to have_content(@ii_1.unit_price)
      expect(page).to_not have_content(@ii_4.unit_price)

    end

    it "shows the total revenue for this invoice" do
      visit merchant_invoice_path(@merchant1, @invoice_1)

      expect(page).to have_content(@invoice_1.total_revenue)
    end

    it "shows a select field to update the invoice status" do
      visit merchant_invoice_path(@merchant1, @invoice_1)

      within("#the-status-#{@ii_1.id}") do
        page.select("cancelled")
        click_button "Update Invoice"

        expect(page).to have_content("cancelled")
      end

      within("#current-invoice-status") do
        expect(page).to_not have_content("in progress")
      end
    end
  end

  describe 'US-6 & US-7:  Total Revenue and Discounted Revenue and Link to Discount' do
    before(:each)do 
      @m1 = Merchant.create!(name: 'Merchant 1')
      @m2 = Merchant.create!(name: 'General Store') 
      @customer_1 = Customer.create!(first_name: 'Alpha', last_name: 'Smith')
      @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Cruz')

      @inv_1 = @customer_1.invoices.create!(status: 1)
      @inv_2 = @customer_2.invoices.create!(status: 1)
      @inv_3 = @customer_1.invoices.create!(status: 1)

      @item_1 = @m1.items.create!(name: "radio", description: "Listen to live broadcasts anywhere", unit_price: 5)
      @item_2 = @m1.items.create!(name: "batteries", description: "Power up today", unit_price: 10)
      @item_3 = @m2.items.create!(name: "cups", description: "drink from this", unit_price: 10)
      @item_4 = @m2.items.create!(name: 'Brush', description: 'This takes out tangles', unit_price: 5)

      @bd_1 = @m1.bulk_discounts.create!(name: 'Perfect 10s!', quantity: 10, percentage: 10.00)
      @bd_2 = @m1.bulk_discounts.create!(name: 'Bang!', quantity: 100, percentage: 30.00)
      @bd_3 = @m1.bulk_discounts.create!(name: '15-Again!', quantity: 15, percentage: 15.00)
      @bd_22 = @m2.bulk_discounts.create!(name: '33s All Today!', quantity: 25, percentage: 33.33)
      @bd_24 = @m2.bulk_discounts.create!(name: 'Twenty-Fives', quantity: 20, percentage: 25.50)
      @bd_25 = @m2.bulk_discounts.create!(name: 'Boom!', quantity: 100, percentage: 30.00)

      @ii_1 = InvoiceItem.create!(invoice_id: @inv_2.id, item_id: @item_3.id, quantity: 14, unit_price: 10, status: 0)
      @ii_2 = InvoiceItem.create!(invoice_id: @inv_1.id, item_id: @item_2.id, quantity: 20, unit_price: 15, status: 0)
      @ii_3 = InvoiceItem.create!(invoice_id: @inv_2.id, item_id: @item_1.id, quantity: 15, unit_price: 20, status: 2)
      @ii_4 = InvoiceItem.create!(invoice_id: @inv_1.id, item_id: @item_4.id, quantity: 330, unit_price: 5, status: 1)
      @ii_5 = InvoiceItem.create!(invoice_id: @inv_3.id, item_id: @item_3.id, quantity: 3, unit_price: 5, status: 1)
    end
    
    it 'displays the total discounted revenue from this invoice' do
      visit merchant_invoice_path(@m1, @inv_1)

      expect(page).to have_content(@inv_1.calculate_discounted_revenue)
    end 

    it 'displays the revenue amount if no discount applies from this invoice' do
      visit merchant_invoice_path(@m2, @inv_3)
    
      expect(page).to have_content(@inv_3.calculate_discounted_revenue)
    end
  
    it 'Provides a link to the discount applied to the item on the invoice' do
      visit merchant_invoice_path(@m1, @inv_1)
            
      expect(page).to have_link("#{@ii_2.discount_applied.name}", href: "/merchant/#{@m1.id}/bulk_discounts/#{@bd_3.id}")
      expect(page).to have_link("#{@ii_4.discount_applied.name}", href: "/merchant/#{@m1.id}/bulk_discounts/#{@bd_22.id}")
    end
    
    it 'Provides NO link if NO discount applied to the item on the invoice' do
      visit merchant_invoice_path(@m2, @inv_3)
      expect(page).to have_content("No Discount")
    end
  end
end
