module.exports.policies =
  '*': [ 'isAuthenticated' ]

  AuthController: 
    '*': true

  EventController:
    'create': [ 'isAuthenticated', 'isClubAdmin' ]


  UserController:
    'findOne': [ 'isAuthenticated', 'isCurrentUser' ]

  ParentController:
    'associate_kids': [ 'isAuthenticated', 'isCurrentUser' ]

    'parents_with_events': [ 'isAuthenticated', 'isCurrentUser' ]
    'financial': [ 'isAuthenticated', 'isCurrentUser' ]
    'kids_with_parents': [ 'isAuthenticated', 'isCurrentUser' ]

  OrgController:
    '*': [ 'isAuthenticated', 'isClubAdmin' ]
    'find': [ 'isAuthenticated', 'isSuperAdmin' ]
    'get_org_admins': [ 'isAuthenticated', 'isSuperAdmin' ]



  
  WebController: 
    '*': true
  InviteController: 
    '*': true
  FileController: 
    '*': true
  PasswordReminderController: 
    '*': true
  # BusinessController: '*': true

# ---
# generated by js2coffee 2.1.0