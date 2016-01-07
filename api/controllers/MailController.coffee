###*
# MailController
#
# @description :: Server-side logic for sending mails
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###

module.exports = {
    
  
 
  send_mail: (req, res) ->
    sails.log.debug "Mandrill" +  MandrillService.m
    sails.log.debug "Params #{ JSON.stringify req.body }"
    m = MandrillService.m
    message = 
      'html': '<p>Example HTML content</p>'
      'text': req.body.url
      'subject': 'You are invited to join subzapp'
      'from_email': 'lllouis@yahoo.com'
      'from_name': 'Example Name'
      'to': [ {
        'email': req.body.manager_email
        'name': req.body.manager_name
        'type': 'to'
        }
      ]
    async = true
    ip_pool = 'Main Pool'
    m.messages.send {
      'message': message
      'async': async
    }, ((result) ->
      sails.log.debug "result " +  JSON.stringify result
      res.ok "Email delivered ok"
      return
    ), (e) ->
      # Mandrill returns the error as an object with name and message keys
      sails.log.debug 'A mandrill error occurred: ' + e.name + ' - ' + e.message
      # A mandrill error occurred: Unknown_Subaccount - No subaccount exists with the id 'customer-123'
      res.serverError "Error sending email", e.message
      return

}
