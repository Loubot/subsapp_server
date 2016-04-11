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

    address:
      type: 'text'
      defaultsTo: ''
      required: true

    
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


  beforeCreate: ( values, cb ) -> #geocode address
    geocoderProvider = 'google'
    httpAdapter = 'http'
    geocoder = require('node-geocoder')(geocoderProvider, httpAdapter)
    sails.log.debug "LOcation create values #{ JSON.stringify values }"

    geocoder.geocode( values.address ).then( ( geocode_results ) ->
      sails.log.debug "Org create geocoder results #{ JSON.stringify geocode_results[0].latitude }"
      values.lat = geocode_results[0].latitude
      values.lng = geocode_results[0].longitude
      cb()
    ).catch( ( geocode_results_err ) ->
      sails.log.debug "Org create geocode_results_err #{ JSON.stringify geocode_results_err }"
      cb( geocode_results_err )
    )

      
  # beforeUpdate: (values, next) ->
  #   CipherService.hashPassword values
  #   next()
  #   return
  # beforeCreate: (values, next) ->
  #   CipherService.hashPassword values
  #   next()
  #   return


# ---