###*
# User
# @description :: Model for storing users
###

module.exports =
  migrate: 'safe',
  adapter: 'mysql',
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

    password: type: 'string'

    manager_access:
      type: 'boolean'
      required: true
      defaultsTo: false

    email:
      type: 'email'
      required: true
      unique: true
    firstName:
      type: 'string'
      defaultsTo: ''
    lastName:
      type: 'string'
      defaultsTo: ''

    stripe_id: 
      type: 'string'
      defaultsTo: ''

    tokens:
      collection: 'token'
      via: 'owner'

    orgs:
      collection: 'org'
      via: 'admins'

    teams:
      collection: 'team'
      via: 'manager'


    user_orgs:
      collection: 'org'
      via: 'org_members'

    user_teams:
      collection: 'team'
      via: 'team_members'

    


    
    toJSON: ->
      obj = @toObject()
      delete obj.password
      delete obj.socialProfiles
      obj
  beforeUpdate: (values, next) ->
    CipherService.hashPassword values
    next()
    return
  beforeCreate: (values, next) ->
    CipherService.hashPassword values
    next()
    return


# ---
# generated by js2coffee 2.1.0