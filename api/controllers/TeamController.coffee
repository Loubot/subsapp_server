###*
# TeamController
#
# @description :: Server-side logic for managing Teams
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###
moment = require('moment')
passport = require('passport')
module.exports = {

  findOne: ( req, res ) ->
    sails.log.debug "hit the TeamController/findOne"
    sails.log.debug "Params #{ req.param('id') }"
    ## req.team defined in isTeamAdmin policy 
    res.json req.team 

  update: ( req, res ) ->
    sails.log.debug "Hit the TeamController/update"
    sails.log.debug "Param #{ req.param('id') }"
    sails.log.debug "Params #{ JSON.stringify req.body }"
    Team.update( 
      { id: req.param('id') }
      eligible_date: req.body.eligible_date
      eligible_date_end: req.body.eligible_date_end
      ).then( ( team ) -> 
      sails.log.debug "Team updated #{ JSON.stringify team }"
      res.json team
    ).catch( ( err ) ->
      sails.log.debug "Team update error #{ JSON.stringify err }"
      res.negotiate err
    )

  get_team_info: (req, res) -> #club admin team findOne
    Promise = require('bluebird')
    sails.log.debug "Hit the TeamController/get_team_info"
    sails.log.debug "Hit the TeamController/get_team_info #{ JSON.stringify req.query }"
    


    AWS = require('aws-sdk')

    AWS.config.update({accessKeyId: process.env.AWS_ACCESS_KEY_ID, secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY})

    s3 = Promise.promisifyAll(new AWS.S3())
    
    Team.findOne( id: req.param('id') ).populateAll().then( (team) ->
      sails.log.debug "Team #{ JSON.stringify team }"
      sails.log.debug "Prefix: #{ team.main_org.id }/#{ team.id }/"
      params =
        Bucket: 'subzapp'
        Delimiter: '/'
        Prefix: "#{ team.main_org.id }/#{ team.id }/"
      return [ 
                team
                s3.listObjectsAsync( params )
                Org.findOne( id: team.main_org.id ).populate('org_locations')
              ]
        

    ).spread ( ( team, s3_object, org ) ->
      sails.log.debug "Team #{ JSON.stringify team }"
      sails.log.debug "S3 #{ s3_object }"
      sails.log.debug "org #{ JSON.stringify org }"

      res.json team: team, bucket_info: s3_object, org: org

    )
    



   

  create: (req, res) ->
    sails.log.debug "Hit the TeamController/create_team ***************"
    sails.log.debug "Data #{ JSON.stringify req.body }"
    
    Team.create( name: req.body.name, main_org: req.body.org_id, manager: req.body.user_id ).then( ( team ) ->
      sails.log.debug "Team created #{ JSON.stringify team }"
      
      Org.findOne( id: req.body.org_id ).populate('teams').exec( ( err, org ) ->
        sails.log.debug "Org find error #{ JSON.stringify err }" if err?
        sails.log.debug "Org find  #{ JSON.stringify org }" 
        res.json org: org, message: 'Team created ok'
      )

    ).catch( ( err ) ->
      sails.log.debug "Team create error #{ JSON.stringify err }"
      res.negotiate err
    )

      

  destroy: (req, res) ->
    sails.log.debug "Hit the TeamController/destroy_team"
    sails.log.debug "Data #{ JSON.stringify req.body }"
    
    Team.destroy( id: req.body.team_id).then( (team) ->
      sails.log.debug "Team destroy response #{ JSON.stringify team }"

    ).then(
      Org.findOne( id: req.body.org_id ).populate('teams').exec ( err, org ) ->
        sails.log.debug "Failed to find org #{ JSON.stringify err }" if err?
        sails.log.debug "Org found #{ JSON.stringify org }"
        res.json org
    ).catch( (err) ->
      sails.log.debug "Team destroy error #{ JSON.stringify err }"
      res.negotiate err
    ).done ->
      sails.log.debug "Team destroy done"

#/////////////////////////////// Joining team logic

  join_team: (req, res) ->
    sails.log.debug "Hit the TeamController/join_team"
    Team.findOne( { id: req.body.team_id } ).then( ( team ) ->
      sails.log.debug "Find user response #{ JSON.stringify team }" 
      team.team_members.add(req.body.user_id)
      team.save (err, s) ->
        sails.log.debug "Add team to team #{ JSON.stringify s }"
        sails.log.debug "Add team to team err #{ JSON.stringify err }"
        res.json s

    ).catch( (err) ->
      sails.log.debug "Join team find user error #{ JSON.stringify err }"
      res.negotiate err
    ).done ->
      sails.log.debug "Join team find user done"


  get_players_by_year: ( req, res ) ->
    sails.log.debug "Hit the user controller/find_by_date"
    date = moment().toISOString()
    sails.log.debug "Current time #{ JSON.stringify date }"
    Org.findOne( id: req.param('id') ).populate('org_members', { where: dob_stamp: '<': date } ).then( ( members ) ->
      sails.log.debug "Get players by year #{ JSON.stringify members }"
      res.json members
    ).catch( ( err ) ->
      sails.log.debug "Get playsers by year error #{ JSON.stringify err }"
      res.negotiate err
    )

  update_members: ( req, res ) ->
    
    sails.log.debug "Hit the TeamController/update_members"
    sails.log.debug "Params #{ JSON.stringify req.body }"
    sails.log.debug "Param #{ req.param('id') }"

    Team.update( { id: req.param('id') }, 'team_members': req.body.team_members ).then( ( updated ) ->
      sails.log.debug "Team members update #{ JSON.stringify updated }"
      Team.findOne( id: req.param('id') ).populate('team_members').then( ( updated_team_found ) ->
        sails.log.debug "Updated team found #{ JSON.stringify updated_team_found }"
        res.json updated_team_found
      ).catch( ( updated_team_found_err ) ->
        sails.log.debug "Upated team found error #{ JSON.stringify updated_team_found_err }"
        res.negotiate updated_team_found_err
      )
    ).catch( ( err ) ->
      sails.log.debug "Team update members error #{ JSON.stringify err }"
      res.negotiate err
    )   

  org_members: ( req, res ) ->
    sails.log.debug "Hit the TeamController.coffee/org_members"
    sails.log.debug "Params #{ JSON.stringify req.body }"
    sails.log.debug "Id #{ req.param('id') }"

    
    Org.findOne( { id: req.team.main_org.id } )
    .populate('org_members', dob_stamp: { '>': moment( req.query.eligible_date ).toISOString(), '<': moment( req.query.eligible_date_end ).toISOString()  } 
      
    ).then( ( org ) ->
      sails.log.debug "Org found #{ JSON.stringify org }"
      res.json org.org_members
    ).catch( ( org_and_team_err ) ->
      sails.log.debug "Org and team error #{ JSON.stringify org org_and_team_err }"
    )

  teams_events: ( req, res ) ->
    sails.log.debug "Hit the EventController/teams_events"
    sails.log.debug "Params #{ req.param('id') }"
    sails.log.debug "Body #{ JSON.stringify req.body }"

    Event.find( event_team: req.param('id'), where: { start_date: { '>': new Date() } } )
    .populate('location_id').then( ( team) ->
      sails.log.debug "Found team #{ JSON.stringify team }"
      res.json team
    ).catch( ( err ) ->
      sails.log.debug "Team find error #{ JSON.stringify err }"
      res.negotiate err
    )
    
  
}