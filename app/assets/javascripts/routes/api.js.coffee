App.ApiRoute = Ember.Route.extend
  model: (params) -> @store.find 'api', params.id
