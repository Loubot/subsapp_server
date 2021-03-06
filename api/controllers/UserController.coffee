###*
# UserController
#
# @description :: Server-side logic for managing Users
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###
moment = require('moment')

module.exports = {

  findOne: ( req, res ) ->
    sails.log.debug "Hit the user controller/findOne"
    sails.log.debug "Params #{ req.param('id') }"
    User.findOne( id: req.param('id') ).populateAll().then( ( user ) ->
      sails.log.debug "Found user #{ JSON.stringify user }"
      
      res.json user
        
      
    ).catch ( err ) ->
      sails.log.debug "Find user error #{ err }"
      res.negotiate err

  # parents_with_events_old: ( req, res ) ->
  #   sails.log.debug "Hit the UserController/parents_with_events"
  #   User.query("select b.id, b.firstName, b.lastName, b.dob, b.parent_email, a.id as parent_id, c.team_team_members as team_id, d.name as team_name, d.main_org as club_id, e.name as club_name, f.id as event_id, f.name as title, f.details, f.start_date, f.end_date, f.price, g.paid, g.createdAt as paid_date
  #     from user a
  #     inner join user b on a.email = b.parent_email
  #     left outer join team_team_members__user_user_teams c on b.id = c.user_user_teams
  #     left outer join team d on c.team_team_members = d.id
  #     left outer join org e on d.main_org = e.id
  #     right join event f on c.team_team_members = f.event_team
  #     left outer join tokentransaction g on a.id = g.parent_id and f.id = g.event_id;", ( err, results ) ->
  #       if err?
  #         sails.log.debug "parents_with_events err #{ err }"
  #         res.negotiate err
  #       else
  #         sails.log.debug "parents_with_events #{ JSON.stringify results }"
  #         res.json results

  #   )


  update: (req, res) ->
    sails.log.debug "Hit the User controller/edit-user"      
    sails.log.debug "params #{ JSON.stringify req.body }"
    User.update( id: req.body.id, { firstName: req.body.firstName, lastName: req.body.lastName }).then( (result) ->
      sails.log.debug "User update response #{ JSON.stringify result }"
      # res.status(204)
      res.send result
    ).catch( ( err ) ->
      sails.log.debug "Edit user error #{ JSON.stringify err }"
      res.negotiate err
    ).done ->
      sails.log.debug "Edit user done"

  # pick_kids: ( req, res ) ->
  #   Promise = require('bluebird')
  #   sails.log.debug JSON.stringif
  #   sails.log.debug "Hit the UserController/pick_kids"
  #   sails.log.debug "Params #{ JSON.stringify req.query }"

  #   Promise.all(
  #     [ User.findOne( id: req.query.id)
  #      User.find( parent_email: req.query.email )
  #     ]
  #     ).spread ( parent, kids ) ->
  #       sails.log.debug "Parent #{ JSON.stringify parent}"
  #       sails.log.debug "Kids #{ JSON.stringify kids}"
  #       res.json parent: parent, kids: kids
    

    

  # get_user_teams: ( req, res ) ->
  #   sails.log.debug "Hit the UserController/get_user_teams"
  #   sails.log.debug "Data #{ JSON.stringify req.query }"
  #   Team.find( { id: req.query.teams } ).populate('main_org').then( ( teams ) ->
  #     sails.log.debug "Teams find #{ JSON.stringify teams }"
  #     res.ok teams
  #   ).catch( ( err ) ->
  #     sails.log.debug "Teams find error #{ JSON.stringify err }"
  #     res.negotiate err
  #   )


  # password_remind: ( req, res ) ->
  #   sails.log.debug "Hit the UserController/get_user_teams"
  #   sails.log.debug "Data #{ JSON.stringify req.query }"
  #   User.find( { id: req.query.user } ).populate('token').then( ( users ) ->
  #     sails.log.debug "Teams find #{ JSON.stringify user }"
  #     res.ok teams
  #   ).catch( ( err ) ->
  #     sails.log.debug "Teams find error #{ JSON.stringify err }"
  #     res.negotiate err
  #   )



    # Post.findOne(req.param('id')).populate('user').populate('comments').then((post) ->
    #   commentUsers = User.find(id: _.pluck(post.comments, 'user')).then((commentUsers) ->
    #     commentUsers
    #   )
    #   [
    #     post
    #     commentUsers
    #   ]
    # ).spread((post, commentUsers) ->
    #   commentUsers = _.indexBy(commentUsers, 'id')
    #   #_.indexBy: Creates an object composed of keys generated from the results of running each element of the collection through the given callback. The corresponding value of each key is the last element responsible for generating the key
    #   post.comments = _.map(post.comments, (comment) ->
    #     comment.user = commentUsers[comment.user]
    #     comment
    #   )
    #   res.json post
    #   return
    # ).catch (err) ->
    #   res.negotiate err


}
