###*
# EventController
#
# @description :: Server-side logic for managing Events
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###

module.exports = {
  
  create_event: (req, res) ->
    sails.log.debug req.body
    # Event.create( name: req.body.)
}