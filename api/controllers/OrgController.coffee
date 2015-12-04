###*
# UserController
#
# @description :: Server-side logic for managing Business
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###

passport = require('passport')
module.exports = {

  get_org: (req, res) ->
    sails.log.debug "Hit the business controller/get_org &&&&&&&&&&&&&&&&&&&&&&&&&&&"
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
    sails.log.debug "Hit the business controller/destroy_business &&&&&&&&&&&&&&&&&&&&&&&&&&&"
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
  
  all_org: (req, res) ->
    sails.log.debug "Hit the org controller/all_business &&&&&&&&&&&&&&&&&&&&&&&&&&&"
    Org.find().then( (orgs) ->
      sails.log.debug "All org response #{ JSON.stringify orgs }"
      res.send orgs
    ).catch(( err ) ->
      sails.log.debug "All org error #{ JSON.stringify err }"
      
    ).done ->
      sails.log.debug "All org done"


  ######################################################################
          ## Mobile app ##
  get_org_list: (req, res) ->
    sails.log.debug "Hit the org controller/get_org_list"
    Org.find().then( (orgs) ->
      sails.log.debug "Org get_org_list #{ JSON.stringify orgs }"
      res.send orgs
    ).catch((err) ->
      sails.log.debug "Org find get org list error #{ JSON.stringify err }"
    ).done ->
      sails.log.debug "Org find done"

  get_single_org: (req, res) ->
    sails.log.debug "Hit the org controller/get_single_org #{ JSON.stringify req.query }"
    Org.findOne().where( { id: req.query.org_id } ).then( (org) -> 
      sails.log.debug "Get single org #{ JSON.stringify org }"
      res.send org
    ).catch( (err) ->
      sails.log.debug "Get single org error #{ JSON.stringify err }"
    ).done ->
      sails.log.debug "Get single org done"
}
