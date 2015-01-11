load_javascript = (controller) ->
  $.event.trigger "#{controller}.load"

window.App = {}

$ () ->
  window.App.token = $('meta[name=token]').attr('content')
  load_javascript($("body").data("controller"))
