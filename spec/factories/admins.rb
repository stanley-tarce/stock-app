name = Faker::Name.name
email = name.downcase.gsub(' ', '_') + '@yahoo.com'
FactoryBot.define do
  factory :admin do 
    name { name } 
    email {email}
    association :user, user_type: 'admin', email: email, name: name

    # trait :invalid_attributes do 
    #   name { nil }
    #   email { nil }
    #   association :user
    # end

    


  end
end