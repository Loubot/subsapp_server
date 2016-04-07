gcm = require('node-gcm')

module.exports = {
  send_message: ( event_created, message ) ->
    sails.log.debug "GCMService/send_message"
    Team.findOne( id: event_created.event_team ).then( ( team ) ->
      sails.log.debug "Found team #{ JSON.stringify team }"
    ).catch( ( team_find_err ) ->
      sails.log.debug "Team find err #{ JSON.stringify team_find_err }"
    )
    message = new (gcm.Message)
    message.addNotification
      title: event_created
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