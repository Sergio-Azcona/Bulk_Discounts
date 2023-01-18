require 'rails_helper'

describe 'Admin Invoices Index Page' do
  describe 'inherited data' do 
    before :each do
      @m1 = Merchant.create!(name: 'Merchant 1')

      @c1 = Customer.create!(first_name: 'Yo', last_name: 'Yoz', address: '123 Heyyo', city: 'Whoville', state: 'CO', zip: 12345)
      @c2 = Customer.create!(first_name: 'Hey', last_name: 'Heyz')

      @i1 = Invoice.create!(customer_id: @c1.id, status: 2, created_at: '2012-03-25 09:54:09')
      @i2 = Invoice.create!(customer_id: @c2.id, status: 1, created_at: '2012-03-25 09:30:09')

      @item_1 = Item.create!(name: 'test', description: 'lalala', unit_price: 6, merchant_id: @m1.id)
      @item_2 = Item.create!(name: 'rest', description: 'dont test me', unit_price: 12, merchant_id: @m1.id)

      @ii_1 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_1.id, quantity: 12, unit_price: 2, status: 0)
      @ii_2 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_2.id, quantity: 6, unit_price: 1, status: 1)
      @ii_3 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_2.id, quantity: 87, unit_price: 12, status: 2)

      visit admin_invoice_path(@i1)
    end

    it 'should display the id, status and created_at' do
      expect(page).to have_content("Invoice ##{@i1.id}")
      expect(page).to have_content("Created on: #{@i1.created_at.strftime("%A, %B %d, %Y")}")

      expect(page).to_not have_content("Invoice ##{@i2.id}")
    end

    it 'should display the customers name and shipping address' do
      expect(page).to have_content("#{@c1.first_name} #{@c1.last_name}")
      expect(page).to have_content(@c1.address)
      expect(page).to have_content("#{@c1.city}, #{@c1.state} #{@c1.zip}")

      expect(page).to_not have_content("#{@c2.first_name} #{@c2.last_name}")
    end

    it 'should display all the items on the invoice' do
      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@item_2.name)

      expect(page).to have_content(@ii_1.quantity)
      expect(page).to have_content(@ii_2.quantity)

      expect(page).to have_content("$#{@ii_1.unit_price}")
      expect(page).to have_content("$#{@ii_2.unit_price}")

      expect(page).to have_content(@ii_1.status)
      expect(page).to have_content(@ii_2.status)

      expect(page).to_not have_content(@ii_3.quantity)
      expect(page).to_not have_content("$#{@ii_3.unit_price}")
      expect(page).to_not have_content(@ii_3.status)
    end

    it 'should display the total revenue the invoice will generate' do
      expect(page).to have_content("Total Revenue: $#{@i1.total_revenue}")

      expect(page).to_not have_content(@i2.total_revenue)
    end

    it 'should have status as a select field that updates the invoices status' do
      within("#status-update-#{@i1.id}") do
        select('cancelled', :from => 'invoice[status]')
        expect(page).to have_button('Update Invoice')
        click_button 'Update Invoice'

        expect(current_path).to eq(admin_invoice_path(@i1))
        expect(@i1.status).to eq('completed')
      end
    end
  end

  describe 'US-8: display Total Revenue and Discounted Revenue' do
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
      visit admin_invoice_path(@inv_1)
        # save_and_open_page
      expect(page).to have_content(@inv_1.calculate_discounted_revenue)
    end 

    it 'displays the revenue amount if no discount applies from this invoice' do
      visit admin_invoice_path(@inv_3)
      # save_and_open_page
      expect(page).to have_content(@inv_3.calculate_discounted_revenue)
    end

  end
end
