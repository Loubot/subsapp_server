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

    location_name:
      type: 'string'
      defaultsTo: null

    location_owner:
      type: 'string'
      defaultsTo: null

    lat:
      type: 'float'
      defaultsTo: null

    lng:
      type: 'float'
      defaultsTo: null

    address:
      type: 'text'
      defaultsTo: ''
      # required: true

    
    org_id:
      collection: 'org'
      via: 'org_locations'
      columnName: 'org_id'

    event_id:
      collection: 'event'
      via: 'location_id'
      
    
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
      sails.log.debug "Criteria #{ JSON.stringify criteria }"
      sails.log.debug "Found result #{ JSON.stringify result }"
      if err
        sails.log.debug "Location find or create err"
        return cb(err, false)
      if result
        sails.log.debug "Location find or create found one"
        delete values.id
        self.update criteria, values, cb
      else
        sails.log.debug "Location find or create new one"
        self.create values, cb
      return
    return


  beforeCreate: ( values, cb ) -> #geocode address
    geocoderProvider = 'google'
    httpAdapter = 'https'
    extra = apiKey: sails.config.stripe.maps_Key
    geocoder = require('node-geocoder')( geocoderProvider, httpAdapter, extra )

    sails.log.debug "LOcation create values #{ JSON.stringify values }"

    geocoder.geocode( values.address ).then( ( geocode_results ) ->
      if geocode_results.length == 0
        return cb( "No results returned " )
         
      sails.log.debug "Org create geocoder results #{ JSON.stringify geocode_results }"
      values.lat = geocode_results[0].latitude
      values.lng = geocode_results[0].longitude
      cb()
    ).catch( ( geocode_results_err ) ->
      sails.log.debug "Org create geocode_results_err #{ JSON.stringify geocode_results_err }"
      cb( geocode_results_err )
    )

# ---