js_button_handler = ->
  $(".js-button").click (event) ->
    event.preventDefault()
    location = $(@).data("location")
    window.location = location

$(document).ready(js_button_handler)
$(document).on('page:load', js_button_handler)
