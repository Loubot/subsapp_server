###*
# UserController
#
# @description :: Server-side logic for managing Business
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###

passport = require('passport')
module.exports = {

  create_business: (req, res) ->
    sails.log.debug "Hit the business controller &&&&&&&&&&&&&&&&&&&&&&&&&&&"
    sails.log.debug "Data #{ JSON.stringify req.body }"
    business_data = req.body

    Org.create( name: business_data.name, address: business_data.address, admin: business_data.user_id ).then( (org) ->
     
      sails.log.debug "Org create THEN #{ JSON.stringify org }"
      # org.users.add(business_data.user_id)
      # org.save ( err, s ) ->
      #   sails.log.debug "save err #{ JSON.stringify err }"
      #   sails.log.debug "save #{ JSON.stringify s }"
      #   return
    ).catch( (err) ->
      sails.log.debug "Org create catch #{ JSON.stringify err }"
    ).done( (e) ->
      sails.log.debug "Org create done #{ JSON.stringify e }"
      
      User.findOne(id: business_data.user_id).populate('orgs').exec (err, users_orgs) ->
        sails.log.debug "user find populate #{ JSON.stringify users_orgs }"
        sails.log.debug "user find populate error #{ JSON.stringify err }"
        res.send users_orgs.orgs

    )
     
  destroy_business: (req, res) ->
    Org.destroy(id: req.body.org_id).exec (err) ->
      sails.log.debug 'The record has been deleted ' + JSON.stringify err
      return

}




# up_tokens: (req, res) ->
#     User.findOne(id: req.user.id).then((found) ->
#       sails.log.debug " result #{ JSON.stringify found }"
#       new_tokens = ++found.tokens
#       sails.log.debug "new_tokens #{ new_tokens }"
#       User.update(req.user.id, { tokens: new_tokens }).then (result) ->
#         sails.log.debug " user id #{ req.user.id }"
#         sails.log.debug "update result #{ JSON.stringify result }"

#         res.send result
#       # sails.log.debug "found.tokens #{ found.tokens }"
#       # sails.log.debug "before #{found.tokens}"
#       # new_tokens = ++found.tokens
#       # return new_tokens
#       # sails.log.debug "after #{ new_tokens }"
#       ).fail (error) ->
#         console.log 'bla'
        

#       # tokens = res.tokens
#       # console.log "tokens #{ tokens }"
#       # tokens++
#       # console.log "tokens #{ tokens }"

#       # User.update req.user.id, { tokens: new_tokens }, (err, updated) ->
#       #   sails.log.debug "update #{ JSON.stringify updated }"