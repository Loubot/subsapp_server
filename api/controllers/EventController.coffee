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

    Event.create( name: req.body.name, date: req.body.date, event_team: req.body.team_id ).then( (res) ->
      sails.log.debug "Event create response #{ JSON.stringify res }"
      # res.send res
    ).catch((err) ->
      sails.log.debug "Create event error #{ JSON.stringify err }"
      res.send err
    ).done ->
      sails.log.debug "Create event done"

      Event.find( event_team: req.body.team_id).exec ( e, events ) ->
        sails.log.debug "Event created return all events #{ JSON.stringify events }"
        sails.log.debug "Event creaed return all events error #{ JSON.stringify e }" if (err?)

        res.send events

    
      

}