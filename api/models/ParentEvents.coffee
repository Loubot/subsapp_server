###*
# Event
# @description :: Model for storing parent events
###

module.exports =
  # migrate: 'alter'
  # adapter: 'mysql',
  autoUpdatedAt: true
  autoCreatedAt: true
  autoPK: true
  schema: true
  attributes:      
    name:
      type: 'string'
      defaultsTo: ''
      required: true

    date:
      type: 'datetime'
      required: true
      defaultsTo: ''

    event_parent:
      model: 'user'
      
    
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