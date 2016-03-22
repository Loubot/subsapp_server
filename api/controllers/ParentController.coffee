##
# ParentController
#
# @description :: Server-side logic for managing Parents
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
##
Promise = require('bluebird')

module.exports = {
  associate_kids: ( req, res ) ->
    sails.log.debug "ParentController/associate_kids"
    sails.log.debug "Params #{ req.param('id') }"
    assocations = Promise.promisifyAll( AssociationService )
    assocations.associate_kidsAsync( req.user ).then( ( parent ) ->
      sails.log.debug "Parent assocaition #{ JSON.stringify parent }"
      res.json parent
    ).catch( ( parent_err ) ->
      sails.log.debug "Parent associate err #{ JSON.stringify parent_err }"
      res.negotiate parent_err
    )

}