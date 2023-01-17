require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many :transactions}
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many(:bulk_discounts).through(:merchants) }
  end
  
  describe "instance methods" do
    it "total_revenue" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

      expect(@invoice_1.total_revenue).to eq(100)
    end
  end

  describe 'US-6: Discounted Revenue' do
    before(:each) do
      @merchant1 = Merchant.create!(name: 'RadioShack')
      @merchant2 = Merchant.create!(name: 'General Store')  

      @customer_1 = Customer.create!(first_name: 'Alpha', last_name: 'Smith')
      @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Cruz')
  
      @bd_1 = @merchant1.bulk_discounts.create!(name: 'One-Ten', quantity: 80, percentage: 10.00)
      @bd_2 = @merchant1.bulk_discounts.create!(name: 'Half Off Second 50!', quantity: 60, percentage: 50.00)
      @bd_3 = @merchant1.bulk_discounts.create!(name: 'One-Ten', quantity: 75, percentage: 10.00)
      @bd_22 = @merchant2.bulk_discounts.create!(name: '30-3s All Today!', quantity: 50, percentage: 33.33)
      @bd_24 = @merchant2.bulk_discounts.create!(name: 'Fifty for Five', quantity: 50, percentage: 5.00)

      @item_1 = @merchant1.items.create!(name: "radio", description: "Listen to live broadcasts anywhere", unit_price: 5)
      @item_2 = @merchant1.items.create!(name: "batteries", description: "Power up today", unit_price: 10)
      @item_3 = @merchant2.items.create!(name: "cups", description: "drink from this", unit_price: 10)

      @inv_1 = @customer_1.invoices.create!(status: 1)
      @inv_2 = @customer_1.invoices.create!(status: 1)
      @inv_3 = @customer_2.invoices.create!(status: 1)

      @ii_1 = InvoiceItem.create!(invoice_id: @inv_1.id, item_id: @item_2.id, quantity: 70, unit_price: @item_2.unit_price, status: 1)
      @ii_2 = InvoiceItem.create!(invoice_id: @inv_2.id, item_id: @item_1.id, quantity: 100, unit_price: @item_1.unit_price, status: 0)
      @ii_3 = InvoiceItem.create!(invoice_id: @inv_3.id, item_id: @item_3.id, quantity: 100, unit_price: @item_3.unit_price, status: 0)
      @ii_4 = InvoiceItem.create!(invoice_id: @inv_2.id, item_id: @item_2.id, quantity: 100, unit_price: @item_2.unit_price, status: 1)
      @ii_5 = InvoiceItem.create!(invoice_id: @inv_1.id, item_id: @item_1.id, quantity: 45, unit_price: @item_1.unit_price, status: 1)
    end
  
    it 'returns the total discounted amount on an invoice' do
      expect(@inv_1.discounted_total).to eq(350.)
      expect(@inv_2.discounted_total).to eq(750)
      expect(@inv_3.discounted_total).to eq(333.3)

    end
  
  end
end
