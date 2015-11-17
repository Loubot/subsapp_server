$(document).ready ->
  $('.login_button').on 'click', (e) ->    
    e.preventDefault()

    $.post
      type: 'POST'
      url: "http://localhost:1337/auth/signin"
      data:
        email: 'as'
    