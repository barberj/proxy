load_javascript = (controller) ->
  $.event.trigger "#{controller}.load"

window.App = {}
window.App.published_apis = []
window.App.market_apis = []
window.App.data_encodings = []

$ () ->
  window.App.token = $('meta[name=token]').attr('content')
  window.App.user_id = $('meta[name=user_id]').attr('content')
  load_javascript($("body").data("controller"))
