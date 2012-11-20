# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :track do
    source "youtube"
    url 'http://www.youtube.com/watch?v=9vXjfhgqqeI'
    posted_on 1.day.ago
    association :user, factory: :buck
  end
end

