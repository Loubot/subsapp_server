###*
# isTeamAdmin
# @description :: Policy to check is user is teamAdmin
###


module.exports = (req, res, next) ->
  sails.log.debug "Policies/isTeamAdmin"
  sails.log.debug "Body #{ JSON.stringify req.body }"
  sails.log.debug "Params #{ req.param('id') }"

  if !Boolean( req.user.team_admin )
    sails.log.debug "No team admin flag"
    return res.negotiate "You are not authourised"
  else if ( req.param('id') == 'undefined' )
    sails.log.debug "isTeamAdmin no id param"
    return res.negotiate "ID param not present"


  Team.findOne( id: req.param('id') ).populateAll().then( ( team ) ->
    sails.log.debug "Find team #{ JSON.stringify team }"
    if Boolean( req.user.super_admin )
      req.team = team
      return next()
      
    if Boolean( req.user.club_admin ) and team.main_org.user_id == req.user.id
      req.team = team 
      return next()
    
    if !team.manager? or team.manager.id != req.user.id 
      return res.negotiate "Your are not authourised"
    req.team = team
    next()
  ).catch( ( team_err ) ->
    sails.log.debug "team err #{ team_err }"
    return res.negotiate team_err
  )

  