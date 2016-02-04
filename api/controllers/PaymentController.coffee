###*
# PaymentController
#
# @description :: Server-side logic for managing Payments
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###

passport = require('passport')
module.exports = {

  create_payment: ( req, res ) ->
    sails.log.debug "Hit the Payment controller/create_payment"
    sails.log.debug "Create payment params #{ JSON.stringify req.body }"
    # sails.log.debug "config #{ sails.config.stripe.stripe_publish }"
    Stripe = require("stripe")(sails.config.stripe.stripe_secret)
    Promise = require('q')

    Promise.all([      
      Stripe.charges.create({
        source: req.body.stripe_token,
        description: 'Example charge',
        amount: parseInt( req.body.amount ),
        currency: 'eur'})
      Token.findOne( owner: req.body.user_id )
      
      
    ]).spread( ( stripe_charge, token) ->
      sails.log.debug "Stripe charge #{ JSON.stringify stripe_charge }"
      sails.log.debug "Token found #{ JSON.stringify token }"

      sails.log.debug "Token amount #{ token.amount }"
      token.amount = token.amount + ( stripe_charge.amount )

      Promise.all([
        token.save()
        Transaction.create(
          user_id: req.body.user_id,
          amount: stripe_charge.amount,
          amount_refunded: stripe_charge.amount_refunded,
          stripe_id: stripe_charge.id,
          created: stripe_charge.created,
          failure_code: stripe_charge.failure_code,
          failure_message: stripe_charge.failure_message,
          paid: stripe_charge.paid,
          # receipt_email: 
          status: stripe_charge.status,
          last4: stripe_charge.source.last4
        )
      ]).spread( ( token, transaction ) ->
        sails.log.debug "Token saved #{ JSON.stringify token }"
        sails.log.debug "Transaction saved #{ JSON.stringify transaction }"
        res.json token: token, transaction: transaction
      ).catch ( err ) ->
        if err?
          sails.log.debug "transaction create err #{ JSON.stringify err }"
          res.status 500
          res.json err
    ).catch ( err ) ->
      if err?
        sails.log.debug "Stripe create error #{ JSON.stringify err }"
        res.status 500
        res.json err 



    # charge = Stripe.charges.create({
    #   source: req.body.stripe_token
    #   description: 'Example charge'
    #   amount: parseInt( req.body.amount )
    #   currency: 'eur'
    #   }).then( ( charge ) ->
    #     sails.log.debug "Charge response #{ JSON.stringify charge }"
        

    #     Token.findOne( { owner: req.body.user_id },  ).exec (err, token) ->
    #       sails.log.debug "Token amount #{ token.amount }"
    #       token.amount = token.amount + ( charge.amount )
    #       token.save ( err, token ) ->
    #         sails.log.debug "Token saved #{ JSON.stringify token }"
    #         sails.log.debug "Token saved error #{ JSON.stringify err }" if (err?)
    #         res.json token: token, message: 'Tokens purchased successfully', charge: charge


    #   ).catch( ( err ) ->
    #     sails.log.debug "Charge error #{ JSON.stringify err }"
    #     res.status 500
    #     res.json status: 401, error: err
    #   )

  get_transactions: ( req, res ) ->
    sails.log.debug "Hit the payment controller/get_transactions"
    sails.log.debug "Params #{ JSON.stringify req.query }"

    Promise = require('q')

    Promise.all([
      User.findOne( id: req.query.id ).populate('tokens').populate('transactions')
      charges:
        vat: sails.config.stripe.vat
        stripe_comm_precent: sails.config.stripe.stripe_comm_precent
        stripe_comm_euro: sails.config.stripe.stripe_comm_euro

    ]).spread( ( user, charges ) ->
      sails.log.debug "Sripte stuff #{ JSON.stringify charges }"
      res.json 
        user: user
        charges: charges
    ).catch ( err ) ->
      sails.log.debug "User found err #{ JSON.stringify err }"
      res.serverError err

}

