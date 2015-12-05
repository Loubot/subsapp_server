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
    User.findOne( { id: req.body.user_id } ).then( ( user ) ->
      sails.log.debug "Find user response #{ JSON.stringify user }" 
      user.user_teams.add(req.body.team_id)
      user.save (err, s) ->
        sails.log.debug "Add team to user #{ JSON.stringify s }"
        sails.log.debug "Add team to user err #{ JSON.stringify err }"
        res.send s
        # User.find().where( id: business_data.user_id).populateAll().exec (e, r) ->
        #   sails.log.debug "Populate result #{ JSON.stringify r[0].orgs }"
      #   sails.log.debug "User team saved #{ JSON.sringify s }"

        # user.populateAll().exec (e, r) ->
        #   sails.log.debug "Populate result #{ JSON.stringify r[0].orgs }"

    ).catch( (err) ->
      sails.log.debug "Join team find user error #{ JSON.stringify err }"
    ).done ->
      sails.log.debug "Join team find user done"



  get_team: (req, res) ->
    sails.log.debug "Hit the team controller/get_team"
    Team.find( { id: req.query.team_id } ).populate('main_org').then( (team) ->
      sails.log.debug "Get team response #{ JSON.stringify team }"
      res.send team
    ).catch( (err) ->
      sails.log.debug "Get team error #{ JSON.stringify err }"
    ).done ->
      sails.log.debug 
}