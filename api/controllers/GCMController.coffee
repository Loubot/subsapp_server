###*
# GCMController
#
# @description :: Server-side logic for managing GCM messages
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###
gcm = require('node-gcm')

module.exports = {

  send_message: ( req, res ) ->
    sails.log.debug "Hit the GCMController/send_message"
    
    message = new (gcm.Message)(
      collapseKey: 'demo'
      priority: 'high'
      contentAvailable: true
      delayWhileIdle: true
      timeToLive: 3
      restrictedPackageName: 'somePackageName'
      dryRun: true
      data:
        key1: 'message1'
        key2: 'message2'
      notification:
        title: 'Hello, World'
        icon: 'ic_launcher'
        body: 'This is a notification that will be displayed ASAP.')

    sender = new gcm.Sender( sails.config.GCM.server_key )

    sender.send message, { registrationTokens: ['dvx-9DgxrYc:APA91bGoh-5hNSzIV2xUHP5LLLMqnq68PqokA71uToIVEXdQC69LN4BakHHYbPORCGrjZRb8VbgmsStdG6I_SlUdD0Gfavpt5VW8W8CJW1LbDWeEc0KzWsg7hoRGGbHilCeanEqrphfD'] }, (err, response) ->
      if err?
        sails.log.debug "GCM err #{ JSON.stringify err }"
        res.negotiate err
      else
        sails.log.debug "GCM response #{ JSON.stringify response }"
        res.json response
      return
}