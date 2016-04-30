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


  org_event_associations: ( event_id, team_id, cb ) ->
    sails.log.debug "Hit the EventService/org_event_associations"
    sails.log.debug "Team id #{ team_id }"

    do_team_association = ( team_members, index, callback ) ->
      sails.log.debug "do_team_association index #{ index }"
      sails.log.debug "do_team_association team_members #{ team_members.length }"
      if index >= team_members.length
        sails.log.debug "Finished do_team_association"
        callback( null, "We are finished ")
        return false

      sails.log.debug "User #{ JSON.stringify team_members[index]}"

      team_members[ index ].user_events.add( event_id )
      team_members[ index ].save ( err, saved ) ->
        if err
          sails.log.debug "Team member save err #{ JSON.stringify err }"
        else
          sails.log.debug "Team member saved"

        ++index
        do_team_association( team_members, index, callback )



    Team.findOne( team_id ).populate('team_members').then( ( team ) ->
      sails.log.debug "Found team #{ JSON.stringify team.team_members.length }"

      do_team_association( team.team_members, 0, cb )

    ).catch( ( team_find_err ) ->
      sails.log.debug "Team find err #{ JSON.stringify team_find_err }"
    )
  

  org_event_associations_managers: ( managers, event_id, cb ) ->
    sails.log.debug "Hit the EventService/org_event_associations_managers"
    sails.log.debug "Managers #{ JSON.stringify managers }"

    do_manager_associations = ( manager_array, index, event_id, callback ) ->
      sails.log.debug "do_manager_associations index #{ index }"
      sails.log.debug "do_manager_associations manager_array #{ manager_array.length }"

      if index >= manager_array.length
        sails.log.debug "Finished do_manager_associations"
        callback( null, "We are finished managers" )
        return false

      sails.log.debug "Manager! #{ JSON.stringify manager_array[index] }"

      manager_array[ index ].user_events.add( event_id )
      manager_array[ index ].save ( err, saved ) ->
        if err
          sails.log.debug "Manger save error #{ JSON.stringify err }"
        else
          sails.log.debug "Manager saved"

        ++index
        do_manager_associations( manager_array, index, event_id, callback ) # back to the start


    do_manager_associations( managers, 0, event_id, cb )



}