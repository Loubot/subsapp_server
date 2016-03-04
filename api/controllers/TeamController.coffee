###*
# TeamController
#
# @description :: Server-side logic for managing Teams
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###

passport = require('passport')
module.exports = {

  findOne: ( req, res ) ->
    sails.log.debug "hit the team controller/findOne"
    sails.log.debug "Params #{ req.param('id') }"
    Team.findOne( { id: req.param('id') } ).populateAll().then( ( team ) ->
      console.log "Team findOne #{ JSON.stringify team }"
      res.json team
    ).catch( ( err ) ->
      sails.log.debug "Team find one err #{ JSON.stringify err }"
      res.serverError err
    )

  get_team_info: (req, res) -> #club admin team findOne
    Promise = require('bluebird')
    sails.log.debug "Hit the team controller/get_team_info"
    sails.log.debug "Hit the team controller/get_team_info #{ JSON.stringify req.query }"
    if AuthService.check_club_admin( req.user, req.param('id') )


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
                  Org.findOne( id: req.param('id') ).populateAll() 
                ]
          

      ).spread ( ( team, s3_object, org ) ->
        sails.log.debug "Team #{ JSON.stringify team }"
        sails.log.debug "S3 #{ s3_object }"
        sails.log.debug "org #{ JSON.stringify org }"

        res.json team: team, bucket_info: s3_object, org: org

      )



   

  create_team: (req, res) ->
    sails.log.debug "Hit the team controller/create_team ***************"
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
      res.serverError err
    )

      

  destroy_team: (req, res) ->
    sails.log.debug "Hit the team controller/destroy_team"
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
      res.serverError err
    ).done ->
      sails.log.debug "Team destroy done"

#/////////////////////////////// Joining team logic

  join_team: (req, res) ->
    sails.log.debug "Hit the team controller/join_team"
    Team.findOne( { id: req.body.team_id } ).then( ( team ) ->
      sails.log.debug "Find user response #{ JSON.stringify team }" 
      team.team_members.add(req.body.user_id)
      team.save (err, s) ->
        sails.log.debug "Add team to team #{ JSON.stringify s }"
        sails.log.debug "Add team to team err #{ JSON.stringify err }"
        res.json s

    ).catch( (err) ->
      sails.log.debug "Join team find user error #{ JSON.stringify err }"
      res.serverError err
    ).done ->
      sails.log.debug "Join team find user done"

  update_members: ( req, res ) ->
    sails.log.debug "Hit the TeamController/update_members"
    sails.log.debug "Params #{ JSON.stringify req.body }"

    Team.findOne( req.param('id') ).populate('team_members').then( ( team ) ->
      sails.log.debug "Update members team find #{ JSON.stringify team }"
      res.json team
    ).catch ( err ) ->
      sails.log.debug "Update members team find err #{ JSON.stringify err }"
      res.serverError err


#//////////////////// end of joining team logic



  get_team: (req, res) ->
    sails.log.debug "Hit the team controller/get_team"
    Team.findOne( { id: req.query.team_id } ).populate('events').populate('main_org').populate('manager').then( (team) ->
      sails.log.debug "Get team response #{ JSON.stringify team }"
      res.json team
    ).catch( (err) ->
      sails.log.debug "Get team error #{ JSON.stringify err }"
      res.serverError err
    ).done ->
      sails.log.debug "Team get team main org done"

  get_teams: ( req, res ) -> #return all teams from an org
    sails.log.debug "Hit the team conroller/get_teams"
    Org.findOne( id: req.query.org_id ).populate('teams').then( ( org_and_teams ) ->
      sails.log.debug "Org and teams #{ JSON.stringify org_and_teams }"
      res.json org_and_teams
    ).catch( ( err ) ->
      sails.log.debug "Get org and teams error"
      res.serverError err
    )


  
  
}