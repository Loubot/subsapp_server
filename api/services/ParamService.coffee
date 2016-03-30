#Service to help format params before saving

module.exports = {
  # Org controller. Change params to latitude and longitude
  fix_lat_lng_name: ( body ) ->
    sails.log.debug "Hit the ParamService/fix_lat_lng_name"

    if body.latitude? or body.longitude?
      if body.latitude?
        body.lat = body.latitude

      if body.longitude?
        body.lng = body.longitude 

    sails.log.debug "New body #{ JSON.stringify body }"
    return body
}