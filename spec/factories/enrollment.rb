FactoryBot.define do
  factory :enrollment, class: 'Enrollment' do
    user
    course
  end
end
