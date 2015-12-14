###*
# TeamController
#
# @description :: Server-side logic for managing Teams
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###

passport = require('passport')
module.exports = {
  create_team: (req, res) ->
    sails.log.debug "Hit the team controller/create_team ***************"
    sails.log.debug "Data #{ JSON.stringify req.body }"
    params = req.body
    Team.create( { name: params.name, main_org: params.org_id, manager: params.user_id }).then( ( team ) ->
      sails.log.debug "Team create #{ JSON.stringify team }"
    ).catch( (err) ->
      sails.log.debug "Team create error #{ JSON.stringify err }"
    ).done ->
      sails.log.debug "Team create done"

      Team.find().where( main_org: params.org_id).populateAll().exec (e, teams) ->
        sails.log.debug "Populate result #{ JSON.stringify teams }"
        sails.log.debug "Populate error #{ JSON.stringify e }"

        res.send teams

  destroy_team: (req, res) ->
    sails.log.debug "Hit the team controller/destroy_team"
    sails.log.debug "Data #{ JSON.stringify req.body }"
    
    Team.destroy( id: req.body.team_id).then( (team) ->
      sails.log.debug "Team destroy response #{ JSON.stringify team }"
    ).catch( (err) ->
      sails.log.debug "Team destroy error #{ JSON.stringify err }"
    ).done ->
      sails.log.debug "Team destroy done"

  join_team: (req, res) ->
    sails.log.debug "Hit the team controller/join_team"
    Team.findOne( { id: req.body.team_id } ).then( ( team ) ->
      sails.log.debug "Find user response #{ JSON.stringify team }" 
      team.team_members.add(req.body.user_id)
      team.save (err, s) ->
        sails.log.debug "Add team to team #{ JSON.stringify s }"
        sails.log.debug "Add team to team err #{ JSON.stringify err }"
        res.send s

    ).catch( (err) ->
      sails.log.debug "Join team find user error #{ JSON.stringify err }"
    ).done ->
      sails.log.debug "Join team find user done"



  get_team: (req, res) ->
    sails.log.debug "Hit the team controller/get_team"
    Team.findOne( { id: req.query.team_id } ).populate('events').populate('main_org').then( (team) ->
      sails.log.debug "Get team response #{ JSON.stringify team }"
      res.send team
    ).catch( (err) ->
      sails.log.debug "Get team error #{ JSON.stringify err }"
    ).done ->
      sails.log.debug "Team get team main org done"


  get_team_info: (req, res) ->
    sails.log.debug "Hit the team controller/get_team_members"
    sails.log.debug "Hit the team controller/get_team_members #{ req.query.team_id }"

    Team.findOne( id: req.query.team_id ).populate('team_members').populate('events').then( (mems) ->
      sails.log.debug "Get team response #{ JSON.stringify mems }"
      res.send mems
    ).catch( (err) ->
      sails.log.debug "Get team error #{ JSON.stringify err }"
    ).done ->
      sails.log.debug "Team get team main org done"
}