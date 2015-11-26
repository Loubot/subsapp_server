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
      sails.log.debug " session #{ JSON.stringify req.session }"
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
