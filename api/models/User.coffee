###*
# User
# @description :: Model for storing users
###
moment = require('moment')
module.exports =
  # migrate: 'alter'
  # adapter: 'mysql',
  autoUpdatedAt: true
  autoCreatedAt: true
  autoPK: true
  schema: true
  attributes:
    # username:
    #   type: 'string'
    #   required: true
    #   unique: true
    #   alphanumericdashed: true

    email:
      type: 'email'
      # required: true
      unique: true

    firstName:
      type: 'string'
      defaultsTo: ''
      
    lastName:
      type: 'string'
      defaultsTo: ''

    address: 
      type: 'text'
      defaultsTo: ''

    dob:
      type: 'string'
      defaultsTo: ''

    dob_stamp:
      type: 'datetime'
      defaultsTo: null

    password: type: 'string'

    club_admin:
      type: 'boolean'
      required: true
      defaultsTo: false

    team_admin:
      type: 'boolean'
      required: true
      defaultsTo: false

    parent_email:
      type: 'string'
      defaultsTo: ''

    under_age:
      type: 'boolean'
      defaultsTo: false


    orgs:
      collection: 'org'
      via: 'admins'

    teams:
      collection: 'team'
      via: 'manager'


    user_orgs:
      collection: 'org'
      via: 'org_members'
    

    ### non admin attributes ###

    user_events:
      collection: 'event'
      via: 'event_user'

    parent_events:
      collection: 'parentevents'
      via: 'event_parent'

    tokens:
      collection: 'token'
      via: 'owner'

    user_teams:
      collection: 'team'
      via: 'team_members'

    kids:
      collection: 'user'
      via: 'parent'
      columnName: 'kid_id'

    parent:
      collection: 'user'
      via: 'kids'
      columnName: 'parent_id'

    transactions:
      collection: 'transaction'
      via: 'payee'

    
    toJSON: ->
      obj = @toObject()
      delete obj.password
      delete obj.socialProfiles
      obj

  # beforeUpdate: (values, next) ->
  #   delete values.password
  #   sails.log.debug "ValuesAaaaa #{ JSON.stringify values }"
  #   sails.log.debug "nextxxxx #{ JSON.stringify next }"
  #   CipherService.hashPassword values
  #   next()
  #   return
  beforeCreate: (values, next) ->
    CipherService.hashPassword values
    next()
    return

#0=First name
#1=Last name
#2= Phone number
#3=DOB
#4=Email
  create_players: ( player_array, team, cb ) ->
    Promise = require('q')
    x = new Array()
    for player in player_array
      sails.log.debug "Parent email #{ player[4] }"
      Promise.all([

        User.create(dob_stamp: moment( player[3], ["MM-DD-YYYY", "DD-MM", "DD-MM-YYYY"] ).toISOString(),under_age: true, parent_email: player[4], firstName: player[0], lastName: player[1], dob: player[3]
          
        )
        User.findOne( email: player[4] )
        
      ]).spread( ( kid, parent) ->
        sails.log.debug "Kid created #{ JSON.stringify kid }"
        sails.log.debug "Parent found #{ JSON.stringify parent }"

        parent.kids.add( kid )
        kid.user_teams.add( team )
        Promise.all([
          parent.save()
          kid.save()
        ]).spread( ( saved_parent, saved_kid ) ->
          sails.log.debug "Saved parent #{ JSON.stringify saved_parent }"
          sails.log.debug "Saved kid #{ JSON.stringify saved_kid }"
        ).catch ( err ) ->
          sails.log.debug "saved parent error #{ JSON.stringify err }"
        
          sails.log.debug "Parent saved #{ JSON.stringify saved }"
          sails.log.debug "Parent saved err #{ JSON.stringify err }" if err?
        


      ).catch ( err ) ->
        sails.log.debug "Create player error #{ JSON.stringify err }" if err?

      
      # User.create(
      #   parent_email: player[4]
      #   firstName: player[0] 
      #   lastName: player[1]
      #   dob: player[3]
      #   dob_stamp: moment(player[3], ["MM-DD-YYYY", "DD-MM", "DD-MM-YYYY"]).toISOString()
      #   under_age: true
      # ).then( ( user ) ->
      #   sails.log.debug "User created #{ JSON.stringify user }"
      #   x.push user

      # ).catch( ( err ) ->
      #   sails.log.debug "User create error #{ JSON.stringify err }"
      #   cb( err )
      #   return false
      # )
    #   d = moment(player[3], ["MM-DD-YYYY", "DD-MM", "DD-MM-YYYY"])
    #   sails.log.debug "Date #{ d }"
    #   c = d.unix()
    #   sails.log.debug c
    cb(null, x)

  find_in_year: ( date, club_id, cb) ->
    matching_players = new Array()

    User.find( { where: dob_stamp: '<': date } ).then( ( users ) ->
      sails.log.debug "User find by stamp #{ JSON.stringify users }"
      cb( null, users )
    ).catch ( err ) ->
      sails.log.debug "User find by stamp err #{ JSON.stringify err }"
      cb( err )

    
      

