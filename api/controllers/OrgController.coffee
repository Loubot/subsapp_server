###*
# OrgController
#
# @description :: Server-side logic for managing Business
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###

passport = require('passport')
module.exports = {

  findOne: ( req, res ) ->
    sails.log.debug "Hit the org controller/findOne "
    sails.log.debug "Params #{ JSON.stringify req.param('id') }"
    sails.log.debug "User #{  parseInt( req.user.orgs[0].id ) ==  parseInt( req.param('id') ) }"

    if AuthService.check_club_admin( req.user, req.param('id') )
      Org.findOne( { id: req.param('id') } ).populateAll().then( ( org ) ->
        sails.log.debug "Org findOne #{ JSON.stringify org }" 
        res.json org
      ).catch( ( err ) ->
        sails.log.debug "Org findOne err #{ err }"
        res.serverError err
      )
    else
      res.serverError "You are not the admin of this org"
    
    

  get_org: (req, res) ->
    sails.log.debug "Hit the business controller/get_org &&&&&&&&&&&&&&&&&&&&&&&&&&&"
    sails.log.debug "Data #{ JSON.stringify req.query.org_id }"
    Org.findOne( { id: req.query.org_id } ).then( ( org ) ->
      sails.log.debug "Find response #{ JSON.stringify org }" 
      Team.find().where( { main_org: req.query.org_id }).exec (e, teams) ->
        sails.log.debug "Team results #{ JSON.stringify teams[0] }"
        res.json { org: org, teams: teams[0] }
        
      return
      
    ).catch( ( err ) ->
      sails.log.debug "Find error response #{ JSON.stringify err }"
    ).done ->
      sails.log.debug "Find done"
      return

  get_org_admins: (req, res) ->
    sails.log.debug "Hit the Org controller/get_org_admins"
    sails.log.debug req.query
    Org.findOne( id: req.query.org_id ).populate('admins').populate('teams').then( ( org ) ->
      sails.log.debug "get org admins #{ JSON.stringify org }"
      res.json org #return only admins
    ).catch( ( err ) ->
      sails.log.debug "Get org admins error"
      sails.log.debug "#{ JSON.stringify err }"
      res.serverError err
    )


  create_business: (req, res) ->
    sails.log.debug "Hit the business controller/create_business &&&&&&&&&&&&&&&&&&&&&&&&&&&"
    sails.log.debug "Data #{ JSON.stringify req.body }"
    sails.log.debug "Data #{ JSON.stringify req.user }"
    if req.user.club_admin != true
      res.serverError "You are not an admin"
      return false
    business_data = req.body
    Org.create( { name: business_data.name, address: business_data.address } ).then( ( org ) ->
      sails.log.debug "Create response #{ JSON.stringify org }" 
      org.admins.add(business_data.user_id)
      org.save (err, s) ->
        sails.log.debug "saved #{ JSON.stringify s }"
        User.find().where( id: business_data.user_id).populateAll().exec (e, r) ->
          sails.log.debug "Populate result #{ JSON.stringify r[0].orgs }"
          res.json r[0].orgs
      return
      #   res.json s
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
      #   res.json s
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
      res.json orgs
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
      res.json orgs
    ).catch((err) ->
      sails.log.debug "Org find get org list error #{ JSON.stringify err }"
    ).done ->
      sails.log.debug "Org find done"

  get_single_org: (req, res) ->
    sails.log.debug "Hit the org controller/get_single_org #{ JSON.stringify req.query }"
    Org.findOne().where( { id: req.query.org_id } ).populate('teams').then( (org) -> 
      sails.log.debug "Get single org #{ JSON.stringify org }"
      res.json org
    ).catch( (err) ->
      sails.log.debug "Get single org error #{ JSON.stringify err }"
    ).done ->
      sails.log.debug "Get single org done"
}
