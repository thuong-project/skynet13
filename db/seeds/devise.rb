
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

# Create following relationships.
users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.posts.create!(content: content) }
end