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

internal.apis.create(
  name: 'Insightly Api',
  install_url: 'http://127.0.0.1:3001/insightly/signup',
  uninstall_url: 'http://127.0.0.1:3001/uninstall',
  resources_attributes: [{
    name: 'Contacts',
    customs_url: 'http://127.0.0.1:3001/api/v1/contacts',
    search_url: 'http://127.0.0.1:3001/api/v1/contacts',
    created_url: 'http://127.0.0.1:3001/api/v1/contacts',
    updated_url: 'http://127.0.0.1:3001/api/v1/contacts',
    create_url: 'http://127.0.0.1:3001/api/v1/contacts',
    update_url: 'http://127.0.0.1:3001/api/v1/contacts',
    delete_url: 'http://127.0.0.1:3001/api/v1/contacts',
    read_url: 'http://127.0.0.1:3001/api/v1/contacts',
    fields_attributes: [{
      dpath: '/FIRST_NAME'
    }]
  }]
)

internal.apis.create(
  name: 'Emma Api',
  install_url: 'http://127.0.0.1:3001/api/v1/install',
  uninstall_url: 'http://127.0.0.1:3001/api/v1/uninstall'
)
