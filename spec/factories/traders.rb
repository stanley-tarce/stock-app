name = Faker::Name.name
email = name.downcase.gsub(' ', '_') + '@yahoo.com'
FactoryBot.define do
  factory :trader do
    name { name }
    email {email}
    status {'pending'}  
    association :user, email: email, name: name
  end
end