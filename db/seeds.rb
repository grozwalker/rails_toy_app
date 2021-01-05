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

99.times do |_n|
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

200.times do |n|
  Micropost.create!({
    content: Faker::Lorem.sentences(number: 4),
    user: User.find(User.pluck(:id).sample),
    created_at: Faker::Date.between(from: 1.year.ago, to: Time.zone.now)
  })
end
