###*
# LocationController
#
# @description :: Server-side logic for managing Locations
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###

# passport = require('passport')
# moment = require('moment')
# Promise = require('bluebird')
module.exports = {
  create: ( req, res ) ->
    sails.log.debug "Hit the LocationController/create"
    sails.log.debug "Params #{ JSON.stringify req.body }"
    body = ParamService.fix_lat_lng_name( req.body )
    Location.create( body ).then( ( location ) ->
      sails.log.debug "Location created #{ JSON.stringify location }"
      res.json location
    ).catch( ( location_err ) ->
      sails.log.debug "Location create error #{ JSON.stringify location_err }"
      res.negotiate location_err
    )

    # Location.updateOrCreate( 
    #   { org_id: req.body.org_id } 
    #   body
    #   ( err, location ) ->
    #     if err?
    #       sails.log.debug "Location update or create error"
    #       res.negotiate err
    #     else
    #       sails.log.debug "Location created #{ JSON.stringify location }"
    #       res.json location
    # )
}
