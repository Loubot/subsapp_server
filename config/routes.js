// Generated by CoffeeScript 1.10.0

/**
 * Route Mappings
 * (sails.config.routes)
 *
 * Your routes map URLs to views and controllers.
 *
 * If Sails receives a URL that doesn't match any of the routes below,
 * it will check for matching files (images, scripts, stylesheets, etc.)
 * in your assets directory.  e.g. `http://localhost:1337/images/foo.jpg`
 * might match an image file: `/assets/images/foo.jpg`
 *
 * Finally, if those don't match either, the default 404 handler is triggered.
 * See `api/responses/notFound.js` to adjust your app's 404 logic.
 *
 * Note: Sails doesn't ACTUALLY serve stuff from `assets`-- the default Gruntfile in Sails copies
 * flat files from `assets` to `.tmp/public`.  This allows you to do things like compile LESS or
 * CoffeeScript for the front-end.
 *
 * For more information on configuring custom routes, check out:
 * http://sailsjs.org/#!/documentation/concepts/Routes/RouteTargetSyntax.html
 */
module.exports.routes = {
  '/': {
    view: 'index'
  },
  'post /api/v1/login': {
    controller: 'WebController',
    action: 'login'
  },
  'post /create-business': {
    controller: 'OrgController',
    action: 'create_business'
  },
  'delete /delete-business': {
    controller: 'OrgController',
    action: 'destroy_business'
  },
  'get /get-org': {
    controller: 'OrgController',
    action: 'get_org'
  },
  'get /all-org': {
    controller: 'OrgController',
    action: 'all_org'
  },
  'get /get-org-list': {
    controller: 'OrgController',
    action: 'get_org_list'
  },
  'get /get-single-org': {
    controller: 'OrgController',
    action: 'get_single_org'
  },
  'post /create-team': {
    controller: 'TeamController',
    action: 'create_team'
  },
  'delete /delete-team': {
    controller: 'TeamController',
    action: 'destroy_team'
  },
  'get /get-team': {
    controller: 'TeamController',
    action: 'get_team'
  },
  'post /join-team': {
    controller: 'TeamController',
    action: 'join_team'
  }
};
