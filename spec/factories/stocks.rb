stock_name = Faker::Company.name
shares = Faker::Number.number(digits: 2)
price_per_unit = Faker::Number.decimal(l_digits: 2)
unit = Faker::Number.number(digits: 1)
FactoryBot.define do
  factory :stock do
    stock_name { stock_name }
    price_per_unit { price_per_unit }
    unit { unit }
    shares { shares }
    association :market, stock_name: stock_name, price_per_unit: price_per_unit
    association :trader
  end
end
