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

    team_create_associations = ( members, id, counter, cb ) ->
      if counter >= members.length
        sails.log.debug "Finished all assocaitions"
        cb( null, 'Finito' )

      members[ counter ].user_teams.add( id )
      members[ counter ].save ( err, saved ) ->
        if err?
          sails.log.debug "It is not saved "
        else
          sails.log.debug "It is saved"
      counter++

      team_create_associations( members, id, counter, cb )


    if body.teams_array.length > 0
      for team in body.teams_array
        Team.findOne( id: team ).populate('team_members').then( ( team_found ) ->
          sails.log.debug "Team found #{ JSON.stringify team_found }"
          team_create_associations( team_found.team_members, team, 0, ( err, done ) ->
            if err?
              sails.log.debug "Nope"
            else
              sails.log.debug "Team: #{ team } done"
          )
        ).catch( ( team_find_err ) ->
          sails.log.debug "Team find error #{ JSON.stringify team_find_err }"

        )
        



}