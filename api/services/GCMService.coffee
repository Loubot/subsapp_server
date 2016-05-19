gcm = require('node-gcm')
Promise = require('bluebird')
module.exports = {
  send_message: ( event_created, message ) ->
    sails.log.debug "GCMService/send_message"
    sails.log.debug "Event created #{ JSON.stringify event_created }"
    # Team.findOne( id: event_created.event_team )
    # .populate('team_members')
    # .then( ( team ) ->
    #   sails.log.debug "Found team #{ JSON.stringify team }"

    # ).catch( ( team_find_err ) ->
    #   sails.log.debug "Team find err #{ JSON.stringify team_find_err }"
    # )
    message = new (gcm.Message)
    sender = new gcm.Sender( sails.config.GCM.server_key )

    user_query = Promise.promisify( User.query )
    user_query(
      "select p.id as parent_user_id, g.gcm_token, g.event_notifications
      from event e
      left outer join team_team_members__user_user_teams tm on tm.team_team_members = e.event_team
      left outer join user u on u.id = tm.user_user_teams
      left outer join user p on p.email = u.parent_email
      left outer join gcmreg g on g.user_id = p.id 
      where e.id = #{ event_created.id } and g.gcm_token is not null
      group by g.gcm_token"
    ).then( ( user_ids_gcm_tokens ) ->
      sails.log.debug "User ids and gcm tokens #{ JSON.stringify user_ids_gcm_tokens }"
      send_array = new Array()
      for token in user_ids_gcm_tokens
        if Boolean( token.event_notifications )
          send_array.push token.gcm_token

      message.addNotification
        #title: event_created
        title: "New event: " + event_created.name
        body: event_created.details
        icon: 'app_icon'
        
      message.addData
        eventName: event_created.name
        eventDetails: event_created.details
        eventStart: event_created.start_date
        eventEnd: event_created.end_date

      sender.send message, { registrationTokens: send_array }, (err, response) ->
        if err?
          sails.log.debug "GCM err #{ JSON.stringify err }"
        else
          sails.log.debug "GCM response #{ JSON.stringify response }"
        return

    ).catch( ( user_ids_gcm_tokens_err ) ->
      sails.log.debug "User ids and gcm tokens err #{ JSON.stringify user_ids_gcm_tokens_err }"
    )

  send_message_with_players_ids: ( event_created, event_members ) ->
    sails.log.debug "Hit the GCMService/send_message_with_players_ids"
    
    GCMReg.find( user_id: event_members ).then( ( gcmregs ) ->
      sails.log.debug "Found GCMRegs #{ JSON.stringify gcmregs }"
      
    ).catch( ( err ) ->
      sails.log.debug "GCMReg find err #{ JSON.stringify err }"
    )

    
}
