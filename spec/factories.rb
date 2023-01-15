FactoryBot.define do
  factory :customer do
    first_name {Faker::Artist.first_name}
    last_name {Faker::Name.last_name }
  end

  factory :invoice do
    status {[0,1,2].sample}
    merchant
    customer
  end

  factory :merchant do
    name {Faker::Commerce.unique.vendor}
    invoices
    items
  end

  factory :item do
    name {Faker::Commerce.product_name}
    description {Faker::Hipster.sentence(word_count: 5)}
    unit_price {Faker::Number.decimal(l_digits: 2)}
    merchant
  end

  factory :transaction do
    result {[0,1].sample}
    credit_card_number {Faker::Finance.credit_card}
    invoice
  end

  factory :invoice_item do
    status {[0,1,2].sample}
    merchant
    invoice
  end

  factory :bulk_discounts do
    name {Faker::Commerce.promotion_code(digits: 2)}
    quantity {Faker::Number.number(digits: 2) }
    percentage {Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    merchant
  end
end
