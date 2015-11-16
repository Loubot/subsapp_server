###*
# User
# @description :: Model for storing users
###

module.exports =
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