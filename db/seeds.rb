# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

internal = Account.create
User.create(
  first_name: 'Justin',
  last_name: 'Barber',
  email: 'barber.justin@gmail.com',
  password: 'change_me!',
  account_id: internal.id,
)

User.create(
  first_name: 'Robby',
  last_name: 'Ranshous',
  email: 'rranhous@gmail.com',
  password: 'change_me!',
  account_id: internal.id,
)
