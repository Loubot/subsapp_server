###*
# Route Mappings
# (sails.config.routes)
#
# Your routes map URLs to views and controllers.
#
# If Sails receives a URL that doesn't match any of the routes below,
# it will check for matching files (images, scripts, stylesheets, etc.)
# in your assets directory.  e.g. `http://localhost:1337/images/foo.jpg`
# might match an image file: `/assets/images/foo.jpg`
#
# Finally, if those don't match either, the default 404 handler is triggered.
# See `api/responses/notFound.js` to adjust your app's 404 logic.
#
# Note: Sails doesn't ACTUALLY serve stuff from `assets`-- the default Gruntfile in Sails copies
# flat files from `assets` to `.tmp/public`.  This allows you to do things like compile LESS or
# CoffeeScript for the front-end.
#
# For more information on configuring custom routes, check out:
# http://sailsjs.org/#!/documentation/concepts/Routes/RouteTargetSyntax.html
###

module.exports.routes = 

   # 'post /auth/signup' :
   #      controller :            'AuthController'  #requires team_id. Adds new user as team_admin of club_id
   #      action :                 'signup'

  'post /auth/signup/team_manager' :
        controller :            'AuthController'  #requires team_id. Adds new user as team_admin of club_id
        action :                 'team_manager_signup'
        
  '/': view: 'index'
  'post /api/v1/login' :
        controller :            'WebController'
        action :                'login'

  # User controller   update user attributes. See user.coffee
  'post /user/edit' :
        controller:             'UserController'
        action:                 'edit_user'

  'get /get-user-teams':
        controller:             'UserController'
        action:                 'get_user_teams'


  # End of user controller

  # Business controller

  'post /create_business' : # Create new org. See org.coffee for attributes
        controller:             'OrgController'
        action:                 'create_business'

  'delete /delete-business' : #Destroy org. Requires org.id
        controller:             'OrgController'
        action:                 'destroy_business'

  'get /get-org':             #Require org.id. Returns details of org
        controller:             'OrgController'
        action:                 'get_org'

  'get /all-org':             #Requires nothing. Return all org details;
        controller:             'OrgController'
        action:                 'all_org'

  'get /org-admins':          #Requires org.id. Returns org, admins and teams of org
        controller:             'OrgController'
        action:                 'get_org_admins'

  # end of org controller

  # Team controller
  
  'post /create-team' :       #Requires name, main_org id, user_id. 
        controller:             'TeamController'
        action:                 'create_team'

  'delete /delete-team' :     #Requires id. Destroys team
        controller:             'TeamController'
        action:                 'destroy_team'

  'get /get-team' :           #Requires team id. Returns team with events and main org.
        controller:             'TeamController'
        action:                 'get_team'

  'post /join-team':          #Requires team id and user id. Adds user to list of teams members.          
        controller:             'TeamController'
        action:                 'join_team'

  'get /get-team-info':       #Requires team id. Returns team members and events
        controller:             'TeamController'
        action:                 'get_team_info'

  # end of Team controller

  # PaymentController
  'post /create-payment':     #Requires stripe token user id. Creates charge reduces users tokens amount. Returns user tokens amount
        controller:             'PaymentController'
        action:                 'create_payment'

  #End of PaymentController

  #Token TeamController     #
  'post /up-token':
        controller:             'TokenController'
        action:                 'up_token'

  # end of Token controller

  # Event controller
  'post /create-event':       #Creates event. See Event.coffee for attributes
        controller:             'EventController'
        action:                 'create_event'

  'post /join-event':         #Requires event id and user id. Add event to user events 
        controller:             'EventController'
        action:                 'join_event'

  'get /get-event-members':   #Requires event id. Returns event with event users.
        controller:             'EventController'
        action:                 'get_event_members'

  # end of Event controller

  #Invite controller

  'post /invite-manager':
        controller:             'InviteController'
        action:                 'invite_manager'

  'get /get-invite':
        controller:             'InviteController'
        action:                 'get_invite'

  #Password reminder routes

  'get /':
        controller:             'PasswordReminderController'
        action:                 'get_remind'

  'post /':
        controller:             'PasswordReminderController'
        action:                 'post_remind'

   'get /reset/{token}':
        controller:             'PasswordReminderController'
        action:                 'get_reset'

  'post /reset':
        controller:             'PasswordReminderController'
        action:                 'post_reset'


  # #Mail controller

  # 'post /send-mail':          #
  #       controller:             'MailController'
  #       action:                 'send_mail'