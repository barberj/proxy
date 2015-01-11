show_apis = ->
  if not window.App.installed_apis?
    get_apis()
  if window.App.installed_apis? and window.App.installed_apis.length > 0
    html = HandlebarsTemplates['installed_apis/index'](window.App)
    $('.installed-apis').html(html)

get_apis = (callback) ->
  if not window.App.installed_apis?
    token = $('meta[name=token]').attr('content')
    $.ajax(
      url: '/api/v1/installed_apis',
      type: 'GET',
      beforeSend: (xhr) ->
        xhr.setRequestHeader "Authorization", "Token #{token}"
    ).done( (rsp) =>
      if rsp.installed_apis? and rsp.installed_apis.length > 0
        window.App.installed_apis = rsp.installed_apis
        show_apis()
    )

$(document).on "dashboard.load", (e, obj) =>
  show_apis()
