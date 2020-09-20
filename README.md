## 1.Introduce
This is a simple social network website built Ruby on Rails 6 and deployed to heroku  
Link demo: https://skynet13.herokuapp.com/login
## 2.Features
***Current***  
1. **Authentication features**
- Signup, Signin, confirm by email, forgot password, 
- Signin with Facebook, Google
2. **Profile**  
- Change name, password, update avatar
3. **Posts features**  
- Create, read, update, delete posts
- Like, comment
4. **Follows**  
- Follow, unfollow
5. **Chat Realtime**  
- Send messages, update notice  
- 
***Incoming***
- Friends

## 3.Used
- Framework: Ruby on Rails version 6
- Host: Heroku
- Add-on: heroku postgres, redistogo
- DB: postgresql
- Storage: Amazon S3
## 4. Usage
#### 1. Install
`sudo docker-compose build`  
`sudo docker-compose run web bundle install`  
`sudo docker-compose run web yarn install --checkfiles`  
`sudo docker-compose up`  
#### 2. If you want to deploy , set environment variable in .env file
