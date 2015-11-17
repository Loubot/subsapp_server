###*
# UserController
#
# @description :: Server-side logic for managing Users
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###

module.exports = {
  up_tokens: (req, res) ->
    User.findOne(id: req.user.id).then((found) ->
      sails.log.debug " result #{ JSON.stringify found }"
      new_tokens = ++found.tokens
      sails.log.debug "new_tokens #{ new_tokens }"
      User.update(req.user.id, { tokens: new_tokens }).then (result) ->
        sails.log.debug " user id #{ req.user.id }"
        sails.log.debug "update result #{ JSON.stringify result }"

        res.send result
      # sails.log.debug "found.tokens #{ found.tokens }"
      # sails.log.debug "before #{found.tokens}"
      # new_tokens = ++found.tokens
      # return new_tokens
      # sails.log.debug "after #{ new_tokens }"
      ).fail (error) ->
        console.log 'bla'
        

      # tokens = res.tokens
      # console.log "tokens #{ tokens }"
      # tokens++
      # console.log "tokens #{ tokens }"

      # User.update req.user.id, { tokens: new_tokens }, (err, updated) ->
      #   sails.log.debug "update #{ JSON.stringify updated }"
        

    
    
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