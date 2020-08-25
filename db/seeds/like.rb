N = 10;

users = User.order(:created_at).take(N)

(N-1).times do |i|
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
