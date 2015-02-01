default_error_cb = (rsp) =>
  alertify.error(rsp.resposneText)

bind_upload_image_handlers = () ->
  $('.btn-file :file').change (event) ->
    label = $(@).val().replace(/\\/g, '/').replace(/.*\//, '')
    $(@).trigger('fileselect', label)
  $('.btn-file :file').on('fileselect', (event, label) ->
    input = $(@).parents('.input-group').find(':text')
    input.val(label)
  )

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
  $.event.trigger "rendered.user"
  $('.user-update').click (event) ->
    event.preventDefault()
    form = $(@).closest('form')
    if new FormValidator(form).is_valid()
      proxy_request('PUT', form.get(0).action, form.serialize(), ((rsp) =>
        $.event.trigger "updated.user"
        alertify.success("Successfully updated.")
      ))
    else
      alertify.error("Your submission is invalid. Please verify and re-try.")

get_user = ->
  proxy_request('GET', "/v1/app/users/#{window.App.user_id}", {}, ((rsp) =>
    window.App.user = rsp.user
    $.event.trigger "populated.user"
  ))

bind_api_install = () ->
  $('.install').click (event) ->
    event.preventDefault()
    proxy_request('POST', '/v1/app/marketplace', { api_id: $(@).data('id') }, ((rsp) =>
      installed = rsp.data_encoding
      window.location = "#{installed.install_url}&redirect_uri=#{window.location.origin + window.location.pathname}"
    ))

bind_marketplace_handlers = () ->
  bind_api_install()

render_market = ->
  html = HandlebarsTemplates['marketplace/index'](window.App)
  $('.market-apis').html(html)
  $.event.trigger "opened.market"

show_publisher = (rsp) =>
  $.event.trigger "show.publisher"

upload_api_image = (api, callback) =>
  if image = ($('input[type="file"]')[0].files[0] || $('input[type="file"]')[1].files[0])
    fd = new FormData()
    fd.append('image', image)
    xhr = new XMLHttpRequest()
    xhr.open("POST", "/v1/app/apis/#{api.id}/image")
    xhr.setRequestHeader "Authorization", "Token #{window.App.token}"
    xhr.onreadystatechange = callback
    xhr.send(fd)
  else
    callback()

create_api_image = (api) =>
  upload_api_image(api, show_publisher)

update_api_image = (api) =>
  upload_api_image(api, show_published)

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
    proxy_request('POST', form.get(0).action, form.serialize(), create_api_image)
  $('.publisher-cancel').click (event) ->
    event.preventDefault()
    $.event.trigger "show.publisher"
  bind_upload_image_handlers()


get_market_images = ->
  for api in window.App.market_apis
    proxy_request('GET', "/v1/app/apis/#{api.id}/image", {}, ((rsp) ->
      if api = find_api(rsp.api_id, window.App.market_apis)
        api.image = rsp.image
      $.event.trigger "populated.market"
    ))
  $.event.trigger "populated.market"

get_market = ->
  proxy_request('GET', '/v1/app/marketplace', {}, ((rsp) =>
    window.App.market_apis = rsp.apis
    $.event.trigger "populated.market_apis"
  ))

show_published = ->
  $(".editor").hide()
  $('.app-content').hide()
  $('.marketplace').show()
  get_published()

bind_published_handlers = ->
  bind_api_install()
  $('.del-api').click (event) ->
    event.preventDefault()
    remove_api($(@).data('id'))
    proxy_request('DELETE', "/v1/app/apis/#{$(@).data('id')}", {}, ((rsp) =>
      $.event.trigger "populated.published_apis"
    ))
  $('.edit-api').click (event) ->
    $('.app-content').hide()
    event.preventDefault()
    api = find_api($(@).data('id'), window.App.published_apis)
    html = HandlebarsTemplates['apis/editor'](api)
    $('.editor').html(html)
    $('.editor').show()
    bind_upload_image_handlers()
    $('.editor-save').click (event) ->
      event.preventDefault()
      form = $(@).closest('form')
      proxy_request('PUT', form.get(0).action, form.serialize(), update_api_image)
    $('.editor-cancel').click (event) ->
      event.preventDefault()
      show_publisehd()

render_published = ->
  html = HandlebarsTemplates['apis/index'](window.App)
  $('.my-market-apis').html(html)
  $.event.trigger "rendered.published"

get_published_images = ->
  for api in window.App.published_apis
    proxy_request('GET', "/v1/app/apis/#{api.id}/image", {}, ((rsp) ->
      if api = find_api(rsp.api_id, window.App.published_apis)
        api.image = rsp.image
      $.event.trigger "populated.published"
    ))

get_published = ->
  proxy_request('GET', '/v1/app/apis', {}, ((rsp) =>
    window.App.published_apis = rsp.apis
    $.event.trigger "populated.published_apis"
  ))

find_encoding = (id) ->
  for encoding in window.App.data_encodings
    if encoding.id is id
      return encoding

find_api = (id, collection) ->
  casted_id = parseInt(id)
  for api in collection
    if api.id is casted_id
      return api

remove_api = (id) ->
  casted_id = parseInt(id)
  for index, api of window.App.market_apis
    if api.id is casted_id
      window.App.market_apis.splice(index, 1)

  for index, api of window.App.published_apis
    if api.id is casted_id
      window.App.published_apis.splice(index, 1)

handle_encoding_actions = ->
  $('.del-encoding').click (event) ->
    event.preventDefault()
    $(@).data('id')
    proxy_request('DELETE', "/v1/app/data_encodings/#{$(@).data('id')}" , {}, ((rsp) =>
      $.event.trigger "encoding.updated"
    ))
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
        $.event.trigger "show.dashboard"
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
  handle_encoding_actions()

get_encodings = ->
  proxy_request('GET', '/v1/app/data_encodings', {}, ((rsp) =>
    window.App.data_encodings = rsp.data_encodings
    for encoding in window.App.data_encodings
      if api = (find_api(encoding.api_id, window.App.market_apis) || find_api(encoding.api_id, window.App.published_apis))
        encoding.api = api
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
  $.event.trigger "show.dashboard"
  $.event.trigger "show.publisher"

  setup_handlers()
  get_user()
  get_market()
  get_published()

$(document).on "encoding.updated", get_encodings

$(document).on "populated.encodings", () =>
  render_encodings()
  setup_handlers()

$(document).on "populated.user", render_user

$(document).on "populated.market_apis", get_market_images
$(document).on "populated.market", render_market
$(document).on "opened.market", () ->
  bind_marketplace_handlers()
  get_encodings()

$(document).on "populated.published_apis", get_published_images
$(document).on "populated.published", render_published
$(document).on "rendered.published", () ->
  bind_published_handlers()
  get_encodings()

$(document).on "show.dashboard", render_dashboard
$(document).on "show.publisher", render_publisher

