$(document).ready ->
  $(".js-button").click (event) ->
    location = $(@).data("location")
    window.location = location
