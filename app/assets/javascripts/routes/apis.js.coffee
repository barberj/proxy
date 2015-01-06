App.ApisRoute = Ember.Route.extend
  model: -> @store.find 'api'
