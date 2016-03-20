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

    total = StripeService.add_fees( req.body.amount )
    sails.log.debug "Payment controller total #{ total }"

    Promise.all([      
      Stripe.charges.create({
        source: req.body.stripe_token,
        description: 'Example charge',
        amount: total,
        currency: 'eur' })
      Token.findOne( owner: req.body.user_id )
      
      
    ]).spread( ( stripe_charge, token) ->
      sails.log.debug "Stripe charge #{ JSON.stringify stripe_charge }"
      sails.log.debug "Token found #{ JSON.stringify token }"

      sails.log.debug "Token amount #{ token.amount }"
      token.amount = token.amount + req.body.amount

      Promise.all([
        token.save()
        Transaction.create(
          user_id: req.body.user_id,
          amount: stripe_charge.amount,
          token_amount: req.body.amount,
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
        User.findOne( id: req.body.user_id )
      ]).spread( ( token, transaction, user ) ->
        sails.log.debug "Token saved #{ JSON.stringify token }"
        sails.log.debug "Transaction saved #{ JSON.stringify transaction }"

        user.transactions.add( transaction )
        user.save( ( err, user_saved ) ->
          if err?
            sails.log.debug "User populate error #{ JSON.stringify err }"
            res.negotiate err
          else
          res.json stripe_charge
            # User.findOne( req.body.user_id).populate('tokens').populate('transactions').then( ( user_pop ) ->
            #   sails.log.debug "User populate #{ JSON.stringify user_saved }"
            #   res.json user_pop
            # ).catch ( err ) ->
            #   sails.log.debug "User find err #{ JSON.stringify err }"
            #   res.negotiate err
        )

      ).catch ( err ) ->
        if err?
          sails.log.debug "transaction create err #{ JSON.stringify err }"
          res.negotiate err
    ).catch ( err ) ->
      if err?
        sails.log.debug "Stripe create error #{ JSON.stringify err }"
        res.status 500
        res.json err

  get_transactions: ( req, res ) ->
    sails.log.debug "Hit the payment controller/get_transactions"
    sails.log.debug "Params #{ JSON.stringify req.query }"

    Promise = require('q')

    Promise.all([
      User.findOne( id: req.param('id') ).populate('tokens').populate('transactions'),
      {
        vat: sails.config.stripe.vat,
        stripe_comm_precent: sails.config.stripe.stripe_comm_precent,
        stripe_comm_euro: sails.config.stripe.stripe_comm_euro 
      }
      

    ]).spread( ( user, charges ) ->
      sails.log.debug "User #{ JSON.stringify user }"
      sails.log.debug "Sripte stuff #{ JSON.stringify charges }"
      res.json 
        user: user
        charges: charges
    ).catch ( err ) ->
      sails.log.debug "User found err #{ JSON.stringify err }"
      res.negotiate err

}

