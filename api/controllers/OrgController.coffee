###*
# UserController
#
# @description :: Server-side logic for managing Business
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###

module.exports = {

  create_business: (req, res) ->
    sails.log.debug "Hit the business controller &&&&&&&&&&&&&&&&&&&&&&&&&&&"
    sails.log.debug "Data #{ JSON.stringify req.body }"
    business_data = req.body
    Org.create( { name: business_data.name, address: business_data.address } ).then( ( org ) ->
      sails.log.debug "Create response #{ JSON.stringify org }" 
      org.admins.add(business_data.user_id)
      org.save (err, s) ->
        sails.log.debug "saved #{ JSON.stringify s }"
        User.find().where( id: business_data.user_id).populateAll().exec (e, r) ->
          sails.log.debug "Populate result #{ JSON.stringify r[0].orgs }"
          res.send r[0].orgs
          return
      #   res.send s
      # sails.log.debug org.admins
      # sails.log.debug "Updated org #{ JSON.stringify org.admins }"
    ).catch( ( err ) ->
      sails.log.debug "Create error response #{ JSON.stringify err }"
    ).done ->
      sails.log.debug "Create done"
      
     
  find_all: (req, res)  ->

    Org.find().where( name: 'my').exec (err, users) ->
      sails.log.debug "err  #{ JSON.stringify err }"
      sails.log.debug "users  #{ JSON.stringify users }"
      return
    # sails.log.debug "Find one method"
    # Business.find().where({id: 1}).then((found) ->
    #   sails.log.debug " result #{ JSON.stringify found }"
      
      
    # )

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