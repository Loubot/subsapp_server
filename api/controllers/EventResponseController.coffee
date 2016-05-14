###*
# EventResponseController
#
# @description :: Server-side logic for managing EventResponses
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###

Promise = require('bluebird')
module.exports = {
  find: ( req, res ) ->
    sails.log.debug "Hit the EventResponseController/findOne"
    sails.log.debug "Params #{ JSON.stringify req.param('id') }"
    if AuthService.check_user( req.user, req.param('id') )
      EventResponse.find( user_id: req.param('id') ).then( ( e_response ) ->
        res.json e_response

      ).catch ( err ) ->
        sails.log.debug "Find EventResponse error #{ JSON.stringify err }"
        res.negotiate err
    else
      res.unauthorized "You are not authorised to view this"


  


  pay: ( req, res ) ->
    sails.log.debug "Hit the EventResponseController/pay"
    sails.log.debug "Params #{ JSON.stringify req.body }"


    User.findOne( id: req.body.parent_id ).populate('tokens').then( ( parent ) ->
      sails.log.debug "Found parent #{ JSON.stringify parent.tokens[0].amount }"
      sails.log.debug "Amount #{ parseInt(req.body.token_amount) }"

      tokenBalanceAfterTransaction = parseInt(parent.tokens[0].amount) - parseInt(req.body.token_amount)
      parentHasEnoughTokens = false
      if tokenBalanceAfterTransaction >= 0
        parentHasEnoughTokens = true     

      if parentHasEnoughTokens
        EventResponse.create( 
          event_id: req.body.event_id
          user_id: req.body.user_id
          parent_id: req.body.parent_id
          token_amount: req.body.token_amount
          paid: true
          declined: false
          team_id: req.body.team_id
        ).then( ( e_response ) ->
          sails.log.debug "EventResponse create/event pay #{ JSON.stringify e_response }"
          parent.tokens[0].amount = tokenBalanceAfterTransaction
          sails.log.debug "new amount #{ parent.tokens[0].amount }"

          User.findOne( req.body.user_id ).populate('user_events').then( ( kid ) ->
            sails.log.debug "Found kid #{ JSON.stringify kid }"
            kid.user_events.add( req.body.event_id )
            Promise.all([
              kid.save()
              parent.tokens[0].save()
            ]).spread( ( kid_saved, saved_parent ) ->
              sails.log.debug "Kid saved #{ JSON.stringify kid_saved }"
              sails.log.debug "Saved parent #{ JSON.stringify saved_parent }"
              OrgTokenService.add_tokens( req.body.token_amount, req.body.team_id ) # Update the orgs token amaount
              res.json e_response
            ).catch( ( kid_parent_save_err ) ->
              sails.log.debug "Kid and parent save err #{ JSON.stringify kid_parent_save_err }"
              res.negotiate kid_parent_save_err
            )
          ).catch( ( kid_err ) ->
            sails.log.debug "Find kid err #{ JSON.stringify kid_err }"
            res.negotiate kid_err
          )

        ).catch ( e_response_err ) ->
          sails.log.debug "EventResponse create error/event pay #{ JSON.stringify e_response_err }"
          res.negotiate e_response_err

      else
        res.negotiate "You don't have enough tokens. Please top up."
        
      
    ).catch ( err ) ->
      sails.log.debug "Find parent error #{ JSON.stringify err }"
      res.negotiate err

  decline: ( req, res ) ->
    sails.log.debug "Hit the EventResponseController/decline"
    sails.log.debug "Params #{ JSON.stringify req.body }"

    EventResponse.create( 
      event_id: req.body.event_id
      user_id: req.body.user_id
      parent_id: req.body.parent_id
      token_amount: req.body.token_amount
      paid: false
      declined: true
      team_id: req.body.team_id
    ).then( ( e_response ) ->
      sails.log.debug "EventResponse create/event decline #{ JSON.stringify e_response }"
      
      
      res.json e_response
    ).catch ( e_response_err ) ->
      sails.log.debug "EventResponse create error/event decline #{ JSON.stringify e_response_err }"
      res.negotiate e_response_err

    
      
      
    
  update: ( req, res ) ->
    sails.log.debug "Hit the EventResponseController/update"
    sails.log.debug "Params #{ JSON.stringify req.body }"

    EventResponse.update(
      { id: req.body.id } 
      req.body
    ).then( ( e_response ) ->
      sails.log.debug "EventResponse create/event update #{ JSON.stringify e_response }"
      
      
      res.json e_response
    ).catch ( e_response_err ) ->
      sails.log.debug "EventResponse create error/event update #{ JSON.stringify e_response_err }"
      res.negotiate e_response_err

  

}