#Service to help format params before saving

module.exports = {

  format_coords: ( raw_coords ) ->
    sails.log.debug "Hit the ParamService"
    sails.log.debug "Raw coords #{ JSON.stringify raw_coords }"
    return raw_coords

}