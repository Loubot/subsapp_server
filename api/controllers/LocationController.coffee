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
    
    Location.updateOrCreate( { id: req.body.id}, body, ( location_err, location ) ->
      if location_err?
        sails.log.debug "Location find or create err #{ JSON.stringify location_err }"
        return res.negotiate location_err
      else
        Org.findOne( id: req.body.org_id ).populate( 'org_locations' ).then( ( org_found ) ->
          sails.log.debug "Org found #{ JSON.stringify org_found }"
          res.json org_found
        ).catch( ( org_found_err ) ->
          sails.log.debug "Org find err #{ JSON.stringify org_found_err }"
          res.negotiate org_found_err
        )
    )

  index: ( req, res ) ->
    sails.log.debug "Hit the LocationController/index"
    Location.find().sort('location_owner ASC').then( ( locations ) ->
      sails.log.debug "Got locations "
      res.json locations
    ).catch( ( err ) ->
      sails.log.debug "locations all err #{ JSON.strigify err }"
      res.negotiate err
    )


}
