default_error_cb = (rsp) =>
  #rsp.responseJSON
  console.log "error: #{rsp.responseText}"

proxy_request = (method, url, data, done_callback, fail_callback=default_error_cb) ->
  $.ajax(
    url: url,
    type: method,
    data: data
    beforeSend: (xhr) ->
      xhr.setRequestHeader "Authorization", "Token #{window.App.token}"
  ).done(done_callback).fail(fail_callback)

render_user = ->
  html = HandlebarsTemplates['user/show'](window.App)
  $('.user-settings').html(html)

handle_installs = () ->
  $('.install').click (event) ->
    event.preventDefault()
    proxy_request('POST', '/v1/app/marketplace', { api_id: $(@).data('id') }, ((rsp) =>
      installed = rsp.data_encoding
      window.location = "#{installed.install_url}&redirect_uri=#{window.location.origin + window.location.pathname}"
    ))

render_market = ->
  html = HandlebarsTemplates['marketplace/index'](window.App)
  $('.market-apis').html(html)
  $.event.trigger "market.open"

show_publisher = (rsp) =>
  $.event.trigger "publisher.show"

upload_api_image = (api) =>
  if image = $('input[type="file"]')[0].files[0]
    fd = new FormData()
    fd.append('image', image)
    xhr = new XMLHttpRequest()
    xhr.open("POST", "/v1/app/apis/#{api.id}/image")
    xhr.setRequestHeader "Authorization", "Token #{window.App.token}"
    xhr.onreadystatechange = show_publisher
    xhr.send(fd)
  else
    show_publisher()

render_publisher = ->
  html = HandlebarsTemplates['apis/new']()
  $('.draft').html(html)
  window.App.new_resources = 0
  window.App.new_fields = 0
  $('.add-resource').click (event) ->
    window.App.new_resources += 1
    html = HandlebarsTemplates['apis/new_resource'](id: window.App.new_resources)
    $('.resources').append(html)
    $('.rem-resource').click () ->
      resource = $(@).data('target')
      $(resource).remove()
    $('.add-field').click (event) ->
      window.App.new_fields += 1
      fields = $(@).data('target')
      html = HandlebarsTemplates['apis/new_field'](id: window.App.new_fields)
      $(fields).append(html)
      $('.rem-field').click () ->
        field = $(@).data('target')
        $(field).remove()
  $('.publisher-save').click (event) ->
    event.preventDefault()
    form = $(@).closest('form')
    proxy_request('POST', form.get(0).action, form.serialize(), upload_api_image)
  $('.publisher-cancel').click (event) ->
    event.preventDefault()
    $.event.trigger "publisher.show"

get_market = ->
  proxy_request('GET', '/v1/app/marketplace', {}, ((rsp) =>
    window.App.market_apis = rsp.apis
    $.event.trigger "populated.market"
  ))

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
      $('.checked').attr('checked', true)

      $('.editor-save').click (event) ->
        for checkbox in $('input[type="checkbox"]')
          input = $(checkbox).data('target')
          if $(checkbox).prop('checked')
            $(input).val(1)
          else
            $(input).val(0)

        event.preventDefault()
        form = $(@).closest('form')
        data = form.serialize()
        proxy_request('PUT', form.get(0).action, form.serialize(), ((rsp) =>
          $.event.trigger "encoding.updated"
        ))

render_encodings = ->
  html = HandlebarsTemplates['data_encodings/index'](window.App)
  $('.encodings').html(html)
  handle_encoding_edit()

get_encodings = ->
  proxy_request('GET', '/v1/app/data_encodings', {}, ((rsp) =>
    window.App.data_encodings = rsp.data_encodings
    $.event.trigger "populated.encodings"
  ))

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
    $('.marketplace').show()

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

$(document).on "encoding.updated", get_encodings

$(document).on "populated.encodings", () =>
  setup_handlers()
  render_encodings()

$(document).on "populated.market", render_market

$(document).on "dashboard.show", render_dashboard
$(document).on "publisher.show", render_publisher

$(document).on "market.open", handle_installs
