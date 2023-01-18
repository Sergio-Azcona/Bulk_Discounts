require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "validations" do
    it { should validate_presence_of :invoice_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :status }
  end
  describe "relationships" do
    it { should belong_to :invoice }
    it { should belong_to :item }
    it {should have_one(:customer).through(:invoice)}
    it {should have_one(:merchant).through(:item)}
    it { should have_many(:transactions).through(:invoice) }
    it { should have_many(:bulk_discounts).through(:merchant) }
  end

  describe "class methods" do
    before(:each) do
      @m1 = Merchant.create!(name: 'Merchant 1')
      @m2 = Merchant.create!(name: 'General Store')  

      @c1 = Customer.create!(first_name: 'Bilbo', last_name: 'Baggins')
      @c2 = Customer.create!(first_name: 'Frodo', last_name: 'Baggins')
      @c3 = Customer.create!(first_name: 'Samwise', last_name: 'Gamgee')
      @c4 = Customer.create!(first_name: 'Aragorn', last_name: 'Elessar')
      @c5 = Customer.create!(first_name: 'Arwen', last_name: 'Undomiel')
      @c6 = Customer.create!(first_name: 'Legolas', last_name: 'Greenleaf')
      @item_1 = Item.create!(name: 'Shampoo', description: 'This washes your hair', unit_price: 10, merchant_id: @m1.id)
      @item_2 = Item.create!(name: 'Conditioner', description: 'This makes your hair shiny', unit_price: 8, merchant_id: @m1.id)
      @item_3 = Item.create!(name: 'Brush', description: 'This takes out tangles', unit_price: 5, merchant_id: @m1.id)
      @i1 = Invoice.create!(customer_id: @c1.id, status: 2)
      @i2 = Invoice.create!(customer_id: @c1.id, status: 2)
      @i3 = Invoice.create!(customer_id: @c2.id, status: 2)
      @i4 = Invoice.create!(customer_id: @c3.id, status: 2)
      @i5 = Invoice.create!(customer_id: @c4.id, status: 2)
      @ii_1 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
      @ii_2 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
      @ii_3 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
      @ii_4 = InvoiceItem.create!(invoice_id: @i3.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 1)


    end
    it 'incomplete_invoices' do
      expect(InvoiceItem.incomplete_invoices).to eq([@i1, @i3])
    end
  end

  it 'US 7: returns the names of the dicounts applied to an item'do
    @m1 = Merchant.create!(name: 'Merchant 1')
    @m2 = Merchant.create!(name: 'General Store') 
    @customer_1 = Customer.create!(first_name: 'Alpha', last_name: 'Smith')
    @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Cruz')

    @inv_1 = @customer_1.invoices.create!(status: 1)
    @inv_2 = @customer_1.invoices.create!(status: 1)

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

    expect(@ii_3.discount_applied).to eq(@bd_3)     
    expect(@ii_4.discount_applied).to eq(@bd_22)     


    #returns nil when no discounts apply
    expect(@ii_1.discount_applied).to eq(nil)     
  end
end
