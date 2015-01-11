load_javascript = (controller) ->
  $.event.trigger "#{controller}.load"

window.App = {}

$ () ->
  load_javascript($("body").data("controller"))
