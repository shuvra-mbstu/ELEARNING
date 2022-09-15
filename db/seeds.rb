User.create!(
  username: 'Admin',
  full_name: 'ADMIN OF ELEARNING',
  email: 'admin@gmail.com',
  password: 'secret',
  location: 'Dhaka,Bangldesh',
  admin: true,
)

Category.create!(name: 'Exercise')
Category.create!(name: 'Education')
Category.create!(name: 'Recipe')
