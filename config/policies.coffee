module.exports.policies =
  '*': [ 'isAuthenticated' ]
  AuthController: '*': true
  WebController: '*': true
  InviteController: '*': true
  PasswordReminderController: '*': true
  # BusinessController: '*': true

# ---
# generated by js2coffee 2.1.0