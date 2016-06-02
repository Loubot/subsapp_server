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
    account_id:
      type: 'string'
      required: true

    bank_account: 
      type: 'text'
      required: true


################ Associations ####################


    org_id:
      model: 'org'

    
    toJSON: ->
      obj = @toObject()
      delete obj.password
      delete obj.socialProfiles
      obj

  