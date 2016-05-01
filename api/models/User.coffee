###*
# User
# @description :: Model for storing users
###
moment = require('moment')
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

    email:
      type: 'email'
      # required: true
      unique: true

    password: type: 'string'

    firstName:
      type: 'string'
      defaultsTo: ''
      
    lastName:
      type: 'string'
      defaultsTo: ''

    address: 
      type: 'text'
      defaultsTo: ''

    dob:
      type: 'string'
      defaultsTo: ''

    mobile_number1:
      type: 'string'
      defaultsTo: null

    mobile_number2:
      type: 'string'
      defaultsTo: null

    fair_number:
      type: 'string'
      defaultsTo: null
      


    dob_stamp:
      type: 'date'
      defaultsTo: null

    super_admin:
      type: 'boolean'
      # required: true
      defaultsTo: false

    club_admin:
      type: 'boolean'
      required: true
      defaultsTo: false

    team_admin:
      type: 'boolean'
      required: true
      defaultsTo: false

    parent_email:
      type: 'string'
      defaultsTo: ''

    under_age:
      type: 'boolean'
      defaultsTo: false


    org:
      collection: 'org'
      via: 'user_id'

    teams:
      collection: 'team'
      via: 'manager'


    user_orgs:
      collection: 'org'
      via: 'org_members'
    

    ### non admin attributes ###

    user_events:
      collection: 'event'
      via: 'event_user'

    parent_events:
      collection: 'parentevent'
      via: 'event_parent'

    tokens:
      collection: 'token'
      via: 'owner'

    user_teams:
      collection: 'team'
      via: 'team_members'

    kids:
      collection: 'user'
      via: 'parent'
      columnName: 'kid_id'
      unique: true

    parent:
      collection: 'user'
      via: 'kids'
      columnName: 'parent_id'
      unique: true

    transactions:
      collection: 'transaction'
      via: 'payee'

    gcm_tokens:
      collection: 'gcmreg'
      via: 'user_id'


    getFullName: ->
      _.str.trim (@firstName or '') + ' ' + (@lastName or '')

    
    toJSON: ->
      obj = @toObject()
      delete obj.password if !( process.env.NODE_ENV == 'development' )
      # delete obj.socialProfiles

      obj

  # beforeUpdate: (values, next) ->
  #   delete values.password
  #   sails.log.debug "ValuesAaaaa #{ JSON.stringify values }"
  #   sails.log.debug "nextxxxx #{ JSON.stringify next }"
  #   CipherService.hashPassword values
  #   next()
  #   return
  beforeCreate: (values, next) ->
    CipherService.hashPassword values
    next()
    return


#0=First name
#1=Last name
#2= Phone number
#3=DOB
#4=Email

  ############# create kid called from filecontroller/fileservice
  create_kid: ( kid_details, org, cb ) ->
    cb( 'empty' ) if !(kid_details?) or kid_details == [] or kid_details.length <= 1
    parent_email = null
    date_stamp = null
    Promise = require('q')
    sails.log "Kid details #{ JSON.stringify kid_details }"
    sails.log.debug "Org id #{ org }"

    parent_email = kid_details[4].replace(/ /g,'')
    # "string".replace(/\//g, 'ForwardSlash')
    date_stamp = moment( kid_details[3], ["MM-DD-YYYY", "DD-MM", "DD-MM-YYYY", "MM/DD/YYYY", "DD/MM/YYYY"] ).toISOString()
    sails.log.debug "Stamp !! #{ date_stamp }"
    sails.log.debug "Parent email1 #{parent_email}"

    Promise.all([
      User.create(
        dob_stamp: date_stamp
        parent_email: parent_email
        under_age: true
        firstName: kid_details[0]
        lastName: kid_details[1]
        dob: kid_details[3]
      )
      User.findOne( email: parent_email )
    ]).spread( ( kid, parent ) ->
      sails.log.debug "Kid created #{ JSON.stringify kid }"
      
      if parent? and ( parent != [] )
        sails.log.debug "Parent found #{ JSON.stringify parent }"
        parent.kids.add( kid )
        kid.user_orgs.add( org )
        Promise.all([
          parent.save()        
          kid.save()
        ]).spread( ( parent_saved, kid_saved ) ->
          sails.log.debug "Parent saved #{ JSON.stringify parent_saved }"
          sails.log.debug "Kid saved #{ JSON.stringify kid_saved }"
          cb( null, kid )
        ).catch( ( parent_org_save_err ) ->
          sails.log.debug "Parent and org save error #{ JSON.stringify parent_org_save_err }"
          cb( parent_org_save_err )
        )
        
      else
       sails.log.debug "Parent not found"
       kid.user_orgs.add( org )
       kid.save()
       cb( null, kid )

    ).catch( ( kid_parent_err ) ->
      sails.log.debug "Kid created parent found err #{ kid_parent_err }"
      cb( kid_parent_err )
    )

    #################### end of create kid ############################

  # associate_kids: ( parent_info, cb )  ->
  #   sails.log.debug "User model/associate_kids"
  #   sails.log.debug "Parent info #{ JSON.stringify parent_info }"

  #   User.find( or: [
  #     { email: parent_info.email }
  #     { mobile_number1: parent_info.mobile_number1 }
  #     { mobile_number1: parent_info.mobile_number1 }
  #   ]).then( ( kids ) ->
  #     AssociationService.associate_kids( parent_info.id, ( err, success ) ->
  #       if err?
  #         sails.log.debug "AssociationService.associate_kids_err #{ JSON.stringify err }"
  #         cb( err )
  #       else
  #         sails.log.debug "Kids associated "
  #         cb( null, success )
  #     )
  #   ).catch( ( kids_err ) ->
  #     sails.log.debug "Kids find error #{ JSON.stringify kids_err }"
  #   )