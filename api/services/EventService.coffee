module.exports = {
  team_event_associations: ( team_id, event_id, cb ) ->
    sails.log.debug "Hit the EventService/team_event_associations"

    Team.findOne( id: team_id ).populate('team_members').then( ( team ) ->
      sails.log.debug "Event afterCreate Team find #{ JSON.stringify team }"
      for user in team.team_members
        sails.log.debug "User loop #{ JSON.stringify user }"
        user.user_events.add event_id
        user.save ( err, saved ) ->
          sails.log.debug "Event afterCreate User save err #{ JSON.stringify err }" if err?
          sails.log.debug "Event afterCreate User save #{ JSON.stringify saved }" 

      cb( null, 'Yep' )

    ).catch( ( err ) ->
      sails.log.debug "Event afterCreate Team find err #{ JSON.stringify err }"
      cb( err )
    )


  org_event_associations: ( body ) ->
    sails.log.debug "Hit the EventService/org_event_associations"

    team_create_associations( id, cb ) ->
      Team.findOne( id ).populate('team_members').then( ( team_found ) ->
        sails.log.debug "Team found #{ JSON.stringify team }"
        for user in team.team_members
          sails.log.debug "User loop #{ JSON.stringify user }"
          user.user_events.add event_id
          user.save ( err, saved ) ->
            sails.log.debug "Event afterCreate User save err #{ JSON.stringify err }" if err?
            sails.log.debug "Event afterCreate User save #{ JSON.stringify saved }" 

        cb( null, 'Yep' )
      ).catch( ( team_found_err ) ->
        sails.log.debug "Team not found"
        cb( team_found_err )
      )


    if body.teams_array.length > 0
      for team in body.teams_array
        team_create_associations( team, ( err, done ) ->
          if err?
            sails.log.debug "bla"
          else
            sails.log.debug "Team: #{ team } done"
        )



}