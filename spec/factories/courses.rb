FactoryBot.define do
  factory :course, class: 'Course' do
    sequence(:title) { |n| "Course_#{n}" }
    content { 'Ruby is dynammic language' }
    credit_hour { 20 }
    category
    author
  end
end
