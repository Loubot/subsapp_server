###*
# UserController
#
# @description :: Server-side logic for managing Users
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###

module.exports = {
  edit_user: (req, res) ->
    sails.log.debug "Hit the User controller/edit_user"      
    sails.log.debug "params #{ JSON.stringify req.body }"
    User.update( id: req.body.id, { firstName: req.body.firstName, lastName: req.body.lastName }).then( (result) ->
      sails.log.debug "User update response #{ JSON.stringify result }"
      # res.status(204)
      res.send result
    ).catch( ( err ) ->
      sails.log.debug "Edit user error #{ JSON.stringify err }"
      res.serverError err
    ).done ->
      sails.log.debug "Edit user done"

  get_user_teams: ( req, res ) ->
    sails.log.debug "Hit the UserController/get_user_teams"
}
