render_user = ->
  html = HandlebarsTemplates['user/show'](window.App)
  $('.user-settings').html(html)

handle_installs = () ->
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

render_market = ->
  html = HandlebarsTemplates['market_place/index'](window.App)
  $('.market-apis').html(html)
  $.event.trigger "market.open"

render_publisher = ->
  html = HandlebarsTemplates['market_place/publisher']()
  $('.draft').html(html)
  $('.add-resource').click (event) ->
    html = HandlebarsTemplates['market_place/resource']()
    $('.resources').append(html)
  $('.publisher-save').click (event) ->
    event.preventDefault()
    form = $(@).closest('form')
    data = form.serialize()
    $.ajax(
      url: form.get(0).action,
      type: 'POST',
      data: form.serialize(),
      beforeSend: (xhr) ->
        xhr.setRequestHeader "Authorization", "Token #{window.App.token}"
    ).done( (rsp) =>
      $.event.trigger "publisher.show"
    ).fail( (rsp) =>
      #rsp.responseJSON
      console.log "error: #{rsp.responseText}"
    )
  $('.publisher-cancel').click (event) ->
    event.preventDefault()
    $.event.trigger "publisher.show"

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
      html = HandlebarsTemplates['data_encodings/editor'](encoding)
      $('.editor').html(html)
      $('.editor').show()
      $('.editor-cancel').click (event) ->
        event.preventDefault()
        $.event.trigger "dashboard.show"
      $('[data-toggle="popover"]').popover(trigger: 'hover')

      $('.editor-save').click (event) ->
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
          $.event.trigger "encoding.updated"
        ).fail( (rsp) =>
          #rsp.responseJSON
          console.log "error: #{rsp.responseText}"
        )

render_encodings = ->
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
  $('.settings').click (event) ->
    event.preventDefault()
    $('.app-content').hide()
    $('li.navigation.active').removeClass('active')
    $(@).closest('li').addClass('active')
    $('.user-settings').show()

  $('.market').click (event) ->
    event.preventDefault()
    $('.app-content').hide()
    $('li.navigation.active').removeClass('active')
    $(@).closest('li').addClass('active')
    $('.market-place').show()

  $('.dash').click (event) ->
    event.preventDefault()
    $('.app-content').hide()
    $('li.navigation.active').removeClass('active')
    $('.dashboard').show()

render_dashboard = ->
  $(".editor").hide()
  $('.app-content').hide()
  $('.dashboard').show()

$(document).on "dashboard.load", () =>
  $.event.trigger "dashboard.show"
  $.event.trigger "publisher.show"

  setup_handlers()
  get_market()
  get_encodings()
  render_user()

$(document).on "api.installed", () =>
  get_encodings()

$(document).on "encoding.updated", get_encodings

$(document).on "populated.encodings", () =>
  setup_handlers()
  render_encodings()

$(document).on "populated.market", render_market

$(document).on "dashboard.show", render_dashboard
$(document).on "publisher.show", render_publisher

$(document).on "market.open", handle_installs
