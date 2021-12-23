FactoryBot.define do
  factory :transaction_history do
    stock_name { nil }
    shares { Faker::Number.number(digits: 2) }
    price_per_unit { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    total_price { shares * price_per_unit }
    balance { 10 }
    association :trader
  end
end


