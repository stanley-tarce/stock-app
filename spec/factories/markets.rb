# frozen_string_literal: true

stock_name = Faker::Company.name
price_per_unit = Faker::Number.decimal(l_digits: 2)

FactoryBot.define do
  factory :market do
    stock_name { stock_name }
    price_per_unit { price_per_unit }
    percentage_change { '+14%' }
  end
end
