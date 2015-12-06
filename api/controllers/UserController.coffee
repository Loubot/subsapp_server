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
    User.update( req.body.id, firstName: req.body.firstName, lastName: req.body.lastName).then( (result) ->
      sails.log.debug "User update response #{ JSON.stringify res }"
      # res.status(204)
      res.send result
    ).catch( ( err ) ->
      sails.log.debug "Edit user error #{ JSON.stringify err }"
      res.send err
    ).done ->
      sails.log.debug "Edit user done"
}
