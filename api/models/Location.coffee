###*
# Location
# @description :: Model for storing locations
###

module.exports =
  # migrate: 'alter'
  # adapter: 'mysql',
  autoUpdatedAt: true
  autoCreatedAt: true
  autoPK: true
  schema: true
  attributes:      
    org_id:
      type: 'integer'
      required: true
    
      
    
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