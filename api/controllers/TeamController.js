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
    sails.log.debug("Hit the team controller/create_team ***************");
    sails.log.debug("Data " + (JSON.stringify(req.body)));
    return Team.create({
      name: req.body.name,
      main_org: req.body.org_id,
      manager: req.body.user_id
    }).then(function(team) {
      sails.log.debug("Team created " + (JSON.stringify(team)));
      return Org.findOne({
        id: req.body.org_id
      }).populate('teams').exec(function(err, org) {
        if (err != null) {
          sails.log.debug("Org find error " + (JSON.stringify(err)));
        }
        sails.log.debug("Org find  " + (JSON.stringify(org)));
        return res.json({
          org: org,
          message: 'Team created ok'
        });
      });
    })["catch"](function(err) {
      sails.log.debug("Team create error " + (JSON.stringify(err)));
      return res.serverError(err);
    });
  },
  destroy_team: function(req, res) {
    sails.log.debug("Hit the team controller/destroy_team");
    sails.log.debug("Data " + (JSON.stringify(req.body)));
    return Team.destroy({
      id: req.body.team_id
    }).then(function(team) {
      return sails.log.debug("Team destroy response " + (JSON.stringify(team)));
    }).then(Org.findOne({
      id: req.body.org_id
    }).populate('teams').exec(function(err, org) {
      if (err != null) {
        sails.log.debug("Failed to find org " + (JSON.stringify(err)));
      }
      sails.log.debug("Org found " + (JSON.stringify(org)));
      return res.json(org);
    }))["catch"](function(err) {
      sails.log.debug("Team destroy error " + (JSON.stringify(err)));
      return res.serverError(err);
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
        return res.json(s);
      });
    })["catch"](function(err) {
      sails.log.debug("Join team find user error " + (JSON.stringify(err)));
      return res.serverError(err);
    }).done(function() {
      return sails.log.debug("Join team find user done");
    });
  },
  get_team: function(req, res) {
    sails.log.debug("Hit the team controller/get_team");
    return Team.findOne({
      id: req.query.team_id
    }).populate('events').populate('main_org').populate('manager').then(function(team) {
      sails.log.debug("Get team response " + (JSON.stringify(team)));
      return res.json(team);
    })["catch"](function(err) {
      sails.log.debug("Get team error " + (JSON.stringify(err)));
      return res.serverError(err);
    }).done(function() {
      return sails.log.debug("Team get team main org done");
    });
  },
  get_teams: function(req, res) {
    sails.log.debug("Hit the team conroller/get_teams");
    return Org.findOne({
      id: req.query.org_id
    }).populate('teams').then(function(org_and_teams) {
      sails.log.debug("Org and teams " + (JSON.stringify(org_and_teams)));
      return res.json(org_and_teams);
    })["catch"](function(err) {
      sails.log.debug("Get org and teams error");
      return res.serverError(err);
    });
  },
  get_team_info: function(req, res) {
    sails.log.debug("Hit the team controller/get_team_members");
    sails.log.debug("Hit the team controller/get_team_members " + req.query.team_id);
    return Team.findOne({
      id: req.query.team_id
    }).populate('team_members').populate('events').populate('main_org').then(function(mems) {
      sails.log.debug("Get team response " + (JSON.stringify(mems)));
      return res.json(mems);
    })["catch"](function(err) {
      sails.log.debug("Get team error " + (JSON.stringify(err)));
      return res.serverError(err);
    }).done(function() {
      return sails.log.debug("Team get team main org done");
    });
  }
};
