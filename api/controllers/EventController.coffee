###*
# EventController
#
# @description :: Server-side logic for managing Events
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###

module.exports = {
  
  create_event: (req, res) ->
    sails.log.debug "Hit the events controller/create_event"
    sails.log.debug req.body

    Event.create( name: req.body.name, date: req.body.date, event_team: req.body.team_id, price: parseInt(req.body.price) ).then( (res) ->
      sails.log.debug "Event create response #{ JSON.stringify res }"
      # res.send res
    ).catch((err) ->
      sails.log.debug "Create event error #{ JSON.stringify err }"
      res.serverError err
    ).done ->
      sails.log.debug "Create event done"

      Event.find( event_team: req.body.team_id).exec ( e, events ) ->
        sails.log.debug "Event created return all events #{ JSON.stringify events }"
        sails.log.debug "Event creaed return all events error #{ JSON.stringify e }" if (err?)

        res.send events

    
  join_event: ( req, res ) ->
    sails.log.debug "Hit the Payment controller/pay_for_event"
    sails.log.debug "Pay for event params #{ JSON.stringify req.body }"
    User.findOne( id: req.body.user_id ).populate( 'user_events' ).populate('tokens').then( ( user ) ->
      sails.log.debug "Join event user find/populate #{ JSON.stringify user.tokens }"

      if ( user.tokens[0].amount - req.body.event_price < 0 )
        res.serverError "You don't have enough tokens" 
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
        User.findOne( id: req.body.user_id ).populate('tokens').populate('user_events').exec ( err, user ) ->
          sails.log.debug "Populate user #{ JSON.stringify user }"
          sails.log.debug "Populate user error #{ JSON.stringify err }" if(err?)
          res.ok user: user, message: "You have joined this event"
      )
    ).catch( ( err ) ->
      sails.log.debug "Join event user find error #{ JSON.stringify err }"
      res.serverError "Payment failed"
    )

  get_event_members: ( req, res ) ->
    sails.log.debug "Hit the event controller/get_event_members"
    # Event.findOne( )
    
    Event.findOne( id: req.query.event_id ).populate('event_user').then( ( result ) ->
      sails.log.debug "Event find #{ JSON.stringify result }"
      res.send result
      
    ).catch( ( err ) ->
      sails.log.debug "Event find error #{ JSON.stringify err }"
      res.serverError err
    )
 
}