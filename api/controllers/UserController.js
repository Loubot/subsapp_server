// Generated by CoffeeScript 1.10.0

/**
 * UserController
 *
 * @description :: Server-side logic for managing Users
 * @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
 */
module.exports = {
  edit_user: function(req, res) {
    sails.log.debug("Hit the User controller/edit_user");
    sails.log.debug("params " + (JSON.stringify(req.body)));
    return User.update(req.body.id, {
      firstName: req.body.firstName,
      lastName: req.body.lastName
    }).then(function(result) {
      sails.log.debug("User update response " + (JSON.stringify(res)));
      return res.send(result);
    })["catch"](function(err) {
      sails.log.debug("Edit user error " + (JSON.stringify(err)));
      return res.send(err);
    }).done(function() {
      return sails.log.debug("Edit user done");
    });
  }
};
