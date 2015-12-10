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
      res.send res
    ).catch((err) ->
      sails.log.debug "Create event error #{ JSON.stringify err }"
    ).done ->
      sails.log.debug "Create event done"

    
      

}