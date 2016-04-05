###*
# GCMController
#
# @description :: Server-side logic for managing GCM messages
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###
gcm = require('node-gcm')

module.exports = {

  create_token: ( req, res )->
    sails.log.debug "Hit the GCMController/creat_token"
    sails.log.debug "User id #{ req.param('id') }"
    sails.log.debug "params #{ JSON.stringify req.body }"

    GCMReg.create(
      user_id: req.param('id')
      device_uid: req.body.device_uid
      instance_id: req.body.instance_id
      gcm_token: req.body.gcm_token
      alerts: req.body.alerts
      event_notifications: req.body.event_notifications
      club_notifications: req.body.club_notifications
    ).then( ( gcm ) ->
      sails.log.debug "GCM created #{ JSON.stringify gcm }"
      res.json gcm
    ).catch( ( gcm_err ) ->
      sails.log.debug "GCM error #{ JSON.stringify gcm_err }"
      res.negotiate gcm_err
    )

  send_message: ( req, res ) ->
    sails.log.debug "Hit the GCMController/send_message"
    
    message = new (gcm.Message)
    
    message.addNotification
      title: 'Alert!!!'
      body: 'Abnormal data access'
      icon: 'ic_launcher'

    sender = new gcm.Sender( sails.config.GCM.server_key )

    sender.send message, { registrationTokens: ['dVcOOkUoAJU:APA91bFTCws0FrkYc1QZentSG42pYkXGaIncdVruDwDtO3H6q1lB-zMoJWf_T_MzbXLvMCkJzhpC3HyqkHZiikdlJcZXiHL0d5Uo_PJI2L49W35LZLhEtLl06nOI_CRamfVhAtR0u1nT'] }, (err, response) ->
      if err?
        sails.log.debug "GCM err #{ JSON.stringify err }"
        res.negotiate err
      else
        sails.log.debug "GCM response #{ JSON.stringify response }"
        res.json response
      return

  update: ( req, res ) ->
    sails.log.debug "Hit the TokenTransactionController/update"
    sails.log.debug "Params #{ JSON.stringify req.body }"
    GCMReg.findOrCreate( 
      { user_id: req.body.user_id, device_uid: req.body.device_uid }
      user_id: req.body.user_id
      device_uid: req.body.device_uid
      instance_id: req.body.instance_id
      gcm_token: req.body.gcm_token
    ).then( ( gcm ) ->
      sails.log.debug "GCM updated #{ JSON.stringify gcm }"
      res.json gcm
    ).catch( ( gcm_find_err ) ->
      sails.log.debug "GCM find err #{ JSON.stringify gcm_find_err }"
      res.negotiate gcm_find_err
    )
}