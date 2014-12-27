$(document).ready ->
  $(".js-button").click (event) ->
    location = $(this).data("location")
    window.location = location
