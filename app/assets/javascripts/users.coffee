signup_handler = ->
  $(".js-signup").click (event) ->
    event.preventDefault()
    form = $(@).closest('form')
    requirements = form.find('.required')
    missing = (required for required in requirements when required.value == "")
    if missing.length == 0
      for required in requirements
        $(required).removeClass('missing_required')
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
    else
      for required in requirements
        $(required).removeClass('missing_required') unless required in missing
      for required in missing
        $(required).addClass('missing_required')

$(document).ready(signup_handler)
$(document).on('page:load', signup_handler)
