FactoryBot.define do
  factory :category, class: 'Category' do
    sequence(:name) { |n| "category_#{n}" }
  end
end
