###*
# InviteController
#
# @description :: Server-side logic for managing invites
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###

module.exports = {
    
  
  invite_manager: (req, res) ->
    sails.log.debug "Hit Invite controller/invite_manager"
    sails.log.debug "params #{ JSON.stringify req.body }"
    Invite.create( 
        org_id: req.body.org_id, team_id: req.body.team_id,
        club_admin: req.body.club_admin, club_admin_email: req.body.club_admin_email,
        invited_email: req.body.invited_email, main_org_name: req.body.main_org_name,
        team_name: req.body.team_name
      ).then( ( invite ) ->
        sails.log.debug "Invite created #{ JSON.stringify invite }"
        MandrillService.send_mail( invite.id, req.body.invited_email )
        res.json invite
      ).catch( ( err ) ->
        sails.log.debug "Invite failure #{ JSON.stringify err }"
        res.negotiate "Invite create failed", JSON.stringify err
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
