FactoryBot.define do
  factory :comment, class: 'Comment' do
    content { 'Thanks!' }
    course
    user
  end
end
