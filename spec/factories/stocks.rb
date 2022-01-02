# frozen_string_literal: true

stock_name = Faker::Company.name
shares = Faker::Number.number(digits: 2)
stock_name = Faker::Company.name
price_per_unit = Faker::Number.decimal(l_digits: 2)
FactoryBot.define do
  factory :stock do
    stock_name { stock_name }
    price_per_unit { price_per_unit }
    shares { shares }
    total_price { shares * price_per_unit }
    logo {'asd'}
    association :market, stock_name: stock_name, price_per_unit: price_per_unit
    association :trader
  end
end
