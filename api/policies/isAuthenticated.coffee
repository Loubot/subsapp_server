###*
# isAuthenticated
# @description :: Policy to inject user in req via JSON Web Token
###

passport = require('passport')

module.exports = (req, res, next) ->
  passport.authenticate('jwt', (error, user, info) ->
    if error
      return res.serverError(error)
    if !user
      return res.unauthorized(null, info and info.code, info and info.message)
    req.user = user
    next()
    return
  ) req, res
  return

# ---
# generated by js2coffee 2.1.0