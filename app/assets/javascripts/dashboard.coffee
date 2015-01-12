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
    show_installed()

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
      $('.dashboard').click()

show_market = ->
  html = HandlebarsTemplates['market_place/index'](window.App)
  $('.market-place').html(html)
  handle_install_events()

populate_market = ->
  $.ajax(
    url: '/api/v1/market_place',
    type: 'GET',
    beforeSend: (xhr) ->
      xhr.setRequestHeader "Authorization", "Token #{window.App.token}"
  ).done (rsp) =>
    window.App.market_apis = rsp.apis
    show_market()

find_encoding = (id) ->
  for encoding in window.App.data_encodings
    if encoding.id is id
      return encoding

handle_encoding_events = ->
  $('.edit-encoding').click (event) ->
    event.preventDefault()
    if window.App.data_encodings
      encoding = find_encoding($(@).data('id'))
      html = HandlebarsTemplates['data_encodings/edit'](encoding)
      $('#inline-fancy-box').html(html)
      $.fancybox.open(
        href: '#inline-fancy-box',
        autoSize: false
      )

show_encodings = ->
  html = HandlebarsTemplates['data_encodings/index'](window.App)
  $('.encodings').html(html)
  handle_encoding_events()

get_encodings = (callback) ->
  $.ajax(
    url: '/api/v1/data_encodings',
    type: 'GET',
    beforeSend: (xhr) ->
      xhr.setRequestHeader "Authorization", "Token #{window.App.token}"
  ).done (rsp) =>
    window.App.data_encodings = rsp.data_encodings
    show_encodings()

setup_handlers = ->
  $('.market').click (event) ->
    $('.app-content').hide()
    event.preventDefault()
    $('li.active').removeClass('active')
    $(@).closest('li').addClass('active')
    $('.market-place').show()

  $('.dashboard').click (event) ->
    event.preventDefault()
    $('.app-content').hide()
    $('li.active').removeClass('active')
    $('.my-stuff').show()

render_default = ->
  $("#inline-fancy-box").hide()
  $('.app-content').hide()
  $('.my-stuff').show()

$(document).on "dashboard.load", (e, obj) =>
  render_default()

  setup_handlers()
  populate_market()
  get_installed()
  get_encodings()

$(document).on "api.installed", get_installed
$(document).on "api.installed", get_encodings
