###*
# InviteController
#
# @description :: Server-side logic for managing passwordReminder
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###

module.exports = {
    
  
  post_remind: (req, res) ->
    sails.log.debug "Hit PasswordReminder controller/post_remind"
    sails.log.debug "params #{ JSON.stringify req.body }"

    User.findOne( email: req.body.user_email ).then( ( user ) ->
      sails.log.debug "Found user #{ JSON.stringify user }"

      if user?
        reminderToken = makePasswordReminderToken()
        PasswordReminder.create( email: req.body.user_email, remind_password_token: reminderToken ).exec ( ( err, password ) ->  
          sails.log.debug "User exists #{JSON.stringify user}"
          res.json user: user, message: 'User already exists'
          sails.log.debug "Password reminder created #{ JSON.stringify password }"
          MandrillService.password_remind(reminderToken, user.email )
        )  
      else
          sails.log.debug "Password reminder Not created #{ JSON.stringify password }"
          sails.log.debug "Password reminder err #{ JSON.stringify err }" if err?
          res.json user: user, message: 'No user in database exists'
        

    )

    makePasswordReminderToken = ->
      text = ''
      possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
      i = 0
      while i < 60
        text += possible.charAt(Math.floor(Math.random() * possible.length))
        i++
      text


  

    # get_reset: (reminder_token, res) ->
    #   sails.log.debug "Hit the GET PasswordReset controller/get_reset'"
    #   PasswordReminder.findOne( remind_password_token: reminder_token ).then( ( passwordReminder ) ->
    #     sails.log.debug "Password Reminder found #{ JSON.stringify passwordReminder }"
    #     res.json passwordReminder

    #     ).catch( ( err ) ->
    #       sails.log.debug "Get PasswordReminder failure #{ JSON.stringify passwordReminder }"
    #   )


    # post_reset: (req, res) ->
    # sails.log.debug "Hit PasswordReminder controller/post_reset"
    # sails.log.debug "params #{ JSON.stringify req.body }"

    # PasswordReminder.findOne( remind_password_token: req.body.reminder_token ).then( ( passwordReminder ) ->
    #   sails.log.debug "Found user #{ JSON.stringify passwordReminder }"
    
    #   User.findOne( email: passwordReminder.email ).then( ( user ) ->
    #     sails.log.debug "Found user #{ JSON.stringify user }"

    #     if user?
    #       User.Update( password:req.body.password).exec ( ( err, password ) ->  
    #         sails.log.debug "User exists #{JSON.stringify user}"
    #         res.json user: user, message: 'User is Updated'
    #         sails.log.debug "Password reminder created #{ JSON.stringify password }"
           
    #       )  
    #     else
    #         sails.log.debug "User Not Updated #{ JSON.stringify user }"
    #         sails.log.debug "User Update err #{ JSON.stringify err }" if err?
    #         res.json user: user, message: 'No user in database exists'
        
    #   )
    # )

  }



    # PasswordReminder.create( 
    #     email: req.body.user_email,

    #   ).then( ( password ) ->
        
    #     if(password?)
    #       sails.log.debug "Password Reminder created #{ JSON.stringify password }"
    #       MandrillService.send_mail( req.body.user_email )
    #       res.json password
    #     else
    #       res.negotiate "Incorrect Email"

        

    #     # if (user.findOne(user_email)){
    #     #   sails.log.debug "Password Reminder created #{ JSON.stringify user }"
    #     #   MandrillService.send_mail( req.body.user_email )
    #     #   res.json user
    #     # }
    #     # else{
    #     #   window.location.href("http://localhost:1337/#/password/remind");
    #     # }
    #   ).catch( ( err ) ->
    #     sails.log.debug "User failure #{ JSON.stringify err }"
    #     #sails.log.debug "User failure #{ JSON.stringify user }"
    #     res.negotiate "Password Reminder create failed", JSON.stringify err
    #   )

  # get_invite: (req, res) ->
  #   sails.log.debug "Hit the invite controller/get_invite"
  #   Invite.findOne( id: req.query.invite_id ).then( ( invite) ->
  #     sails.log.debug "Invite found #{ JSON.stringify invite }"
  #     res.json invite

  #   ).catch( ( err ) ->
  #     sails.log.debug "Get invite failure #{ JSON.stringify invite }"
  #   )




