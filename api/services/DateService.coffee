moment = require('moment')
module.exports = {
  create_timestamp: ( date ) ->
    sails.log.debug "Hit the DateService"
    sails.log.debug "Original date #{ date }"

    sails.log.debug moment( date, "YYYY-MM-DD HH:mm").toISOString()

    moment( date, "YYYY-MM-DD HH:mm").toISOString()


}