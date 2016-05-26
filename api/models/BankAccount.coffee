###*
# BankAccount
# @description :: Model for storing bank_accounts
###

module.exports =
  # migrate: 'alter'
  # adapter: 'mysql',
  autoUpdatedAt: true
  autoCreatedAt: true
  autoPK: true
  schema: true
  attributes:
    account_holder_name:
      type: 'string'
      
      defaultsTo: null

    account_holder_type:
      type: 'string'
      
      defaultsTo: null


    bank_name:
      type: 'string'
      
      defaultsTo: null

    id: 
      type: 'string'
      
      defaultsTo: null

    last4:
      type: 'integer'
      
      defaultsTo: null

    tokens:
      type: 'integer'
      
      defaultsTo: 0


  ################## associations ###########################
    org_id:
      model: 'org'
    
      
    
    toJSON: ->
      obj = @toObject()
      obj
  # beforeUpdate: (values, next) ->
  #   CipherService.hashPassword values
  #   next()
  #   return
  # beforeCreate: (values, next) ->
  #   CipherService.hashPassword values
  #   next()
  #   return

  updateOrCreate: (criteria, values, cb) ->
    sails.log.debug "BankAccount update or create values #{ JSON.stringify values }"
    sails.log.debug "BankAccount update or create criteria #{ JSON.stringify criteria }"
    self = this
    # reference for use by callbacks
    # If no values were specified, use criteria
    if !values
      values = if criteria.where then criteria.where else criteria
    @findOne criteria, (err, result) ->
      if err
        sails.log.debug "BankAccount findOne err"
        return cb(err, false)
      if result
        sails.log.debug "BankAccount findOne #{ JSON.stringify result }"
        
        values.tokens = result.tokens + values.tokens # Update tokens to new amount
        
        self.update criteria, values, cb
      else

        sails.log.debug "BankAccount findOne #{ JSON.stringify result }"
        self.create values, cb
      return
    return

    
    toJSON: ->
      obj = @toObject()
      delete obj.password
      delete obj.socialProfiles
      obj
 