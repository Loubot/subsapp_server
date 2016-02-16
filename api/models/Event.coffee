###*
# Event
# @description :: Model for storing events
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

    price:
      type: 'integer'
      required: true

    event_team:
      model: 'team'

    event_user:
      collection: 'user'
      via: 'user_events'
      
    
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

  afterCreate: ( values, next ) ->
    sails.log.debug "Event values #{ JSON.stringify values }"
    
    Team.findOne( id: values.event_team ).populate('team_members').then( ( team ) ->
      sails.log.debug "Event afterValidate Team find #{ JSON.stringify team }"
      for user in team.team_members
        sails.log.debug "User loop #{ JSON.stringify user }"
        user.user_events.add values.id
        user.save ( err, saved ) ->
          sails.log.debug "Event afterValidate User save err #{ JSON.stringify err }" if err?
          sails.log.debug "Event afterValidate User save #{ JSON.stringify saved }" 

      next()

    ).catch ( err ) ->
      sails.log.debug "Event afterValidate Team find err #{ JSON.stringify err }"




# ---
# generated by js2coffee 2.1.0