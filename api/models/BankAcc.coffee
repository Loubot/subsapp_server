###*
# BankAcc
# @description :: Model for storing Bank accounts
###

module.exports =
  migrate: 'alter'
  # adapter: 'mysql',
  autoUpdatedAt: true
  autoCreatedAt: true
  autoPK: true
  schema: true
  attributes:
    stripe_user_id:
      type: 'string'
      required: true
      defaultsTo: null

    bank_account: 
      type: 'text'
      required: true
      defaultsTo: null

    tokens:
      type: 'integer'
      defaultsTo: 0


################ Associations ####################


    org_id:
      model: 'org'

    
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

  