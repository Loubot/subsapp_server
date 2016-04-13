###*
# TokenTransactionController
#
# @description :: Server-side logic for managing TokenTransactions
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###


module.exports = {
  find: ( req, res ) ->
    sails.log.debug "Hit the TokenTransactionController/findOne"
    sails.log.debug "Params #{ JSON.stringify req.param('id') }"
    if AuthService.check_user( req.user, req.param('id') )
      TokenTransaction.find( user_id: req.param('id') ).then( ( ttransaction ) ->
        res.json ttransaction

      ).catch ( err ) ->
        sails.log.debug "Find TokenTransaction error #{ JSON.stringify err }"
        res.serverError err
    else
      res.unauthorized "You are not authorised to view this"


  


  pay: ( req, res ) ->
    
    sails.log.debug "Hit the TokenTransactionController/pay"
    sails.log.debug "Params #{ JSON.stringify req.body }"
    
    User.findOne( id: req.body.parent_id ).populate('tokens').then( ( parent ) ->
      sails.log.debug "Found parent #{ JSON.stringify parent }"
      sails.log.debug "Amount #{ parseInt(req.body.token_amount) }"

      tokenBalanceAfterTransaction = parseInt( parent.tokens[0].amount ) - parseInt( req.body.token_amount )

      parentHasEnoughTokens = false
      eventHasBeenDeclined = false
      if tokenBalanceAfterTransaction >= 0
        sails.log.debug "1"
        parentHasEnoughTokens = true
      declinedString = req.body.declined
      if declinedString
        sails.log.debug "2"
        eventHasBeenDeclined = true
      if eventHasBeenDeclined
        sails.log.debug "3"

        TokenTransaction.updateOrCreate( 
          { id: req.body.id } 
          event_id: req.body.event_id
          user_id: req.body.user_id
          parent_id: req.body.parent_id
          token_amount: req.body.token_amount
          paid: false
          declined: true
          team_id: req.body.team_id
        ( err, ttransaction ) ->
          if err?
            sails.log.debug 'TokenTransaction create error/event pay ' + JSON.stringify(ttransaction_err)
            res.serverError ttransaction_err
          else
            sails.log.debug "ttransaction updateOrCreate #{ JSON.stringify ttransaction }"
            res.json ttransaction
        )
        

      else if parentHasEnoughTokens
        sails.log.debug "4"
        TokenTransaction.updateOrCreate(
          { id: req.body.id }
          event_id: req.body.event_id
          user_id: req.body.user_id
          parent_id: req.body.parent_id
          token_amount: req.body.token_amount
          paid: true
          declined: false
          team_id: req.body.team_id
          ( err, ttransaction ) ->
            if err?
              sails.log.debug "TokenTransaction create error/event pay #{ JSON.stringify ttransaction_err }"
              res.serverError ttransaction_err
            else
             sails.log.debug "TokenTransaction create/event pay #{ JSON.stringify ttransaction }"
             parent.tokens[0].amount = tokenBalanceAfterTransaction
             sails.log.debug "new amount #{ parent.tokens[0].amount }"
             parent.tokens[0].save ( saved_parent_error, saved_parent ) ->
               sails.log.debug "Saved parent #{ JSON.stringify saved_parent }"
               sails.log.debug "Saved parent saved_parent_error #{ JSON.stringify saved_parent_error }" if saved_parent_error?
               res.json ttransaction 

        )     


      else
        res.serverError "You don't have enough tokens. Please top up."
        
      
    ).catch ( err ) ->
      sails.log.debug "Find parent error #{ JSON.stringify err }"
      res.serverError err
    
  

}
