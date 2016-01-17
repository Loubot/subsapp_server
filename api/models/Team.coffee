###*
# Team
# @description :: Model for storing teams
###

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
      
    name:
      type: 'string'
      defaultsTo: ''
      required: true
      unique: true

    main_org: 
      model: 'org'

    manager:
      model: 'user'

    team_members:
      collection: 'user'
      via: 'user_teams'

    events:
      collection: 'event'
      via: 'event_team'

    


    
    toJSON: ->
      obj = @toObject()
      delete obj.password
      delete obj.socialProfiles
      obj
  # beforeUpdate: (values, next) ->
  #   CipherService.hashPassword values
  #   next()
  #   return
  # beforeCreate: (values, next) ->
  #   CipherService.hashPassword values
  #   next()
  #   return


# ---
# generated by js2coffee 2.1.0