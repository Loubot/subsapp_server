###*
# User
# @description :: Model keeping track of s3 uploads
###

module.exports =
  # migrate: 'alter'
  # adapter: 'mysql',
  autoUpdatedAt: true
  autoCreatedAt: true
  autoPK: true
  schema: true
  attributes:
    url: 
      type: 'string'
      required: true
      defaultsTo: null

    file_name:
      type: 'string'
      required: true
      defaultsTo: null
   
    org:
      model: 'org'
      columnName: 'org_id'

    
    toJSON: ->
      obj = @toObject()
      delete obj.password
      delete obj.socialProfiles
      obj
