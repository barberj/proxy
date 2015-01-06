# For more information see: http://emberjs.com/guides/routing/
App.Router.reopen
  location: 'auto'
  rootURL: '/'

App.Router.map ->
  @resource 'apis', path: '/', ->
    @resource 'api', path: '/apis/:id', ->
      @route 'edit'
