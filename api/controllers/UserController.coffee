###*
# UserController
#
# @description :: Server-side logic for managing Users
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###

module.exports = {
  temp_user: ( req, res ) ->
    sails.log.debug "Hit the user controller/temp-user"
    sails.log.debug "params #{ JSON.stringify req.query }"
    User.findOne( id: req.query.id ).populateAll().then( ( user ) ->
      sails.log.debug "Found user #{ JSON.stringify user }"
      charges = {
        vat: sails.config.stripe.vat,
        stripe_comm_precent: sails.config.stripe.stripe_comm_precent,
        stripe_comm_euro: sails.config.stripe.stripe_comm_euro 
        }
      res.json user, charges
        
      
    ).catch ( err ) ->
      sails.log.debug "Find user error #{ JSON.stringify err }"
      res.serverError err
      
  edit_user: (req, res) ->
    sails.log.debug "Hit the User controller/edit-user"      
    sails.log.debug "params #{ JSON.stringify req.body }"
    User.update( id: req.body.id, { firstName: req.body.firstName, lastName: req.body.lastName }).then( (result) ->
      sails.log.debug "User update response #{ JSON.stringify result }"
      # res.status(204)
      res.send result
    ).catch( ( err ) ->
      sails.log.debug "Edit user error #{ JSON.stringify err }"
      res.serverError err
    ).done ->
      sails.log.debug "Edit user done"

  pick_kids: ( req, res ) ->
    Promise = require('bluebird')
    sails.log.debug JSON.stringif
    sails.log.debug "Hit the UserController/pick_kids"
    sails.log.debug "Params #{ JSON.stringify req.query }"

    Promise.all(
      [ User.findOne( id: req.query.id)
       User.find( parent_email: req.query.email )
      ]
      ).spread ( parent, kids ) ->
        sails.log.debug "Parent #{ JSON.stringify parent}"
        sails.log.debug "Kids #{ JSON.stringify kids}"
        res.json parent: parent, kids: kids
    

    

  get_user_teams: ( req, res ) ->
    sails.log.debug "Hit the UserController/get_user_teams"
    sails.log.debug "Data #{ JSON.stringify req.query }"
    Team.find( { id: req.query.teams } ).populate('main_org').then( ( teams ) ->
      sails.log.debug "Teams find #{ JSON.stringify teams }"
      res.ok teams
    ).catch( ( err ) ->
      sails.log.debug "Teams find error #{ JSON.stringify err }"
      res.serverError err
    )


  # password_remind: ( req, res ) ->
  #   sails.log.debug "Hit the UserController/get_user_teams"
  #   sails.log.debug "Data #{ JSON.stringify req.query }"
  #   User.find( { id: req.query.user } ).populate('token').then( ( users ) ->
  #     sails.log.debug "Teams find #{ JSON.stringify user }"
  #     res.ok teams
  #   ).catch( ( err ) ->
  #     sails.log.debug "Teams find error #{ JSON.stringify err }"
  #     res.serverError err
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
    #   res.serverError err

}
