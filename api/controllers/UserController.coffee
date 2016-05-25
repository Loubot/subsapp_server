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

  update: (req, res) ->
    sails.log.debug "Hit the User controller/update"      
    sails.log.debug "params #{ JSON.stringify req.param('id') }"
    User.update( id: req.param('id'), { firstName: req.body.firstName, lastName: req.body.lastName }).then( (result) ->
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
