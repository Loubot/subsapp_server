module.exports.policies =
  # '*': [ 'isAuthenticated' ]

  OrgController:
    '*': ['isAuthenticated', 'isClubAdmin']

  AuthController: 
    '*': true
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