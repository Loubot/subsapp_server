module.exports = {

  check_club_admin: ( user, id ) -> # Make sure session user is the admin of this club
    sails.log.debug "Authservice check_club_admin"
    sails.log.debug "Params #{ JSON.stringify user } #{ id }"

    return parseInt( user.orgs[0].id ) == parseInt( id )

}