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

    address:
      type: 'text'
      defaultsTo: ''
      required: true

    lat:
      type: 'float'
      defaultsTo: null

    lng:
      type: 'float'
      defaultsTo: null

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
      via: 'orgs_locations'

    files:
      collection: 'filetracker'
      via: 'org'
      # columnName: 'filetracker_id'

    

  afterCreate: ( values, cb ) -> #geocode address
    geocoderProvider = 'google'
    httpAdapter = 'http'
    geocoder = require('node-geocoder')(geocoderProvider, httpAdapter)
    sails.log.debug "Org create values #{ JSON.stringify values }"

    geocoder.geocode( values.address ).then( ( geocode_results ) ->
      sails.log.debug "Org create geocoder results #{ JSON.stringify geocode_results }"
      values.lat = geocode_results[0].latitude
      values.lng = geocode_results[0].longitude
      cb()
    ).catch( ( geocode_results_err ) ->
      sails.log.debug "Org create geocode_results_err #{ JSON.stringify geocode_results_err }"
      cb( geocode_results_err )
    )

    
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