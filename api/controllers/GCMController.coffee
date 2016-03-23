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
      notification:
        title: 'Hello, World'
        text: 'This is a notification that will be displayed ASAP.')


    sender = new gcm.Sender( sails.config.GCM.server_key )

    sender.send message, { registrationTokens: ['dVcOOkUoAJU:APA91bFTCws0FrkYc1QZentSG42pYkXGaIncdVruDwDtO3H6q1lB-zMoJWf_T_MzbXLvMCkJzhpC3HyqkHZiikdlJcZXiHL0d5Uo_PJI2L49W35LZLhEtLl06nOI_CRamfVhAtR0u1nT'] }, (err, response) ->
      if err?
        sails.log.debug "GCM err #{ JSON.stringify err }"
        res.negotiate err
      else
        sails.log.debug "GCM response #{ JSON.stringify response }"
        res.json response
      return
}