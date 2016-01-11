mandrill = require('mandrill-api/mandrill')
m = new mandrill.Mandrill("#{ process.env.SUBZAPP_MANDRILL }")

module.exports = {

  m: m

  send_mail: ( id, email ) ->
    message = 
      'html': "<a href='http://localhost:1337/#/register-manager?id=#{ id }'>Click her to take control </a>"
      'text': email
      'subject': 'You are invited to join subzapp'
      'from_email': 'loubot@subzapp.ie'
      'to': [ {
        'email': email
        }
      ]
    async = false
    m.messages.send {
      'message': message
      'async': async
    }, ((result) ->
      sails.log.debug "result " +  JSON.stringify result
      
      return
    ), (e) ->
      # Mandrill returns the error as an object with name and message keys
      sails.log.debug 'A mandrill error occurred: ' + e.name + ' - ' + e.message
      # A mandrill error occurred: Unknown_Subaccount - No subaccount exists with the id 'customer-123'
      res.serverError "Error sending email", e.message
      return

}