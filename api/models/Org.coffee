###*
# Org
# @description :: Model for storing orgs
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
      
    name:
      type: 'string'
      defaultsTo: ''
      required: true

    address:
      type: 'text'
      defaultsTo: ''
      required: true

    admins: 
      collection: 'user'
      via: 'orgs'

    teams:
      collection: 'team'
      via: 'main_org'

    org_members:
      collection: 'user'
      via: 'user_orgs'

    


    
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