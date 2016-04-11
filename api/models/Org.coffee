###*
# Org
# @description :: Model for storing orgs
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

    # lat:
    #   type: 'float'
    #   defaultsTo: null

    # lng:
    #   type: 'float'
    #   defaultsTo: null

    admins: 
      collection: 'user'
      via: 'orgs'

    teams:
      collection: 'team'
      via: 'main_org'

    org_members:
      collection: 'user'
      via: 'user_orgs'

    org_locations:
      collection: 'location'
      via: 'org_id'
      columnName: 'location_id'

    files:
      collection: 'filetracker'
      via: 'org'
      # columnName: 'filetracker_id'
    
    toJSON: ->
      obj = @toObject()
      delete obj.password
      delete obj.socialProfiles
      obj

  # beforeCreate: ( values, cb ) ->
  #   sails.log.debug "Org after create"
  #   sails.log.debug "Values #{ JSON.stringify values }"

  #   cb()
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