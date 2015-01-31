signup_handler = ->
  $(".js-signup").click (event) ->
    event.preventDefault()
    form = $(@).closest('form')
    if new FormValidator(form).is_valid()
      $.ajax(
        url: form.get(0).action,
        type: form.get(0).method.toUpperCase(),
        data: form.serialize(),
        dataType: "json"
      ).done( (rsp) =>
        console.log 'created'
        window.location = '/dashboard'
      ).fail( (rsp) =>
        #rsp.responseJSON
        console.log "error: #{rsp.responseText}"
      )

$(document).ready(signup_handler)
$(document).on('page:load', signup_handler)
