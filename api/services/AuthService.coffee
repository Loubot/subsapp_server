# Service to provide Authorisation for accessing data and urls.
module.exports = {

  check_club_admin: ( user, id ) -> # Make sure session user is the admin of this club
    sails.log.debug "Authservice check_club_admin"
    sails.log.debug "Params #{ JSON.stringify user } #{ id }"

    return parseInt( user.org[0].id ) == parseInt( id )

  super_admin: ( user )->
    sails.log.debug "Authservice super admin"
    sails.log.debug "User #{ JSON.stringify user }"
    sails.log.debug "User #{ JSON.stringify user.super_admin }"
    sails.log.debug "User #{ typeof user.super_admin }"
    return Boolean(user.super_admin)

  check_user: ( user, id ) ->
    sails.log.debug "Authservice/check_user"
    sails.log.debug "result #{ user.id == parseInt( id ) }"
    return user.id == parseInt( id )

}