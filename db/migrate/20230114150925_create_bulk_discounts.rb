class CreateBulkDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bulk_discounts do |t|
      t.string :name
      t.integer :quantity
      t.decimal :percentage, precision: 5, scale: 2
      t.references :merchant, foreign_key: true

      t.timestamps
    end
  end
end
