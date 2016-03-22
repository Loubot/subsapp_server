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

  

  social: ( req, res ) ->
    Promise = require('q')
    kids_array = new Array()
    sails.log.debug "Hit the UserController/social"
    sails.log.debug "Params #{ JSON.stringify req.allParams() }"

    User.findOne( id: req.param('id') ).populate('kids').populate('parent_events', { sort: 'createdAt desc'} ).then( ( user ) ->
      sails.log.debug "User social find #{ JSON.stringify user }"

      for kid in user.kids
        kids_array.push kid.id

      sails.log.debug "Kids array #{ JSON.stringify kids_array }"

      Promise.all([
        User.find().where( id: kids_array ).populate('user_events').populate('user_teams')
        TokenTransaction.find().where( user_id: kids_array, parent_id: req.param('id') )
      ]).spread ( ( kids_with_events, ttransactions ) ->
        sails.log.debug "kids with events  #{ JSON.stringify kids_with_events}"
        sails.log.debug "ttransactions  #{ JSON.stringify ttransactions }"
        res.json { user, kids_with_events: kids_with_events, token_transactions: ttransactions }
      )

    ).catch ( err ) ->
      sails.log.debug "User social find error #{ JSON.stringify err }"
      res.negotiate err

  kids_with_parents: ( req, res ) ->
    sails.log.debug "Hit the UserController/kids_with_parents"
    User.query( "select b.id, b.firstName, b.lastName, b.dob, b.parent_email, a.id as parent_id, c.team_team_members as team_id, d.name as team_name, d.main_org as club_id, e.name as club_name
      from user a
      inner join user b on a.email = b.parent_email
      left outer join team_team_members__user_user_teams c on b.id = c.user_user_teams
      left outer join team d on c.team_team_members = d.id
      left outer join org e on d.main_org = e.id;", ( err, results ) ->
        if err?          
          sails.log.debug "kids_with_parents results err #{ err }" 
          res.negotiate err
        else
          sails.log.debug "kids_with_parents results #{ JSON.stringify results }"
          res.json results

    )

  parents_with_events_old: ( req, res ) ->
    sails.log.debug "Hit the UserController/parents_with_events"
    User.query("select b.id, b.firstName, b.lastName, b.dob, b.parent_email, a.id as parent_id, c.team_team_members as team_id, d.name as team_name, d.main_org as club_id, e.name as club_name, f.id as event_id, f.name as title, f.details, f.start_date, f.end_date, f.price, g.paid, g.createdAt as paid_date
      from user a
      inner join user b on a.email = b.parent_email
      left outer join team_team_members__user_user_teams c on b.id = c.user_user_teams
      left outer join team d on c.team_team_members = d.id
      left outer join org e on d.main_org = e.id
      right join event f on c.team_team_members = f.event_team
      left outer join tokentransaction g on a.id = g.parent_id and f.id = g.event_id;", ( err, results ) ->
        if err?
          sails.log.debug "parents_with_events err #{ err }"
          res.negotiate err
        else
          sails.log.debug "parents_with_events #{ JSON.stringify results }"
          res.json results

    )

  parents_with_events: ( req, res ) ->
    sails.log.debug "Hit the UserController/parents_with_events"
    User.query("select a.email, a.firstName, a.lastName, a.id as parent_id, a.createdAt, a.updatedAt
      from user a
      where a.id=#{ req.param('id') };", ( err, parentData ) ->
        if err?
          sails.log.debug "parents_with_events parentData err #{ err }"
          res.negotiate err
        else
          sails.log.debug "parents_with_events parentData #{ JSON.stringify parentData }"
          User.query("select a.id, a.name, a.details, a.start_date, a.end_date, a.event_parent as parent_id
            from parentevent a
            where a.event_parent=#{ req.param('id') };", ( err, parentEventData ) ->
              if err?
                sails.log.debug "parents_with_events parentEventData err #{ err }"
                res.negotiate err
              else
                sails.log.debug "parents_with_events parentEventData #{ JSON.stringify parentEventData }"
                User.query("select b.id, b.firstName, b.lastName, b.dob, b.parent_email, a.id as parent_id, c.team_team_members as team_id, d.name as team_name, d.main_org as club_id, e.name as club_name
                  from user a 
                  inner join user b on a.email = b.parent_email
                  left outer join team_team_members__user_user_teams c on b.id = c.user_user_teams
                  left outer join team d on c.team_team_members = d.id
                  left outer join org e on d.main_org = e.id
                  where a.id=#{ req.param('id') };", ( err, kidsData ) ->
                    if err?
                      sails.log.debug "parents_with_events kidsData err #{ err }"
                      res.negotiate err
                    else
                      sails.log.debug "parents_with_events kidsData #{ JSON.stringify kidsData }"
                      User.query("select b.id, a.id as parent_id, e.event_event_user as event_id, f.name as title, f.details, f.start_date, f.end_date, f.price, g.paid, g.createdAt as paid_date
                        from user a 
                        inner join user b on a.email = b.parent_email
                        right join event_event_user__user_user_events e on b.id = e.user_user_events
                        right join event f on e.event_event_user = f.id
                        left outer join tokentransaction g on a.id = g.parent_id and f.id = g.event_id and b.id = g.user_id
                        where a.id=#{ req.param('id') };", ( err, kidsEventsData ) ->
                          if err?
                            sails.log.debug "parents_with_events kidsEventsData err #{ err }"
                            res.negotiate err
                          else
                            sails.log.debug "parents_with_events kidsEventsData #{ JSON.stringify kidsEventsData }"
                            NULL = ''
                            masterJsonData = {}
                            # masterJsonData.kids = kidsData
                            sails.log.debug "masterJsonData kids #{ JSON.stringify masterJsonData }"
                            masterJsonData.kidsWithEvents = []
                            masterJsonData.parent = parentData
                            masterJsonData.parentEvents = parentEventData
                            i = 0
                            while i < kidsData.length
                              kid = kidsData[i]
                              kidID = kid.id
                              temporaryKidEvents = []
                              j = 0
                              while j < kidsEventsData.length
                                kid_event = kidsEventsData[j]
                                kidEventID = kid_event.id
                                if kidID == kidEventID
                                  temporaryKidEvents.push kid_event
                                kid.events = temporaryKidEvents
                                
                                j++
                              masterJsonData.kidsWithEvents.push kid
                              sails.log.debug "Masterjsondata in loop #{ JSON.stringify masterJsonData }"
                              i++
                            sails.log.debug "Masterjsondata #{ JSON.stringify masterJsonData }"
                            res.json masterJsonData
                      )
                )
          )
    )

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
      res.negotiate err


  edit_user: (req, res) ->
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
    

    

  get_user_teams: ( req, res ) ->
    sails.log.debug "Hit the UserController/get_user_teams"
    sails.log.debug "Data #{ JSON.stringify req.query }"
    Team.find( { id: req.query.teams } ).populate('main_org').then( ( teams ) ->
      sails.log.debug "Teams find #{ JSON.stringify teams }"
      res.ok teams
    ).catch( ( err ) ->
      sails.log.debug "Teams find error #{ JSON.stringify err }"
      res.negotiate err
    )


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
