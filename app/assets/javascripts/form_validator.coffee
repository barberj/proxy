class @FormValidator

  constructor: (form) ->
    @form = form

  required_are_satisfied: ->
    requirements = @form.find('.required')
    missing = (required for required in requirements when required.value == "")
    if missing.length == 0
      for required in requirements
        $(required).removeClass('missing_required')
    else
      for required in requirements
        $(required).removeClass('missing_required') unless required in missing
      for required in missing
        $(required).addClass('missing_required')
    return missing.length == 0

  confirmed_are_satisfied: ->
    confirmed = @form.find('[class~="confirm"]')
    if confirmed.length > 0
      for input in confirmed
        confirm_value = input.value
        confirmation_value = $(".confirm_#{input.name}").val()
        if confirm_value != confirmation_value
          return false
    return true

  is_valid: ->
    @required_are_satisfied() && @confirmed_are_satisfied()
