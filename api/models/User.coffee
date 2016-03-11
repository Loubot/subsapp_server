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
      type: 'date'
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
      collection: 'parentevent'
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
      unique: true

    parent:
      collection: 'user'
      via: 'kids'
      columnName: 'parent_id'
      unique: true

    transactions:
      collection: 'transaction'
      via: 'payee'

    getFullName: ->
      _.str.trim (@firstName or '') + ' ' + (@lastName or '')

    
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
  create_players: ( player_array, org, cb ) ->
    Promise = require('q')
    x = new Array()
    for player in player_array
      
      if ( player[0]? and player[1]? and player[3] and player[4]? )
        parent_email = player[4].replace(/ /g,'')
        sails.log.debug "Parent email #{parent_email}"
        sails.log.debug "org #{org}"

        User.findOrCreate(
          dob_stamp: moment( player[3], ["MM-DD-YYYY", "DD-MM", "DD-MM-YYYY"] ).toISOString(), parent_email: parent_email, under_age: true, firstName: player[0], lastName: player[1], dob: player[3]).then( ( user ) ->
          sails.log.debug "User created #{ JSON.stringify user }"
          user.user_orgs.add( org )
          user.save ( err, saved) ->
            sails.log.debug "User save error #{ JSON.stringify err }" if err?
            sails.log.debug "User save  #{ JSON.stringify saved }" 
            x.push user
        ).catch ( err ) ->
          sails.log.debug "User created err #{ JSON.stringify err }"
        # Promise.all([

        #   User.create(
        #     dob_stamp: moment( player[3], ["MM-DD-YYYY", "DD-MM", "DD-MM-YYYY"] ).toISOString(),
        #     parent_email: parent_email, 
        #     under_age: true,          
        #     firstName: player[0], 
        #     lastName: player[1], dob: player[3]          
        #   )
        #   User.findOne( email: parent_email )
          
        # ]).spread( ( kid, parent) ->
        #   sails.log.debug "Kid created #{ JSON.stringify kid }"
        #   sails.log.debug "Parent found #{ JSON.stringify parent }"

          
        #   parent.kids.add( kid )
        #   kid.user_orgs.add( org )
        #   Promise.all([
        #     parent.save()
        #     kid.save()
        #   ]).spread( ( saved_parent, saved_kid ) ->
        #     sails.log.debug "Saved parent #{ JSON.stringify saved_parent }"
        #     sails.log.debug "Saved kid #{ JSON.stringify saved_kid }"
        #   ).catch ( err ) ->
        #     sails.log.debug "saved parent error #{ JSON.stringify err }"
          
        #     sails.log.debug "Parent saved #{ JSON.stringify saved }"
        #     sails.log.debug "Parent saved err #{ JSON.stringify err }" if err?
          


        # ).catch ( err ) ->
        #   sails.log.debug "Create player error #{ JSON.stringify err }" if err?

      
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