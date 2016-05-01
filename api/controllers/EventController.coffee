###*
# EventController
#
# @description :: Server-side logic for managing Events
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###
Promise = require('bluebird')
module.exports = {
  
  create: (req, res) -> #user association happens in afterCreate callback
    sails.log.debug "Hit the EventController/create"
    sails.log.debug "Params #{ JSON.stringify req.body }"
    req.body.price = parseInt( req.body.price )
    req.body.start_date =  DateService.create_timestamp( req.body.start_date )
    req.body.end_date = DateService.create_timestamp( req.body.end_date )
    req.body.kick_off_date = DateService.create_timestamp( req.body.kick_off_date ) if req.body.kick_off_date?
    Event.create( 
      req.body      
    ).then( ( event_created ) ->
      sails.log.debug "Event create response #{ JSON.stringify event_created }"
      GCMService.send_message( event_created, "Trainging at #{ event_created.start_date }" )
      EventService.team_event_associations( event_created.event_team, event_created.id, ( associations_err, cb ) ->
        if associations_err?
          sails.log.debug "Event create team_event_associations err #{ JSON.stringify associations_err }"
        else 
          sails.log.debug "Event created with associations"
          res.json event_created
      )
      res.json event_created
    ).catch((err) ->
      sails.log.debug "Create event error #{ JSON.stringify err }"
      res.negotiate err
    )

  create_multi_event: ( req, res ) -> # Create event for multiple teams or managers
    sails.log.debug "Hit the EventController/create_multi_event"
    sails.log.debug "Params #{ JSON.stringify req.body }"
    req.body.price = parseInt( req.body.price )
    req.body.event_details.start_date =  DateService.create_timestamp( req.body.event_details.start_date )
    req.body.event_details_date = DateService.create_timestamp( req.body.event_details.end_date )


    teams =  new Promise( ( resolve, reject ) ->
      create_events_teams = ( teams_array, index ) -> #recursively create events
        console.log "index #{ index }"
        console.log "teams array #{ teams_array.length }"
        if index >= teams_array.length
          console.log "Finished="
          resolve( "Finished team events" )
          return false
          
        ++index
        req.body.event_details.event_team = index
        Event.create( req.body.event_details ).then( ( event_created ) ->
          sails.log.debug "Event created #{ JSON.stringify event_created }"
          EventService.org_event_associations_clubs( event_created.id, index, ( err, resp ) ->
            if err
              sails.log.debug "Multiple associations err"
            else
              sails.log.debug "Multiple associations done"

          )
        ).catch( ( event_created_err ) ->
          sails.log.debug "Event created err #{ JSON.stringify event_created_err }"
          if Object.keys( event_created_err ).length != 0
            reject()
        )


        create_events_teams( teams_array, index ) #recursively create events
      create_events_teams( req.body.teams_array, 0 )
    ) # end of teams promise
      ###################### end of create events ##############################
    
      
    managers_promise = new Promise( ( resolve, reject ) ->
      delete req.body.event_details.event_team
      sails.log.debug "Start managers promise"
      Promise.all([
        User.find( { id: req.body.managers_array }, select: ['id'] ).populate('gcm_tokens')
        Event.create( req.body.event_details )
      ]).spread( ( managers, managers_event_created ) ->
        sails.log.debug "Managers found #{ JSON.stringify managers }"
        sails.log.debug "Managers event #{ JSON.stringify managers_event_created }"
        
        EventService.org_event_associations_managers( managers, managers_event_created.id, ( err, done ) ->
          if err?
            sails.log.debug "bla"
            reject()
          else
            sails.log.debug "associations done"
            resolve( "Finished manager events" )
        ) 
        
      ).catch( ( managers_find_event_err ) ->
        sails.log.debug "Manager find/event create error #{ JSON.stringify managers_find_event_err }"
        res.negotiate managers_find_event_err
      )
    )
    sails.log.debug "Managers array length #{ req.body.managers_array.length }"
    #################### end of managers promise
    if req.body.managers_array.length > 0 and req.body.teams_array.length > 0
      sails.log.debug "Both"
      Promise.all( [ teams, managers_promise ] ).then ( a ) ->
        console.log JSON.stringify a
        sails.log.debug "Hello nurse"
        res.json "Both done"
    else if req.body.managers_array.length > 0
      sails.log.debug "Managers array start"
      managers_promise.then ->
        sails.log.debug "Managers done"
        res.json "Managers done"
    else if req.body.teams_array.length > 0
      sails.log.debug "Teams array start"
      teams.then ->
        sails.log.debug "Teams done"
        res.json "Teams done"
    else 
      res.negotiate "NO good boss"

  
    
      

    
  join_event: ( req, res ) ->
    sails.log.debug "Hit the Payment controller/pay_for_event"
    sails.log.debug "Pay for event params #{ JSON.stringify req.body }"
    User.findOne( id: req.body.user_id ).populate( 'user_events' ).populate('tokens').then( ( user ) ->
      sails.log.debug "Join event user find/populate #{ JSON.stringify user.tokens }"

      if ( user.tokens[0].amount - req.body.event_price < 0 )
        res.negotiate "You don't have enough tokens" 
        return false
      
      sails.log.debug "asdfasdfasdf #{  user.tokens[0].amount - req.body.event_price }"
      user.tokens[0].amount = user.tokens[0].amount - req.body.event_price
      sails.log.debug "user tokens #{ user.tokens[0].amount }"

      user.user_events.add( req.body.event_id )

      user.save( ( err, saved_user ) ->
        sails.log.debug "user saved #{ JSON.stringify saved_user }"
        sails.log.debug "user saved #{ JSON.stringify err }"
        
      )

      user.tokens[0].save( ( saved_user ) ->
        User.findOne( id: req.body.user_id )
        .populate('tokens')
        .populate('user_events')
        .exec ( err, user ) ->
          sails.log.debug "Populate user #{ JSON.stringify user }"
          sails.log.debug "Populate user error #{ JSON.stringify err }" if(err?)
          res.ok user: user, message: "You have joined this event"
      )
    ).catch( ( err ) ->
      sails.log.debug "Join event user find error #{ JSON.stringify err }"
      res.negotiate "Payment failed"
    )

  get_event_members: ( req, res ) ->
    sails.log.debug "Hit the event controller/get_event_members"
    # Event.findOne( )
    
    Event.findOne( id: req.query.event_id ).populate('event_user').then( ( result ) ->
      sails.log.debug "Event find #{ JSON.stringify result }"
      res.send result
      
    ).catch( ( err ) ->
      sails.log.debug "Event find error #{ JSON.stringify err }"
      res.negotiate err
    )

  create_parent_event: ( req, res ) ->
    sails.log.debug "Hit the event controller/create_parent_event"
    sails.log.debug "Params #{ JSON.stringify req.body }"
    ParentEvent.create( 
      req.body
    ).then( ( p_event) ->
      sails.log.debug "Parent event created #{ JSON.stringify p_event }"
      res.json p_event
    ).catch ( err ) ->
      sails.log.debug "Parent event create error #{ JSON.stringify err }"
      res.negotiate err
}