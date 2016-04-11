###*
## AuthController
# @description :: Server-side logic for manage user's authorization
###

passport = require('passport')

###*
# Triggers when user authenticates via passport
# @param {Object} req Request object
# @param {Object} res Response object
# @param {Object} error Error object
# @param {Object} user User profile
# @param {Object} info Info if some error occurs
# @private
###
sails.log.silly()
_onPassportAuth = (req, res, error, user, info) ->
  if error
    return res.serverError(error)
  if !user
    return res.unauthorized(null, info and info.code, info and info.message)
  res.ok
    token: CipherService.createToken(user)
    user: user

module.exports =
  signup: (req, res) ->
    sails.log.debug "Hit the authcontroller/signup"
    sails.log.debug "Params #{ JSON.stringify req.body }"
    User.create(_.omit(req.allParams(), 'id')).then((user) ->
      Token.create( owner: user.id ).exec (err, token) ->
        sails.log.debug "Token created #{ JSON.stringify token }"
        sails.log.debug "Token create error #{ JSON.stringify err }" if err?
        User.findOne( id: user.id ).populateAll().then ( ( user_pop ) ->
          sails.log.debug "User pop #{ JSON.stringify user_pop }"
          res.json
            data:
              token: CipherService.createToken(user_pop)
              user: user_pop
          
        )
      
    ).catch( ( user_create_err ) -> 
      sails.log.debug "User create error #{ JSON.stringify user_create_err.invalidAttributes.email.message }"
      res.serverError user_create_err.invalidAttributes.email.message
    )
    return
  team_manager_signup: (req, res) ->
    sails.log.debug "Hit the authcontroller/team_manager_signup"
    sails.log.debug "Body #{ JSON.stringify req.body }"
    User.create(_.omit(req.allParams(), 'id')).then((user) ->
      Token.create( owner: user.id).then( (err, token) ->
        sails.log.debug "Token created #{ JSON.stringify token }"
        sails.log.debug "Token create error #{ JSON.stringify err }" if err?
      
      ).then(
        Team.findOne( id: req.body.team_id ).exec (err, team) ->
          sails.log.debug "team #{ JSON.stringify team}"
          sails.log.debug "err #{ JSON.stringify team}" if err?
          team.manager = user.id
          team.save()
          User.findOne( id: user.id ).populateAll().then ( ( user_pop ) ->
            sails.log.debug "User pop #{ JSON.stringify user_pop }"
            res.json
              data:
                token: CipherService.createToken(user_pop)
                user: user_pop
            
          )
      )
      
    ).then(res.created).catch res.serverError
    return

    
  signin: (req, res) ->
    sails.log.debug "Hit the authcontroller/signin"
    sails.log.debug "Params #{ JSON.stringify req.body }"
    passport.authenticate('local', _onPassportAuth.bind(this, req, res)) req, res
    return

# ---
# generated by js2coffee 2.1.0
