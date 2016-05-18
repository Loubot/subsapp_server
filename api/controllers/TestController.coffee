###*
# TestController
#
# @description :: Server-side logic for testting
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###
Promise = require('bluebird')
module.exports = {

  test: ( req, res ) ->
    sails.log.debug "Hit the TestController/test"
    sails.log.debug "Param #{ req.param('id') }"
    sails.log.debug "Body #{ JSON.stringify req.body }"

    user_query = Promise.promisify( User.query )
    user_query(
      "select p.id as parent_user_id, g.gcm_token, g.event_notifications
      from event e
      left outer join team_team_members__user_user_teams tm on tm.team_team_members = e.event_team
      left outer join user u on u.id = tm.user_user_teams
      left outer join user p on p.email = u.parent_email
      left outer join gcmreg g on g.user_id = p.id 
      where e.id = #{ 1 } and g.gcm_token is not null
      group by g.gcm_token"
    ).then( ( user_ids_gcm_tokens ) ->
      sails.log.debug "User ids and gcm tokens #{ JSON.stringify user_ids_gcm_tokens }"
      res.json user_ids_gcm_tokens
    ).catch( ( err ) ->
      sails.log.debug "Error #{ JSON.stringify err }"
      res.negotiate err
    )
  
}