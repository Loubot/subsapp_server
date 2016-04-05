#Service to help format params before saving

module.exports = {
  #Org controller. Check if coords are present
  check_if_coors: ( body ) ->
    sails.log.debug "Hit the ParamService/check_if_coors"
    return ( typeof body.latitude != undefined ) or ( typeof body.longitude != undefined ) or ( typeof body.lat != undefined ) or ( typeof body.lng != undefined )
    
  # Org controller. Change params to latitude and longitude
  fix_lat_lng_name: ( body ) ->
    sails.log.debug "Hit the ParamService/fix_lat_lng_name"

    if ( typeof body.latitude != undefined ) or ( typeof body.longitude != undefined )
      if typeof body.latitude != undefined
        body.lat = body.latitude

      if body.longitude != undefined
        body.lng = body.longitude 

    sails.log.debug "New body #{ JSON.stringify body }"
    return body
}