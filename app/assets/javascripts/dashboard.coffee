show_installed = ->
  html = HandlebarsTemplates['installed_apis/index'](window.App)
  $('.installed').html(html)

get_installed = () ->
  $.ajax(
    url: '/api/v1/installed_apis',
    type: 'GET',
    beforeSend: (xhr) ->
      xhr.setRequestHeader "Authorization", "Token #{window.App.token}"
  ).done (rsp) =>
    window.App.installed_apis = rsp.installed_apis
    $.event.trigger "populated.installed"

handle_install_events = () ->
  $('.install').click (event) ->
    event.preventDefault()
    $.ajax(
      url: '/api/v1/market_place',
      type: 'POST',
      data: { api_id: $(@).data('id') },
      beforeSend: (xhr) ->
        xhr.setRequestHeader "Authorization", "Token #{window.App.token}"
    ).done (rsp) =>
      installed = rsp.installed_api
      install_url = "#{$(@).data('install-url')}?token=#{installed.token}"
      window.open(install_url)
      $.event.trigger "api.installed"
      $('.dash').click()

show_market = ->
  html = HandlebarsTemplates['market_place/index'](window.App)
  $('.market-place').html(html)
  handle_install_events()

get_market = ->
  $.ajax(
    url: '/api/v1/market_place',
    type: 'GET',
    beforeSend: (xhr) ->
      xhr.setRequestHeader "Authorization", "Token #{window.App.token}"
  ).done (rsp) =>
    window.App.market_apis = rsp.apis
    $.event.trigger "populated.market"

find_encoding = (id) ->
  for encoding in window.App.data_encodings
    if encoding.id is id
      return encoding

handle_encoding_edit = ->
  $('.edit-encoding').click (event) ->
    event.preventDefault()
    if window.App.data_encodings
      $('.app-content').hide()
      encoding = find_encoding($(@).data('id'))
      html = HandlebarsTemplates['data_encodings/edit'](encoding)
      $('.dash-edit').html(html)
      $('.dash-edit').show()
      $('.dash-edit-cancel').click (event) ->
        event.preventDefault()
        $.event.trigger "dashboard.show"
      $('[data-toggle="popover"]').popover(trigger: 'hover')

      $('.js-save-encoding').click (event) ->
        event.preventDefault()
        form = $(@).closest('form')
        data = form.serialize()
        $.ajax(
          url: form.get(0).action,
          type: 'PUT',
          data: form.serialize(),
          beforeSend: (xhr) ->
            xhr.setRequestHeader "Authorization", "Token #{window.App.token}"
        ).done( (rsp) =>
          console.log('created')
        ).fail( (rsp) =>
          #rsp.responseJSON
          console.log "error: #{rsp.responseText}"
        )

show_encodings = ->
  html = HandlebarsTemplates['data_encodings/index'](window.App)
  $('.encodings').html(html)
  handle_encoding_edit()

get_encodings = ->
  $.ajax(
    url: '/api/v1/data_encodings',
    type: 'GET',
    beforeSend: (xhr) ->
      xhr.setRequestHeader "Authorization", "Token #{window.App.token}"
  ).done (rsp) =>
    window.App.data_encodings = rsp.data_encodings
    $.event.trigger "populated.encodings"

setup_handlers = ->
  $('.market').click (event) ->
    event.preventDefault()
    $('.app-content').hide()
    $('li.active').removeClass('active')
    $(@).closest('li').addClass('active')
    $('.market-place').show()

  $('.dash').click (event) ->
    event.preventDefault()
    $('.app-content').hide()
    $('li.active').removeClass('active')
    $('.dashboard').show()

render_dashboard = ->
  $(".dash-edit").hide()
  $('.app-content').hide()
  $('.dashboard').show()

$(document).on "dashboard.load", (e, obj) =>
  $.event.trigger "dashboard.show"

  setup_handlers()
  get_market()
  get_installed()
  get_encodings()

$(document).on "api.installed", get_installed
$(document).on "api.installed", get_encodings
$(document).on "populated.encodings", show_encodings
$(document).on "populated.installed", show_installed
$(document).on "populated.market", show_market
$(document).on "dashboard.show", render_dashboard
