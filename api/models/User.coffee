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
      required: true
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

    tokens:
      collection: 'token'
      via: 'owner'

    user_teams:
      collection: 'team'
      via: 'team_members'

    # stripe_id: 
    #   type: 'string'
    #   defaultsTo: ''

    
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
  create_players: ( player_array, cb ) ->
    x = new Array()
    for player in player_array
      
      User.create(
        parent_email: player[4]
        firstName: player[0] 
        lastName: player[1]
        dob: player[3]
        dob_stamp: moment(player[3], ["MM-DD-YYYY", "DD-MM", "DD-MM-YYYY"]).toISOString()
        under_age: true
      ).then( ( user ) ->
        sails.log.debug "User created #{ JSON.stringify user }"
        x.push user

      ).catch( ( err ) ->
        sails.log.debug "User create error #{ JSON.stringify err }"
        cb( err )
        return false
      )
    #   d = moment(player[3], ["MM-DD-YYYY", "DD-MM", "DD-MM-YYYY"])
    #   sails.log.debug "Date #{ d }"
    #   c = d.unix()
    #   sails.log.debug c
    cb(null, x)