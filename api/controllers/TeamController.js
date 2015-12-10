// Generated by CoffeeScript 1.10.0

/**
 * TeamController
 *
 * @description :: Server-side logic for managing Teams
 * @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
 */
var passport;

passport = require('passport');

module.exports = {
  create_team: function(req, res) {
    var params;
    sails.log.debug("Hit the team controller/create_team ***************");
    sails.log.debug("Data " + (JSON.stringify(req.body)));
    params = req.body;
    return Team.create({
      name: params.name,
      main_org: params.org_id,
      manager: params.user_id
    }).then(function(team) {
      return sails.log.debug("Team create " + (JSON.stringify(team)));
    })["catch"](function(err) {
      return sails.log.debug("Team create error " + (JSON.stringify(err)));
    }).done(function() {
      sails.log.debug("Team create done");
      return Team.find().where({
        main_org: params.org_id
      }).populateAll().exec(function(e, teams) {
        sails.log.debug("Populate result " + (JSON.stringify(teams)));
        sails.log.debug("Populate error " + (JSON.stringify(e)));
        return res.send(teams);
      });
    });
  },
  destroy_team: function(req, res) {
    sails.log.debug("Hit the team controller/destroy_team");
    sails.log.debug("Data " + (JSON.stringify(req.body)));
    return Team.destroy({
      id: req.body.team_id
    }).then(function(team) {
      return sails.log.debug("Team destroy response " + (JSON.stringify(team)));
    })["catch"](function(err) {
      return sails.log.debug("Team destroy error " + (JSON.stringify(err)));
    }).done(function() {
      return sails.log.debug("Team destroy done");
    });
  },
  join_team: function(req, res) {
    sails.log.debug("Hit the team controller/join_team");
    return Team.findOne({
      id: req.body.team_id
    }).then(function(team) {
      sails.log.debug("Find user response " + (JSON.stringify(team)));
      team.team_members.add(req.body.user_id);
      return team.save(function(err, s) {
        sails.log.debug("Add team to team " + (JSON.stringify(s)));
        sails.log.debug("Add team to team err " + (JSON.stringify(err)));
        return res.send(s);
      });
    })["catch"](function(err) {
      return sails.log.debug("Join team find user error " + (JSON.stringify(err)));
    }).done(function() {
      return sails.log.debug("Join team find user done");
    });
  },
  get_team: function(req, res) {
    sails.log.debug("Hit the team controller/get_team");
    return Team.findOne({
      id: req.query.team_id
    }).populate('events').then(function(team) {
      sails.log.debug("Get team response " + (JSON.stringify(team)));
      return res.send(team);
    })["catch"](function(err) {
      return sails.log.debug("Get team error " + (JSON.stringify(err)));
    }).done(function() {
      return sails.log.debug("Team get team main org done");
    });
  },
  get_team_info: function(req, res) {
    sails.log.debug("Hit the team controller/get_team_members");
    sails.log.debug("Hit the team controller/get_team_members " + req.query.team_id);
    return Team.findOne({
      id: req.query.team_id
    }).populate('team_members').populate('events').then(function(mems) {
      sails.log.debug("Get team response " + (JSON.stringify(mems)));
      return res.send(mems);
    })["catch"](function(err) {
      return sails.log.debug("Get team error " + (JSON.stringify(err)));
    }).done(function() {
      return sails.log.debug("Team get team main org done");
    });
  }
};
