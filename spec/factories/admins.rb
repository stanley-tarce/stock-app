# frozen_string_literal: true

name = Faker::Name.name
email = "#{name.downcase.gsub(' ', '_')}@yahoo.com"
FactoryBot.define do
  factory :admin do
    name { name }
    email { email }
    password { '123456' }
    password_confirmation { '123456' }
    association :user, user_type: 'admin', email: email, name: name
  end
end
