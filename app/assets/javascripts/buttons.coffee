$(document).ready ->
  $(".js-button").click (event) ->
    event.preventDefault()
    location = $(@).data("location")
    window.location = location
