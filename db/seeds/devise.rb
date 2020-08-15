
# Generate a bunch of additional users.
50.times do |n|
name = Faker::Name.name
username = "user#{n}"
email = "#{n}ckpvthuongft@gmail.com"
password = '111111'

user = User.create!(
    name: name,
    email: email,
    username: username,
    password: password,
    password_confirmation: password
)
user.skip_confirmation!
user.save!
end