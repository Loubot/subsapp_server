###*
# Transactionl
# @description :: Model for storing transactions
###

module.exports =
  # migrate: 'alter'
  # adapter: 'mysql',
  autoUpdatedAt: true
  autoCreatedAt: true
  autoPK: true
  schema: true
  attributes:
    user_id:
      type: 'integer'
      required: true
      defaultsTo: null

    amount: 
      type: 'integer'
      defaultsTo: null

    token_amount:
      type: 'integer'
      defaultsTo: null

    amount_refunded:
      type: 'integer'
      defaultsTo: null

    stripe_id: 
      type: 'string'
      defaultsTo: null

    created:
      type: 'string'
      defaultsTo: null

    failure_code:
      type: 'string'
      defaultsTo: null

    failure_message:
      type: 'text'

    paid:
      type: 'boolean'
      defaultsTo: false

    receipt_email:
      type: 'string'
      defaultsTo: null

    status:
      type: 'string'
      defaultsTo: null

    last4:
      type: 'string'
      defaultsTo: null

    payee:
      model: 'user'

   
    
    toJSON: ->
      obj = @toObject()
      delete obj.password
      delete obj.socialProfiles
      obj

  # beforeUpdate: (values, next) ->
  #   delete values.password
  #   sails.log.debug "ValuesAaaaa #{ JSON.stringify values }"
  #   sails.log.debug "nextxxxx #{ JSON.stringify next }"
  #   CipherService.hashPassword values
  #   next()
  #   return
  


