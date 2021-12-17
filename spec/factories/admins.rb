name = Faker::Name.name
email = name.downcase.gsub(' ', '_') + '@yahoo.com'
FactoryBot.define do
  factory :admin do 
    name { Faker::Name.name }
    email {Faker::Internet.email}
    association :user, user_type: 'admin', email: email, name: name
  end 
end