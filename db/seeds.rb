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
  account_id: internal.id
)

internal.apis.create(
  name: 'Insightly Api',
  install_url: 'http://127.0.0.1:3001/install',
  uninstall_url: 'http://127.0.0.1:3001/uninstall',
  resources_attributes: [{
    name: 'Contacts',
    customs_url: 'http://127.0.0.1:3001/contacts/customs',
    search_url: 'http://127.0.0.1:3001/contacts/search',
    created_url: 'http://127.0.0.1:3001/contacts/created',
    updated_url: 'http://127.0.0.1:3001/contacts/updated',
    create_url: 'http://127.0.0.1:3001/contacts/create',
    update_url: 'http://127.0.0.1:3001/contacts/update',
    delete_url: 'http://127.0.0.1:3001/contacts/delete',
    read_url: 'http://127.0.0.1:3001/contacts/read',
    fields_attributes: [{
      dpath: '/FIRST_NAME'
    }]
  }]
)
