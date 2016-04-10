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
    
    org_id:
      collection: 'org'
      via: 'org_locations'
      columnName: 'org_id'
      
    
    toJSON: ->
      obj = @toObject()
      delete obj.password
      delete obj.socialProfiles
      obj

  updateOrCreate: (criteria, values, cb) ->
    self = this
    # reference for use by callbacks
    # If no values were specified, use criteria
    if !values
      values = if criteria.where then criteria.where else criteria
    @findOne criteria, (err, result) ->
      if err
        return cb(err, false)
      if result
        self.update criteria, values, cb
      else
        self.create values, cb
      return
    return
      
  # beforeUpdate: (values, next) ->
  #   CipherService.hashPassword values
  #   next()
  #   return
  # beforeCreate: (values, next) ->
  #   CipherService.hashPassword values
  #   next()
  #   return


# ---