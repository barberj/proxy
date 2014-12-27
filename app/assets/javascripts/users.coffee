$(document).ready ->
  $(".js-signup").click (event) ->
    event.preventDefault()
    form = $(@).closest('form')
    requirements = form.find('.required')
    missing = (required for required in requirements when required.value == "")
    if missing.length == 0
      for required in requirements
        $(required).removeClass('missing_required')
      password = form.find("input[name='password']")
      confirm = form.find("input[name='confirm']")
      if password.get(0).value == confirm.get(0).value
        $.ajax({
          url: form.get(0).action,
          type: form.get(0).method.toUpperCase(),
          data: form.serialize(),
          dataType: "json"
          success: ->
            console.log 'created'
          error: ->
            console.log 'error'
        })
      else
        $(password).addClass('missing_required')
        $(confirm).addClass('missing_required')
    else
      for required in missing
        $(required).addClass('missing_required')
