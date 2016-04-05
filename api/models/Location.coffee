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

    lat:
      type: 'float'
      defaultsTo: null

    lng:
      type: 'float'
      defaultsTo: null
    
    orgs_locations:
      model: 'org'
      
    
    toJSON: ->
      obj = @toObject()
      delete obj.password
      delete obj.socialProfiles
      obj

    add_location: ( other_model, body ) ->
      sails.log.debug "Location model/add_location"
      sails.log.debug "other model #{ JSON.stringify other_model }"
      sails.log.debug "Body #{ JSON.stringify body }"
      
  # beforeUpdate: (values, next) ->
  #   CipherService.hashPassword values
  #   next()
  #   return
  # beforeCreate: (values, next) ->
  #   CipherService.hashPassword values
  #   next()
  #   return


# ---