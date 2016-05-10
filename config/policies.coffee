module.exports.policies =
  '*': [ 'isAuthenticated' ]

  AuthController: 
    '*': true

  EventController:
    '*': [ 'isAuthenticated' ]
    'create': [ 'isAuthenticated' ]
    'join_event': [ 'isAuthenticated', 'isCurrentUser' ]
    'get_event_members': [ 'isAuthenticated', 'isCurrentUser' ]
    # 'create_parent_event':

  FileController:
    'upload': true
    'parse_users': [ 'isAuthenticated', 'isSuperAdmin' ]
    'parse_players': [ 'isAuthenticated', 'isSuperAdmin' ]
    'download_file': [ 'isAuthenticated', 'isSuperAdmin' ]

  GCMController:
    '*': [ 'isAuthenticated' ]
    'update': [ 'isAuthenticated' ]

  InviteController:
    '*': true

  LocationController:
    '*': [ 'isAuthenticated' ]
    'create': [ 'isAuthenticated' ]


  MailController:
    '*': true

  OrgController:
    '*': [ 'isAuthenticated', 'isClubAdmin' ]
    'create': [ 'isAuthenticated', 'hasClubFlag']
    'findOne': [ 'isAuthenticated', 'isClubAdmin' ]
    'find': [ 'isAuthenticated', 'isSuperAdmin' ]
    'update': [ 'isAuthenticated', 'isClubAdmin' ]
    'withdraw': [ 'isAuthenticated', 'isClubAdmin']

  ParentController:
    'associate_kids': [ 'isAuthenticated', 'isCurrentUser' ]

    'parents_with_events': [ 'isAuthenticated', 'isCurrentUser' ]
    'social': [ 'isAuthenticated', 'isCurrentUser' ]
    'financial': [ 'isAuthenticated', 'isCurrentUser' ]
    'kids_with_parents': [ 'isAuthenticated', 'isCurrentUser' ]

  PasswordReminderController: 
    '*': true

  PaymentController: 
    '*': [ 'isAuthenticated' ]

  TeamController: 
    '*': [ 'isAuthenticated' ]
    'findOne': [ 'isAuthenticated', 'isTeamAdmin' ]
    'update': [ 'isAuthenticated', 'isTeamAdmin' ]
    'org_members': [ 'isAuthenticated', 'isTeamAdmin' ]
    'get_team_info': [ 'isAuthenticated', 'isTeamAdmin' ]
    'org_locations': [ 'isAuthenticated', 'isTeamAdmin' ]

  TokenController: 
    '*': [ 'isAuthenticated' ]

  TokenTransactionController: 
    '*': [ 'isAuthenticated' ]


  UserController:
    'findOne': [ 'isAuthenticated', 'isCurrentUser' ]
    'update':  [ 'isAuthenticated', 'isCurrentUser' ]



# ---
# generated by js2coffee 2.1.0