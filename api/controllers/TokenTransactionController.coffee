###*
# TokenTransactionController
#
# @description :: Server-side logic for managing TokenTransactions
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###


module.exports = {
  find: ( req, res ) ->
    sails.log.debug "Hit the TokenTransactionController/findOne"
    sails.log.debug "Params #{ JSON.stringify req.query }"
    TokenTransaction.find( user_id: req.query.user_id).then ( ( ttransaction ) ->
      res.json ttransaction

    ).catch ( err ) ->
      sails.log.debug "Find TokenTransaction error #{ JSON.stringify err }"
      res.serverError err


  pay: ( req, res ) ->
    sails.log.debug "Hit the TokenTransactionController/pay"
    sails.log.debug "Params #{ JSON.stringify req.body }"

    User.findOne( id: req.body.parent_id ).populate('tokens').then ( ( parent ) ->
      sails.log.debug "Found parent #{ JSON.stringify parent }"

      if ( parent.tokens[0].amount - req.body.amount >= 0 )
        TokenTransaction.create( 
          event_id: req.body.event_id
          user_id: req.body.user_id
          parent_id: req.body.parent_id
          token_amount: req.body.token_amount
          paid: true
          team_id: req.body.team_id
        ).then( ( ttransaction ) ->
          sails.log.debug "TokenTransaction create/event pay #{ JSON.stringify ttransaction }"
          parent.tokens[0].amount = parent.tokens[0].amount - req.body.amount
          parent.save ( err, saved_parent ) ->
            sails.log.debug "Saved parent #{ JSON.stringify saved_parent }"
            sails.log.debug "Saved parent err #{ JSON.stringify err }" if err?
            res.json ttransaction
        ).catch ( ttransaction_err ) ->
          sails.log.debug "TokenTransaction create error/event pay #{ JSON.stringify ttransaction_err }"
          res.serverError err

      else
        res.serverError "You don't have enough tokens. Please top up."

    ).catch( err ) ->
      sails.log.debug "Couldn't find parent #{ JSON.stringify err }"

    
  

}
