###*
# EventResponseController
#
# @description :: Server-side logic for managing EventResponses
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###


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

          OrgTokenService.add_tokens( req.body.token_amount, req.body.team_id ) # Update the orgs token amaount

          parent.tokens[0].save ( saved_parent_error, saved_parent ) ->
            sails.log.debug "Saved parent #{ JSON.stringify saved_parent }"
            sails.log.debug "Saved parent saved_parent_error #{ JSON.stringify saved_parent_error }" if saved_parent_error?
            res.json e_response
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