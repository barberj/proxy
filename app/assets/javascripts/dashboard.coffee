show_apis = ->
  token = $('meta[name=token]').attr('content')
  $.ajax(
    url: '/api/v1/installed_apis',
    type: 'GET',
    beforeSend: (xhr) ->
      xhr.setRequestHeader "Authorization", "Token #{token}"
  ).done( (rsp) =>
    if rsp.apis.length > 0
      html = HandlebarsTemplates['apis/index'](rsp)
      $('.installed-apis').html(html)
  )

$(document).on "dashboard.load", (e, obj) =>
  show_apis()
