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
      user.tokens[0].amount = user.tokens[0].amount - req.body.event_price
      sails.log.debug "user tokens #{ user.tokens[0].amount }"
      user.user_events.add( req.body.event_id )
      user.save ( err, saved ) ->
        sails.log.debug "User event updated #{ JSON.stringify saved }"
        sails.log.debug "User event update error #{ JSON.stringify err }" if (err?)
        res.created user: saved, message: 'You have paid for this event'
      user.tokens[0].save ( err, saved ) ->
        sails.log.debug "User token updated #{ JSON.stringify saved }"
        sails.log.debug "User token update error #{ JSON.stringify err }" if (err?)
      # res.send user.tokens
    ).catch( ( err ) ->
      sails.log.debug "Join event user find error #{ JSON.stringify err }"
    )
      

}