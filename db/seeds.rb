# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!({
               name: 'Andrey',
               email: 'ag@test.ru',
               password: 'password',
               password_confirmation: 'password',
               admin: true,
               activation_token: User.new_token,
               activated: true,
               activated_at: Time.zone.now
             })

50.times do |_n|
  activated = Faker::Boolean.boolean

  User.create!({
                 name: Faker::Name.name,
                 email: Faker::Internet.email,
                 password: 'password',
                 password_confirmation: 'password',
                 activation_token: User.new_token,
                 activated: activated,
                 activated_at: activated ? Time.zone.now : nil
               })
end

users = User.order(created_at: :desc).take(6)

50.times do |_n|
  Micropost.create!({
                      content: Faker::Lorem.sentence,
                      user: User.find(users.sample.id),
                      created_at: Faker::Date.between(from: 1.year.ago, to: Time.zone.now)
                    })
end

# Create following relationships.
users = User.all
user = users.first

following = users[2..50]
followers = users[3..40]

following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
