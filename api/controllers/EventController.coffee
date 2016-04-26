###*
# EventController
#
# @description :: Server-side logic for managing Events
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###

module.exports = {
  
  create: (req, res) -> #user association happens in afterCreate callback
    sails.log.debug "Hit the events controller/create"
    sails.log.debug "Params #{ JSON.stringify req.body }"
    req.body.price = parseInt( req.body.price )
    req.body.start_date =  DateService.create_timestamp( req.body.start_date )
    req.body.end_date = DateService.create_timestamp( req.body.end_date )
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

    team_events = new Array()

    sails.log.debug req.body.teams_array.length
    create_events = ( teams_array, index ) ->
      console.log "index #{ index }"
      console.log "teams array #{ teams_array.length }"
      if index >= teams_array.length
        console.log "Finished="
        res.json index
        return false
        
      ++index
      req.body.event_details.event_team = index
      Event.create( req.body.event_details ).then( ( event_created ) ->
        sails.log.debug "Event created #{ JSON.stringify event_created }"
        EventService.org_event_associations( event_created.id, index, ( err, resp ) ->
          if err
            sails.log.debug "Multiple associations err"
          else
            sails.log.debug "Multiple associations done"
        )
      ).catch( ( event_created_err ) ->
        sails.log.debug "Event created err #{ JSON.stringify event_created_err }"
      )


      create_events( teams_array, index )

    create_events( req.body.teams_array, 0 )
    console.log "i am here"
      

      
      

    
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