api_key = process.env.MAILGUN_PRIVATE

domain = "sandbox8fb7da333b2d4f5bbb8b66b0eb62ae65.mailgun.org"

mailgun = require('mailgun-js')({apiKey: api_key, domain: domain})

module.exports = {
  send_message: ->
    sails.log.debug "Hit the mailgunservice/send_message"
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
    sails.log.debug "Hit the mailgunservice/withdrawl_message"

    data = {
      from: 'subzappBot <me@samples.mailgun.org>',
      to: 'louisangelini@gmail.com',
      messsage: './views/mail_templates/billing.html'
    }

    mailgun.messages().send data, (error, body) ->
      sails.log.debug "Body #{ JSON.stringify body }"
      sails.log.debug "Err #{ JSON.stringify error }" if error?
}

