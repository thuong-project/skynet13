# frozen_string_literal: true

# Generate a bunch of additional users.
NUM_USER = 20

NUM_USER.times do |n|
  name = Faker::Name.name
  username = "user#{n + 1}"
  email = "#{n + 1}ckpvthuongft@gmail.com"
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
following = users[1..NUM_USER/2]
followers = users[1..NUM_USER/2]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

# Create post
NUM_WORD_PER_POST = 20
NUM_POST_PER_USER = 5
users = User.order(:created_at).take(NUM_USER/2)
NUM_POST_PER_USER.times do
  content = Faker::Lorem.sentence(word_count: NUM_WORD_PER_POST)
  users.each { |user| user.posts.create!(content: content) }
end

# Create Conversation
users = User.order(:created_at).take(NUM_USER/2)
(NUM_USER/2 - 1).times do |n|
  sender = users[n]
  recipient = users[n + 1]
  cvs = Conversation.get(sender.id, recipient.id)
  cvs.messages.create!(body: "hello #{recipient.name}, my name is #{sender.name}", user_id: sender.id)

  sender = users[n + 1]
  recipient = users[n]
  cvs = Conversation.get(sender.id, recipient.id)
  cvs.messages.create!(body: "hello #{recipient.name}, my name is #{sender.name}", user_id: sender.id)
end

# Create Likes

users = User.order(:created_at).take(NUM_USER/2)
(NUM_USER/2 - 1).times do |i|
  source = users[i]
  target = users[i+1]
  target.posts.each do |post|
    post.likes.create(user_id: source.id)
  end
  source = users[i+1]
  target = users[i]
  target.posts.each do |post|
    post.likes.create(user_id: source.id)
  end
end

# create comment
users = User.order(:created_at).take(NUM_USER/2)

(NUM_USER/2-1).times do |i|
  source = users[i]
  target = users[i+1]
  target.posts.each do |post|
    post.comments.create(user_id: source.id, content: 'I love your post')
  end
  source = users[i+1]
  target = users[i]
  target.posts.each do |post|
    post.comments.create(user_id: source.id, content: 'I love your post')
  end
end
