###*
# TokenController
#
# @description :: Server-side logic for managing Tokens
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###
sails.log.silly()

passport = require('passport')
module.exports = {
  
  up_token: (req, res) ->
    sails.log.debug "params #{ JSON.stringify req.body }"
    
    Token.findOne( owner: 1 ).then( ( token ) ->
      sails.log.debug "Find token response #{ JSON.stringify token }" 
      
      

    ).catch( (err) ->
      sails.log.debug "Join team find user error #{ JSON.stringify err }"
    ).done ->
      sails.log.debug "Join team find user done"


  
}