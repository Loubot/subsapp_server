require('../../node_modules/mailin/mailin.js')
client = new Mailin('https://api.sendinblue.com/v2.0', '0E6kXPLmN3SpcbJM')


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
}

