load_javascript = (controller) ->
  $.event.trigger "#{controller}.load"

window.App = {}
window.App.apis = []
window.App.installed_apis = []
window.App.data_encodings = []

$ () ->
  window.App.token = $('meta[name=token]').attr('content')
  load_javascript($("body").data("controller"))
