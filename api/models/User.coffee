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
        
        sails.log.debug "org #{org}"

        parent_email = player[4].replace(/ /g,'')
        sails.log.debug "Parent email1 #{parent_email}"
        # User.create(
        #   dob_stamp: moment( player[3], ["MM-DD-YYYY", "DD-MM", "DD-MM-YYYY"] ).toISOString()
        #   parent_email: parent_email
        #   under_age: true
        #   firstName: player[0]
        #   lastName: player[1]
        #   dob: player[3]
        # ).then( ( kid ) ->
        #   sails.log.debug "Kid created #{ JSON.stringify kid }"
        #   x.push(kid)
        #   kid.user_orgs.add( org )
        #   kid.save()
        #   new_parent_email = player[4].replace(/ /g,'')
        #   sails.log.debug "New Parent email #{new_parent_email}"
        #   User.findOne( email: new_parent_email ).then( ( parent ) ->
        #     sails.log.debug "Parent found #{ JSON.stringify parent }"
        #     parent.kids.add( kid )
        #     parent.save()
        #   ).catch( ( parent_find_err ) ->
        #     sails.log.debug "parent_find_err #{ JSON.stringify parent_find_err }"
        #   )

          
        # ).catch( ( kid_create_err ) ->
        #   sails.log.debug "Kid create error #{ JSON.stringify kid_create_err }"
        # )
          
    cb(null, x)
   
      
      


       
    