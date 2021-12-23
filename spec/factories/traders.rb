name = Faker::Name.name
wallet = Faker::Number.decimal(l_digits: 4)
email = name.downcase.gsub(' ', '_') + '@yahoo.com'
FactoryBot.define do
  factory :trader do
    name { name }
    email { email }
    wallet { wallet }
    status { 'pending' }  
    association :user, email: email, name: name
  end
end