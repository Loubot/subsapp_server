###*
# OrgController
#
# @description :: Server-side logic for managing Business
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###

passport = require('passport')
moment = require('moment')
module.exports = {

  findOne: ( req, res ) ->
    Promise = require('bluebird')
    AWS = require('aws-sdk')

    AWS.config.update({accessKeyId: process.env.AWS_ACCESS_KEY_ID, secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY})
    s3 = Promise.promisifyAll(new AWS.S3())

    sails.log.debug "Hit the org controller/findOne "
    sails.log.debug "Params #{ JSON.stringify req.param('id') }"
    sails.log.debug "User #{  parseInt( req.user.orgs[0].id ) ==  parseInt( req.param('id') ) }"

    params = 
      Bucket: 'subzapp'
      Prefix: req.param('id')

    if AuthService.check_club_admin( req.user, req.param('id') )
      Org.findOne( { id: req.param('id') } ).populate('teams').populate('org_members').populate('admins').then( ( org ) ->
        sails.log.debug "Org findOne #{ JSON.stringify org }" 
        return  [
                  org
                  s3.listObjectsAsync( params )
                ]
      ).spread( ( org, s3_object ) ->
        sails.log.debug "Org findOne #{ JSON.stringify org }"
        sails.log.debug "Org findOne s3 #{ JSON.stringify s3_object }"
        res.json org: org, s3_object: s3_object
      )
    else
      res.negotiate "You are not the admin of this org"
    
    

  get_org: (req, res) ->
    sails.log.debug "Hit the org controller/get_org &&&&&&&&&&&&&&&&&&&&&&&&&&&"
    sails.log.debug "Data #{ JSON.stringify req.query }"
    sails.log.debug "QUERY DATE #{ moment( req.query.eligible_date ).toISOString() }"
    sails.log.debug "QUERY END DATE #{ moment( req.query.eligible_date_end ).add( 364, 'days' ).toISOString() }"
    
    if AuthService.check_club_admin( req.user, req.param('id') )
      Org.findOne( { id: req.param('id') } )
      .populate('org_members', dob_stamp: { '>': moment( req.query.eligible_date ).toISOString(), '<': moment( req.query.eligible_date_end ).toISOString()  } )
      .then( ( org ) ->
        sails.log.debug "Find response " 
        res.json org
          
        return
        
      ).catch( ( err ) ->
        sails.log.debug "Find error response #{ JSON.stringify err }"
      ).done ->
        sails.log.debug "Find done"
        return
    else
      res.negotiate "You are not authorised"


  find: ( req, res ) ->
    sails.log.debug "Hit the OrgController/find"
    sails.log.debug "Params #{ JSON.stringify req.query }"
    sails.log.debug "ID #{ JSON.stringify req.param('id') }"
    sails.log.debug "Auth response #{ AuthService.super_admin( req.user ) }"
    if AuthService.super_admin( req.user )
      Org.find().then( ( orgs ) ->
        sails.log.debug "Got all orgs"
        res.json orgs
      ).catch( ( err ) ->
        sails.log.debug "Get all orgs error"
        res.negotiate err
      )
    else
      sails.log.debug "Not allowed"
      res.unauthorized "You are not an admin"
      return false

  update: ( req, res ) ->
    sails.log.debug "Hit the OrgController/update"
    sails.log.debug "Param #{ req.param('id') }"
    sails.log.debug "Data #{ JSON.stringify req.body }"
    if AuthService.check_club_admin( req.user, req.param('id') )
      Org.update( { id: req.param('id') }, req.body ).then( ( updated_org ) ->
        sails.log.debug "Org updated #{ JSON.stringify updated_org }"
        res.json updated_org
      ).catch( ( updated_org_err ) ->
        sails.log.debug "Updated org error #{ JSON.stringify updated_org_err }"
        res.negotiate updated_org_err
      )
      
    else
      res.unauthorized 'You are not authorised to update this'

  get_org_admins: (req, res) ->
    sails.log.debug "Hit the Org controller/get_org_admins"
    sails.log.debug req.query
    Org.findOne( id: req.query.org_id ).populate('admins').populate('teams').then( ( org ) ->
      sails.log.debug "get org admins #{ JSON.stringify org }"
      res.json org #return only admins
    ).catch( ( err ) ->
      sails.log.debug "Get org admins error"
      sails.log.debug "#{ JSON.stringify err }"
      res.negotiate err
    )


  create_business: (req, res) ->
    sails.log.debug "Hit the business controller/create_business &&&&&&&&&&&&&&&&&&&&&&&&&&&"
    sails.log.debug "Data #{ JSON.stringify req.body }"
    sails.log.debug "Data #{ JSON.stringify req.user }"
    if req.user.club_admin != true
      res.negotiate "You are not an admin"
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
      sails.log.debug "Create error response #{ err }"
      res.negotiate err
    )
    
     
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

  s3_info: ( req, res ) ->
    sails.log.debug "Hit the OrgController/s3_info"
    sails.log.debug "Params #{ req.param('id') }"
    sails.log.debug "Auth response #{ AuthService.super_admin( req.user ) }"
    if AuthService.super_admin( req.user )
      Promise = require('bluebird')
      AWS = require('aws-sdk')

      AWS.config.update({accessKeyId: process.env.AWS_ACCESS_KEY_ID, secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY})
      # s3 = Promise.promisifyAll(new AWS.S3())
      s3 = new AWS.S3()
      params = 
        Bucket: 'subzapp'
        Prefix: "#{req.param('id')}/"

      s3.listObjects( params, ( err, data ) ->
        if err?
          sails.log.debug "S3 error #{ JSON.stringify err }"
        else
          sails.log.debug "S3 data #{ JSON.stringify data }"
          res.json data
      )


    else
      sails.log.debug "Not authorised"
      res.unauthorized "You are not allowed to view this"



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
