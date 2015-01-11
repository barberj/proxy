load_javascript = (controller) ->
  $.event.trigger "#{controller}.load"

$ () ->
  load_javascript($("body").data("controller"))
