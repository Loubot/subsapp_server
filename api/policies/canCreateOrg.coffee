###*
# canCreateOrg
# @description :: Policy to check if user is admin to creat org
###


module.exports = (req, res, next) ->
  sails.log.debug "Policies/check_club_admin"
  sails.log.debug "Body #{ JSON.stringify req.body }"
  if !Boolean( req.user.club_admin )
    sails.log.debug "No club admin flag"
    return res.negotiate "You are not authourised"


  next()
  
# ---
# generated by js2coffee 2.1.0
  