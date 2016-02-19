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
      sails.log.debug "Find user error #{ JSON.stringify err }"
      res.serverError err

  social: ( req, res ) ->
    Promise = require('q')
    kids_array = new Array()
    sails.log.debug "Hit the UserController/social"
    sails.log.debug "Params #{ JSON.stringify req.allParams() }"

    User.findOne( id: req.param('id') )
    .populate('kids')
    .populate('parent_events', { sort: 'createdAt desc'})
    .then( ( user ) ->
      sails.log.debug "User social find #{ JSON.stringify user }"

      for kid in user.kids
        kids_array.push kid.id

      sails.log.debug "Kids array #{ JSON.stringify kids_array }"

      Promise.all([
        User.find().where( id: kids_array ).populate('user_events').populate('user_teams')
        TokenTransaction.find().where( user_id: kids_array, parent_id: req.param('id') )
      ]).spread ( ( kids_with_events, ttransactions )->
        sails.log.debug "kids with events  #{ JSON.stringify kids_with_events}"
        sails.log.debug "ttransactions  #{ JSON.stringify ttransactions }"
        res.json { user, kids_with_events: kids_with_events, token_transactions: ttransactions }
      )

      
      
      # User.find().where( id: kids_array ).populate('user_events').populate('user_teams').then( ( kids_with_events ) -> 
      #   sails.log.debug "Find kids with events #{ JSON.stringify kids_with_events }"

      #   res.json { user, kids_with_events: kids_with_events }

      # ).catch ( err ) ->
      #   sails.log.debug "Kis with events error #{ JSON.stringify err }"
      #   res.serverError err

    ).catch ( err ) ->
      sails.log.debug "User social find error #{ JSON.stringify err }"
      res.serverError err

  financial: ( req, res ) ->
    sails.log.debug "Hit the UserController/financial"
    sails.log.debug "Parasm #{ req.param() }"
    charges = {
      vat: sails.config.stripe.vat,
      stripe_comm_precent: sails.config.stripe.stripe_comm_precent,
      stripe_comm_euro: sails.config.stripe.stripe_comm_euro 
    }
    User.findOne( id: req.param('id') )
    .populate('tokens')
    .populate('transactions')
    .then( ( user ) ->
      sails.log.debug "User find financial #{ JSON.stringify user }"
      res.json { user, charges: charges }
    ).catch ( err ) -> 
      sails.log.debug "User find financial error #{ JSON.stringify err }"
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

  get_players_by_year: ( req, res ) ->
    sails.log.debug "Hit the user controller/find_by_date"
    date = moment().toISOString()
    sails.log.debug "Current time #{ JSON.stringify date }"
    User.find_in_year( date, req.query.team_id, ( err, users ) ->
      if err?
        sails.log.debug "Find user by date error #{ JSON.stringify err }"
        res.serverError err
      else
        sails.log.debug "Find uers by date #{ JSON.stringify users }"
        res.json users
    )

}
