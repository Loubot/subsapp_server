gcm = require('node-gcm')

module.exports = {
  send_message: ( title, message ) ->
    sails.log.debug "GCMService/send_message"
    message = new (gcm.Message)
    message.addNotification
      title: title
      body: message
      icon: 'ic_launcher'

    sender = new gcm.Sender( sails.config.GCM.server_key )

    sender.send message, { registrationTokens: ['dVcOOkUoAJU:APA91bFTCws0FrkYc1QZentSG42pYkXGaIncdVruDwDtO3H6q1lB-zMoJWf_T_MzbXLvMCkJzhpC3HyqkHZiikdlJcZXiHL0d5Uo_PJI2L49W35LZLhEtLl06nOI_CRamfVhAtR0u1nT'] }, (err, response) ->
      if err?
        sails.log.debug "GCM err #{ JSON.stringify err }"
      else
        sails.log.debug "GCM response #{ JSON.stringify response }"
      return
}