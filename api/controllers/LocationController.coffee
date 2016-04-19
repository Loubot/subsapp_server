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
    # if req.body.id?
    #   Location.update( { id: req.body.id }, body ).then





    Location.updateOrCreate( { id: req.body.id}, body, ( location_err, location ) ->
      if location_err?
        sails.log.debug "Location find or create err #{ JSON.stringify location_err }"
        return res.negotiate location_err
      else
        Org.find( id: req.body.org_id ).populate( 'org_locations' ).then( ( org_found ) ->
          sails.log.debug "Org found #{ JSON.stringify org_found }"
          res.json org_found
        ).catch( ( org_found_err ) ->
          sails.log.debug "Org find err #{ JSON.stringify org_found_err }"
          res.negotiate org_found_err
        )
    )


    # Location.updateOrCreate( { id: req.id}, body ).then( ( location ) ->
    #   sails.log.debug "Location created #{ JSON.stringify location }"
    #   Org.find( id: req.body.org_id ).populate( 'org_locations' ).then( ( org_found ) ->
    #     sails.log.debug "Org found #{ JSON.stringify org_found }"
    #     res.json org_found
    #   ).catch( ( org_found_err ) ->
    #     sails.log.debug "Org find err #{ JSON.stringify org_found_err }"
    #     res.negotiate org_found_err
    #   )
      
    # ).catch( ( location_err ) ->
    #   sails.log.debug "Location create error #{ JSON.stringify location_err }"
    #   res.negotiate location_err
    # )

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
