require 'rails_helper'

RSpec.describe BulkDiscount do
  describe "validations and relationships" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :percentage }
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :percentage }
    it { should validate_presence_of :merchant_id }

    it { should belong_to :merchant }
    it { should have_many(:items).through(:merchant) }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:customers).through(:invoices) }

  end
end