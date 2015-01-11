show_installed = ->
  if not window.App.installed_apis?
    get_installed()
  if window.App.installed_apis? and window.App.installed_apis.length > 0
    html = HandlebarsTemplates['installed_apis/index'](window.App)
    $('.installed').html(html)

get_installed = (callback) ->
  if not window.App.installed_apis?
    $.ajax(
      url: '/api/v1/installed_apis',
      type: 'GET',
      beforeSend: (xhr) ->
        xhr.setRequestHeader "Authorization", "Token #{window.App.token}"
    ).done (rsp) =>
      if rsp.installed_apis? and rsp.installed_apis.length > 0
        window.App.installed_apis = rsp.installed_apis
        show_installed()

show_encodings = ->
  if not window.App.data_encodings?
    get_encodings()
  if window.App.data_encodings? and window.App.data_encodings.length > 0
    html = HandlebarsTemplates['data_encodings/index'](window.App)
    $('.encodings').html(html)

get_encodings = (callback) ->
  if not window.App.data_encodings?
    $.ajax(
      url: '/api/v1/data_encodings',
      type: 'GET',
      beforeSend: (xhr) ->
        xhr.setRequestHeader "Authorization", "Token #{window.App.token}"
    ).done (rsp) =>
      if rsp.data_encodings? and rsp.data_encodings.length > 0
        window.App.data_encodings = rsp.data_encodings
        show_encodings()

$(document).on "dashboard.load", (e, obj) =>
  show_installed()
  show_encodings()
