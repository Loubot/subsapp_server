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

      User.find().where( id: params.user_id).populateAll().exec (e, r) ->
        sails.log.debug "Populate result #{ JSON.stringify r[0].teams }"
        res.send r[0].teams

  destroy_team: (req, res) ->
    sails.log.debug "Hit the team controller/destroy_team"
    sails.log.debug "Data #{ JSON.stringify req.body }"
    res.status(200)
    Team.destroy( id: req.body.team_id).then( (team) ->
      sails.log.debug "Team destroy response #{ JSON.stringify team }"
    ).catch( (err) ->
      sails.log.debug "Team destroy error #{ JSON.stringify err }"
    ).done ->
      sails.log.debug "Team destroy done"
  
}