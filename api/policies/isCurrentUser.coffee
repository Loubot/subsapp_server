###*
# isCurrentUser
# @description :: Policy to inject check is user with correct id
###


module.exports = (req, res, next) ->
  sails.log.debug "Policies/isCurrentUser"

  if Boolean( req.user.super_admin )
    next()
    sails.log.debug "Super admin"
    return
  if parseInt( req.user.id ) != parseInt( req.param('id') )
    res.negotiate "You are not allowed to view this"
  next()
  
# ---
# generated by js2coffee 2.1.0
  