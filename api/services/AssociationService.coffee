# Service to create Associations 
Promise = require( 'bluebird' )
module.exports = {
  associate_kids: ( user, cb ) ->
    kids_array = new Array()
    user.mobile_number1 = 123 if !( user.mobile_number1? )
    sails.log.debug "AssociationService/associate_kids user #{ JSON.stringify user }"
    Promise.all([
      User.findOne( id: user.id )
      User.find( or: [
        { parent_email: user.email }
        { mobile_number1: user.mobile_number1 }
        { mobile_number2: user.mobile_number1 }
      ])
    ]).spread( ( parent, kids ) ->
      sails.log.debug "Parent #{ JSON.stringify parent }"
      sails.log.debug "kids #{ JSON.stringify kids }"
      for kid in kids
        kids_array.push kid.id
      parent.kids.add( kids_array )
      parent.save().then( ( parent_saved ) ->
        sails.log.debug "parent_saved #{ JSON.stringify parent_saved }"
        cb( null, parent_saved )
      ).catch( ( parent_saved_err ) ->
        sails.log.debug "parent_saved_err #{ JSON.stringify parent_saved_err }"
        cb( parent_saved_err )
      )
    ).catch( ( parent_kids_err ) ->
      sails.log.debug "parent_kids_err #{ JSON.stringify parent_kids_err }"
      cb( parent_kids_err )
    )
}