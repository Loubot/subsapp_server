###*
# InviteController
#
# @description :: Server-side logic for managing passwordrest
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###

module.exports = {
    
  
  post_remind: (req, res) ->
    sails.log.debug "Hit Invite controller/post_remind"
    sails.log.debug "params #{ JSON.stringify req.body }"
    Remind.create( 
        user_email: req.body.user_email,
        token: req.body.user_token
      ).then( ( invite ) ->
        sails.log.debug "Invite created #{ JSON.stringify user }"
        MandrillService.send_mail( req.body.user_email )
        res.json user
      ).catch( ( err ) ->
        sails.log.debug "User failure #{ JSON.stringify err }"
        res.serverError "User create failed", JSON.stringify err
      )

  get_invite: (req, res) ->
    sails.log.debug "Hit the invite controller/get_invite"
    Invite.findOne( id: req.query.invite_id ).then( ( invite) ->
      sails.log.debug "Invite found #{ JSON.stringify invite }"
      res.json invite

    ).catch( ( err ) ->
      sails.log.debug "Get invite failure #{ JSON.stringify invite }"
    )

}
