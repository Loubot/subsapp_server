###*
# UserController
#
# @description :: Server-side logic for managing Users
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###
moment = require('moment')

module.exports = {

  findOne: ( req, res ) ->
    sails.log.debug "Hit the user controller/findOne"
    sails.log.debug "Params #{ req.param('id') }"
    User.findOne( id: req.param('id') ).populateAll().then( ( user ) ->
      sails.log.debug "Found user #{ JSON.stringify user }"
      
      res.json user
        
      
    ).catch ( err ) ->
      sails.log.debug "Find user error #{ err }"
      res.negotiate err

  update: (req, res) ->
    sails.log.debug "Hit the User controller/update"      
    sails.log.debug "params #{ JSON.stringify req.param('id') }"
    User.update( id: req.param('id'), { firstName: req.body.firstName, lastName: req.body.lastName }).then( (result) ->
      sails.log.debug "User update response #{ JSON.stringify result }"
      # res.status(204)
      res.send result
    ).catch( ( err ) ->
      sails.log.debug "Edit user error #{ JSON.stringify err }"
      res.negotiate err
    ).done ->
      sails.log.debug "Edit user done"



}
