# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
  	name 'Ryan'
    sequence(:email) { |n| "email#{n}@gmail.com" }
    password 'pw'
  end
end
