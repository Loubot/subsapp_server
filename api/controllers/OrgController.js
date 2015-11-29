// Generated by CoffeeScript 1.10.0

/**
 * UserController
 *
 * @description :: Server-side logic for managing Business
 * @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
 */
var passport;

passport = require('passport');

module.exports = {
  get_business: function(req, res) {
    sails.log.debug("Hit the business controller/get_business &&&&&&&&&&&&&&&&&&&&&&&&&&&");
    sails.log.debug("Data " + (JSON.stringify(req.query.org_id)));
    return Org.find({
      id: req.query.org_id
    }).then(function(org) {
      sails.log.debug("Find response " + (JSON.stringify(org)));
      res.send(org[0]);
    })["catch"](function(err) {
      return sails.log.debug("Find error response " + (JSON.stringify(err)));
    }).done(function() {
      sails.log.debug("Find done");
    });
  },
  create_business: function(req, res) {
    var business_data;
    sails.log.debug("Hit the business controller/create_business &&&&&&&&&&&&&&&&&&&&&&&&&&&");
    sails.log.debug("Data " + (JSON.stringify(req.body)));
    business_data = req.body;
    return Org.create({
      name: business_data.name,
      address: business_data.address
    }).then(function(org) {
      sails.log.debug("Create response " + (JSON.stringify(org)));
      org.admins.add(business_data.user_id);
      org.save(function(err, s) {
        sails.log.debug("saved " + (JSON.stringify(s)));
        return User.find().where({
          id: business_data.user_id
        }).populateAll().exec(function(e, r) {
          sails.log.debug("Populate result " + (JSON.stringify(r[0].orgs)));
          return res.send(r[0].orgs);
        });
      });
    })["catch"](function(err) {
      return sails.log.debug("Create error response " + (JSON.stringify(err)));
    }).done(function() {
      sails.log.debug("Create done");
    });
  },
  destroy_business: function(req, res) {
    sails.log.debug("Hit delete method");
    sails.log.debug("Hit delete method " + req.body.org_id);
    return Org.destroy({
      id: req.body.org_id
    }).then(function(org) {
      sails.log.debug("Delete response " + (JSON.stringify(org)));
    })["catch"](function(err) {
      return sails.log.debug("Create error response " + (JSON.stringify(err)));
    }).done(function() {
      sails.log.debug("Create done");
    });
  }
};
