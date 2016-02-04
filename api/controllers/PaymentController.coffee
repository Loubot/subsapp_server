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

    charge = Stripe.charges.create({
      source: req.body.stripe_token
      description: 'Example charge'
      amount: parseInt( req.body.amount )
      currency: 'eur'
      }).then( ( charge ) ->
        sails.log.debug "Charge response #{ JSON.stringify charge }"
        

        Token.findOne( { owner: req.body.user_id },  ).exec (err, token) ->
          sails.log.debug "Token amount #{ token.amount }"
          token.amount = token.amount + ( charge.amount )
          token.save ( err, token ) ->
            sails.log.debug "Token saved #{ JSON.stringify token }"
            sails.log.debug "Token saved error #{ JSON.stringify err }" if (err?)
            res.json token: token, message: 'Tokens purchased successfully'


      ).catch( ( err ) ->
        sails.log.debug "Charge error #{ JSON.stringify err }"
        res.serverError "Charge err"
      )

  get_transactions: ( req, res ) ->
    sails.log.debug "Hit the payment controller/get_transactions"
    sails.log.debug "Params #{ JSON.stringify req.query }"

    Promise = require('q')

    Promise.all([
      User.findOne( id: req.query.id ).populate('tokens')
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

