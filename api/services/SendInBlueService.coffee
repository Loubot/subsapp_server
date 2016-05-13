require('../../node_modules/mailin/mailin.js')
client = new Mailin('https://api.sendinblue.com/v2.0', '0E6kXPLmN3SpcbJM')


module.exports = {
  send_message: ->
    sails.log.debug "Hit the SendInBlueService/send_message"
    data = {
      from: 'Excited User <me@samples.mailgun.org>',
      to: 'louisangelini@gmail.com',
      subject: 'Hello',
      text: 'Testing some Mailgun awesomness!'
    }

    mailgun.messages().send data, (error, body) ->
      sails.log.debug "Body #{ JSON.stringify body }"
      sails.log.debug "Err #{ JSON.stringify error }" if error?


  withdrawl_message: ( amount, org_name, email ) ->
    data =
      'to': 'louisangelini@gmail.com': 'to whom!'
      'from': [
        'lllouis@subzapp.com'
      ]
      'subject': 'TEST'
      'html': 'This is the <h1>HTML</h1>'
    client.send_email(data).on 'complete', (data) ->
      console.log data
      return

  invite_manager: ( id, email, cb ) ->
    sails.log.debug "Hit the SendInBlueService/invite_manager"
    sails.log.debug "id: #{ id } email: #{ email }"
    data = 
      'to': 'louisangelini@gmail.com': 'to whom!'
      'from': [
        'lllouis@subzapp.com'
      ]
      'subject': 'TEST'
      'html': "<a href='http://localhost:1337/#/register-manager?id=#{ id }'>Click her to take control </a>"

    client.send_email(data).on 'complete', (data) ->
      sails.log.debug "Email data #{ JSON.stringify data }"
      cb( null, data )
      return
      
        
}

