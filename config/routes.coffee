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

  'post /auth/signin':
        controller:            'AuthController'
        action:                'signin'

  'post /auth/signup':
        controller:            'AuthController'
        action:                'signup'

  'post /auth/parent-signup':
        controller:            'AuthController'
        action:                'parent_sign_up'

  'post /auth/signup/team_manager' :
        controller :            'AuthController'  #requires team_id. Adds new user as team_admin of club_id
        action :                'team_manager_signup'
        
  '/': view: 'index'
  # 'post /api/v1/login' :
  #       controller :            'WebController'
  #       action :                'login'

  # User controller   update user attributes. See user.coffee

  'get /user/:id':
        controller:             'UserController'
        action:                 'findOne'

  'post /user/edit/:id' :
        controller:             'UserController'
        action:                 'update'

  # 'get /get-user-teams':
  #       controller:             'UserController'
  #       action:                 'get_user_teams'

  # 'get /user/pick-kids':
  #       controller:             'UserController'
  #       action:                 'pick_kids'


  # End of user controller

  #Parent controller. Basically a user controller
  'post /parent/associate-kids':
        controller:             'ParentController'
        action:                 'associate_kids'

  'get /parent/parents-with-events/:id':
        controller:             'ParentController'
        action:                 'parents_with_events'

  'get /parent/social/:id':
        controller:             'ParentController'
        action:                 'social'

  'get /parent/financial/:id':
        controller:             'ParentController'
        action:                 'financial'

  'get /parent/kids-with-parents':
        controller:             'ParentController'
        action:                 'kids_with_parents'
  
  'get /parent/token_payments/:id':
        controller:             'ParentController'
        action:                 'token_payments'
  
  # End of Parent controller

  # ORG controller

  'post /org' : # Create new org. See org.coffee for attributes
        controller:             'OrgController'
        action:                 'create'

  'delete /delete-business/:id' : #Destroy org. Requires org.id
        controller:             'OrgController'
        action:                 'destroy_business'

  'get /org/:id':           
        controller:             'OrgController'
        action:                 'findOne'

  'get /orgs': 
        controller:             'OrgController'
        action:                 'find'

  'get /org/s3-info/:id':
        controller:              'OrgController'
        action:                  's3_info'

  'get /org/get-org-team-members/:id':             #Require. Returns details of org. !Must be admin!
        controller:             'OrgController'
        action:                 'get_org_team_members'

  'get /org/org-admins/:id':          #Requires org.id. Returns org, admins and teams of org
        controller:             'OrgController'
        action:                 'get_org_admins'

  'get /org/teams-and-mangers/:id':
        controller:             'OrgController'
        action:                 'get_teams_and_managers'

  'post /org/withdraw/:id':
        controller:             'OrgController'
        action:                 'withdraw'

  # end of org controller

  # Location Controller
  'post /location':
        controller:             'LocationController'
        action:                 'create'

  'get /locations':
        controller:             'LocationController'
        action:                 'index'
  #End of Location Controller

  # Team controller

  'get /team/:id':
        controller:             'TeamController'
        action:                 'findOne'

  'post /team/update/:id':
        controller:             'TeamController'
        action:                 'update'
  
  'post /team' :       #Requires name, main_org id, user_id. 
        controller:             'TeamController'
        action:                 'create'

  # `'delete /team' :     #Requires id. Destroys team
  #       controller:             'TeamController'
  #       action:                 'destroy_team'


  'post /join-team':          #Requires team id and user id. Adds user to list of teams members.          
        controller:             'TeamController'
        action:                 'join_team'

  'get /team/get-team-info/:id':       #Requires team id. Returns team members and events
        controller:             'TeamController'
        action:                 'get_team_info'

  'get /team/get-players-by-year/:id':
        controller:             'TeamController'
        action:                 'get_players_by_year'

  'post /team/update-members/:id':     #Requires team id in url and takes array of members ids. Updates team members to the new array. (Old associations destroyed)
        controller:              'TeamController'
        action:                  'update_members'

  'get /team/org-members/:id':
        controller:              'TeamController'
        action:                  'org_members'

  'get /team/:id/teams-events':
        controller:              'TeamController'
        action:                  'teams_events'

  # end of Team controller

  # PaymentController
  'post /create-payment':     #Requires stripe token user id, amount. Creates charge reduces users tokens amount. Returns user tokens amount
        controller:             'PaymentController'
        action:                 'create_payment'

  'get /payment/get-transactions/:id':
        controller:             'PaymentController'
        action:                 'get_transactions'

  #End of PaymentController

  #Token TeamController     #
  'post /up-token':
        controller:             'TokenController'
        action:                 'up_token'

  'post /payment/:id/authenticate-stripe':
        controller:             'PaymentController'
        action:                 'authenticate_stripe'

  # end of Token controller

  # Event controller
  'get /event/:id':
        controller:             'EventController'
        action:                 'findOne'

  "post /event/create-event-with-ids":
        controller:             'EventController'
        action:                 'create_with_player_ids'

  'post /event/:id':
        controller:             'EventController'
        action:                 'update'

  'post /event':       #Creates event. See Event.coffee for attributes
        controller:             'EventController'
        action:                 'create'

  'post /event/create-multi-event':
        controller:             'EventController'
        action:                 'create_multi_event'

  'post /join-event':         #Requires event id and user id. Add event to user events 
        controller:             'EventController'
        action:                 'join_event'

  'get /get-event-members':   #Requires event id. Returns event with event users.
        controller:             'EventController'
        action:                 'get_event_members'

    # parent events
    'post /event/parent/create-event':
        controller:             'EventController'
        action:                 'create_parent_event'

  # end of Event controller

  #Invite controller

  'post /invite-manager':
        controller:             'InviteController'
        action:                 'invite_manager'

  'get /get-invite':
        controller:             'InviteController'
        action:                 'get_invite'


  # File controller

  'post /file/upload':
        controller:             'FileController'
        action:                 'upload'

  'get /parse-users':
        controller:             'FileController'
        action:                 'parse_users'

  'post /file/parse-players':
        controller:             'FileController'
        action:                 'parse_players'

  'get /download-file':
        controller:             'FileController'
        action:                 'download_file'

  # End of file controller

  #Password reminder routes

  # 'get /get_remind':
  #       controller:             'PasswordReminderController'
  #       action:                 'get_remind'

  'post /post_remind':
        controller:             'PasswordReminderController'
        action:                 'post_remind'

  # 'get /reset/{reminder_token}':
  #       controller:             'PasswordReminderController'
  #       action:                 'get_reset'

  # 'post /reset':
  #       controller:             'PasswordReminderController'
  #       action:                 'post_reset'

  #TokenTransaction controller
  'get /eventresponse/:id':
        controller:             'EventResponseController'
        action:                 'find'

  'post /eventresponse/pay':
        controller:              'EventResponseController'
        action:                  'pay'

  'post /eventresponse/decline':
        controller:              'EventResponseController'
        action:                  'decline'

  'patch /eventresponse/update':
        controller:              'EventResponseController'
        action:                  'update'

  'get /eventresponse/:id/get-attendees-by-event-response':
        controller:               'EventResponseController'
        action:                   'get_attendees_by_event_response'

  #End of TokenTransactionController

  #GCMController
  'post /gcm/tokens/:id':    #Requires device_uid, instance_id, gcm_token. Optional: alerts, event_notifications, club_notifications. See GCMReg.coffee
        controller:             'GCMController'
        action:                 'create_token'

  'post /gcm/send-message':
        controller:              'GCMController'
        action:                  'send_message'

  'put /gcm':                #Find or create. Requires user_id, instance_id, device_uid, gcm_token. Updates or creates gcm token. Returns gcm model
        controller:              'GCMController'
        action:                  'update'


  # End of GCMController

  #Test controller

  'get /test':
        controller:             'TestController'
        action:                 'test'


  # #Mail controller

  # 'post /send-mail':          #
  #       controller:             'MailController'
  #       action:                 'send_mail'
