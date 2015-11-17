###*
# UserController
#
# @description :: Server-side logic for managing Users
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###

module.exports = {
  up_tokens: (req, res) ->
    User.findOne req.user.id, (err, res) ->
      sails.log.debug "res.tokens #{ res.tokens }"
      sails.log.debug "before #{res.tokens}"
      new_tokens = ++res.tokens
      sails.log.debug "after #{ new_tokens }"

      # tokens = res.tokens
      # console.log "tokens #{ tokens }"
      # tokens++
      # console.log "tokens #{ tokens }"

      User.update req.user.id, { tokens: new_tokens }, (err, res) ->
        sails.log.debug "update #{ JSON.stringify res }"

        try 
          console.log "res attempt #{ res }"
        catch error
          console.log error

    
    
}




# try
#   User.update(1, { tokens: 2 }).exec (err, updated) ->
#   console.log 'Updated user to have name ' + JSON.stringify updated
#   if err
#     res.send err
#     # handle error here- e.g. `res.serverError(err);`
#     return
  
#   return
#   res.send 'Hi there!' + JSON.stringify updated
# catch err
#   console.log JSON.stringify err