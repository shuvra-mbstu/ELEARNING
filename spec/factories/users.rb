FactoryBot.define do
  factory :user, class: 'User', aliases: [:author] do
    full_name { 'Imam Hossain' }
    sequence(:username) { |n| "#{full_name}_#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    location { 'Dhaka, Bangladesh' }
    password { 'secretpass' }
  end
end
