###*
# UserController
#
# @description :: Server-side logic for managing Business
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###

passport = require('passport')
module.exports = {

  get_business: (req, res) ->
    sails.log.debug "Hit the business controller/get_business &&&&&&&&&&&&&&&&&&&&&&&&&&&"
    sails.log.debug "Data #{ JSON.stringify req.query.org_id }"
    Org.findOne( { id: req.query.org_id } ).then( ( org ) ->
      sails.log.debug "Find response #{ JSON.stringify org }" 
      Team.find().where( { main_org: req.query.org_id }).exec (e, teams) ->
        sails.log.debug "Team results #{ JSON.stringify teams[0] }"
        res.send { org: org, teams: teams[0] }
        
      return
      
    ).catch( ( err ) ->
      sails.log.debug "Find error response #{ JSON.stringify err }"
    ).done ->
      sails.log.debug "Find done"
      return
      

      
    


  create_business: (req, res) ->
    sails.log.debug "Hit the business controller/create_business &&&&&&&&&&&&&&&&&&&&&&&&&&&"
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
      
      return
    
     
  destroy_business: (req, res) ->
    sails.log.debug "Hit delete method"
    sails.log.debug "Hit delete method #{ req.body.org_id }"
    Org.destroy( id: req.body.org_id ).then( ( org ) ->
      sails.log.debug "Delete response #{ JSON.stringify org }" 
      
      return
      #   res.send s
      # sails.log.debug org.admins
      # sails.log.debug "Updated org #{ JSON.stringify org.admins }"
    ).catch( ( err ) ->
      sails.log.debug "Create error response #{ JSON.stringify err }"
    ).done ->
      sails.log.debug "Create done"
      
      return
    # Org.destroy(id: req.body.org_id).exec (err, res) ->
    #   sails.log.debug 'The record has been deleted ' + JSON.stringify err
    #   sails.log.debug 'The record has been deleted ' + JSON.stringify res
    #   return

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