# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :buck, class: User do
    provider "MyString"
    uid "MyString"
    name "Buck Caradine"
  end

  factory :alice, class: User do
    provider "Wonderland"
    uid "7713"
    name "Alice In"
  end

  factory :white_rabbit, class: User do
    provider "Wonderland"
    uid "late late late"
    name "The White Rabbit"
  end
end
