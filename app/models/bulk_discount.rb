class BulkDiscount < ApplicationRecord
    validates_presence_of :name, :percentage, :quantity, :merchant_id
    
    belongs_to :merchant
    has_many :items, through: :merchant
    has_many :invoice_items, through: :items 
    has_many :invoices, through: :invoice_items
    has_many :transactions, through: :invoices
    has_many :customers, through: :invoices


end