stock_name = Faker::Company.name
price_per_unit = Faker::Number.decimal(l_digits: 2)

FactoryBot.define do
  factory :market do
    stock_name { stock_name }
    price_per_unit { price_per_unit }
    percentage_change { "MyString" }
  end
end
