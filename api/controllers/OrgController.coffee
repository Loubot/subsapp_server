###*
# OrgController
#
# @description :: Server-side logic for managing Business
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###

passport = require('passport')
moment = require('moment')
Promise = require('bluebird')
module.exports = {



  findOne: ( req, res ) ->
    Promise = require('bluebird')
    AWS = require('aws-sdk')

    sails.log.debug "aws #{  process.env.AWS_SECRET_ACCESS_KEY }"

    AWS.config.update({ accessKeyId: process.env.AWS_ACCESS_KEY_ID, secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY })
    s3 = Promise.promisifyAll(new AWS.S3())

    sails.log.debug "Hit the org controller/findOne "
    sails.log.debug "Params #{ JSON.stringify req.param('id') }"
    # sails.log.debug "User #{  parseInt( req.user.orgs[0].id ) ==  parseInt( req.param('id') ) }"

    params = 
      Bucket: 'subzappbucket'
      Prefix: req.param('id')

   
    Org.findOne( id: req.param('id') )
    .populate('teams')
    .populate('org_members')
    .populate('admins')
    .populate('org_locations').then( ( org ) ->
      sails.log.debug "Org findOne " 
      return  [
                org
                s3.listObjectsAsync( params )
              ]
    ).spread( ( org, s3_object ) ->
      sails.log.debug "Org findOne spread"
      sails.log.debug "Org findOne s3 #{ JSON.stringify s3_object }"
      res.json org: org, s3_object: s3_object
    ).catch( ( org_find_s3_err ) ->
      sails.log.debug "Org org_find_s3_err #{ JSON.stringify org_find_s3_err }"
      res.negotiate org_find_s3_err
    )
    
  create: (req, res) ->
    sails.log.debug "Hit the business controller/create_business &&&&&&&&&&&&&&&&&&&&&&&&&&&"
    sails.log.debug "Data #{ JSON.stringify req.body }"
    sails.log.debug "Data #{ JSON.stringify req.user }"
    
    org_data = req.body
    Org.create( org_data ).then( ( org ) ->
      sails.log.debug "Create response #{ JSON.stringify org }" 
      org.admins.add( org_data.user_id )

      return [
        org.save()
        
        Org.findOne( id: org.id ).populate('org_locations')
        Location.create( 
          address: org_data.address
          location_owner: org.name
          location_name: "Main address of #{ org.name }"
        )
      ]        
    ).spread( ( org_saved, org_found, location ) ->
      sails.log.debug "Org saved #{ JSON.stringify org_saved }"
      sails.log.debug "Org found #{ JSON.stringify org_found }"
      sails.log.debug "Location created #{ JSON.stringify location }"
      location.org_id.add( org_saved.id )
      location.save( ( location_save_err, location_saved ) ->
        if location_save_err?
          sails.log.debug "Location saved error #{ JSON.stringify location_save_err }"
          res.negotiate location_save_err
        else
          sails.log.debug "Location saved #{ JSON.stringify location_saved }"
          User.findOne( id: org_data.user_id ).populateAll().exec ( user_find_err, user ) ->
            if user_find_err
              sails.log.debug "User not found #{ JSON.strinify user_find_err }"
              res.json
                org: org_found
                location: location_saved
            else
              res.json 
                org: org_found
                user: user
                location: location_saved
      )
      

      
      #   res.json s
      # sails.log.debug org.admins
      # sails.log.debug "Updated org #{ JSON.stringify org.admins }"
    ).catch( ( err ) ->
      sails.log.debug "Create error response #{ err }"
      res.negotiate err
    )
    
    
  update: ( req, res ) ->
    sails.log.debug "Hit the OrgController/update"
    sails.log.debug "Param #{ req.param('id') }"
    sails.log.debug "Data #{ JSON.stringify req.body }"
    if ParamService.check_if_coors( req.body ) #if coords exist update or create location
      sails.log.debug "Org id attempt ****** #{ JSON.stringify req.org }"
      
      Org.findOne( id: req.param('id') ).populate('org_locations').then( ( org ) ->
        sails.log.debug "Found org #{ JSON.stringify org }"
        
        
        
        
      ).catch( ( find_org_err ) ->
        sails.log.debug "find_org_err #{ find_org_err }"
        res.negotiate find_org_err
      )
      
    else
      Org.update( { id: req.param('id') }, body ).then( ( updated_org ) ->
        sails.log.debug "Org updated #{ JSON.stringify updated_org }"
        res.json updated_org
      ).catch( ( updated_org_err ) ->
        sails.log.debug "Updated org error #{ JSON.stringify updated_org_err }"
        res.negotiate updated_org_err
      )


  get_org_team_members: (req, res) ->
    sails.log.debug "Hit the org controller/get_org "
    sails.log.debug "Data #{ JSON.stringify req.query }"
    sails.log.debug "QUERY DATE #{ moment( req.query.eligible_date ).toISOString() }"
    sails.log.debug "QUERY END DATE #{ moment( req.query.eligible_date_end ).add( 364, 'days' ).toISOString() }"

    
    Promise.all([
      Org.findOne( { id: req.param('id') } ).populate('org_members', dob_stamp: { '>': moment( req.query.eligible_date ).toISOString(), '<': moment( req.query.eligible_date_end ).toISOString()  } )
      Team.findOne( id: req.query.id ).populate('team_members')
    ]).spread( ( org, team ) ->
      sails.log.debug "Org found #{ JSON.stringify org }"
      sails.log.debug "Team found "
      res.json org: org, team: team
    ).catch( ( org_and_team_err ) ->
      sails.log.debug "Org and team error #{ JSON.stringify org org_and_team_err }"
    )
    
    


  find: ( req, res ) -> #'isAuthenticated', 'isSuperAdmin'
    sails.log.debug "Hit the OrgController/find"
    sails.log.debug "Params #{ JSON.stringify req.query }"
    sails.log.debug "ID #{ JSON.stringify req.param('id') }"
    
    Org.find().then( ( orgs ) ->
      sails.log.debug "Got all orgs"
      res.json orgs
    ).catch( ( err ) ->
      sails.log.debug "Get all orgs error"
      res.negotiate err
    )
    

  
  get_org_admins: (req, res) ->
    sails.log.debug "Hit the Org controller/get_org_admins"
    sails.log.debug req.query
    Org.findOne( id: req.param('id') ).populate('admins').populate('teams').then( ( org ) ->
      sails.log.debug "get org admins #{ JSON.stringify org }"
      res.json org #return only admins
    ).catch( ( err ) ->
      sails.log.debug "Get org admins error"
      sails.log.debug "#{ JSON.stringify err }"
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
