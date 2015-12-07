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
    stripe = require("stripe")(sails.config.stripe.stripe_secret)

    stripe.customers.create( {
      description: 'Customer for test@example.com'
      source: req.body.stripe_token
    }).then( ( customer ) ->
      sails.log.debug "Customer #{ JSON.stringify customer }"
      User.update(req.body.user_id, stripe_id: customer.id ).exec (err, updated) ->
        sails.log.debug "User stripe customer create update error #{ JSON.stringify err }" if err?
        sails.log.debug "User stripe customer create update #{ JSON.stringify updated }"
    )
      


    # charge = stripe.charges.create({
    #   amount: 1000
    #   currency: 'usd'
    #   source: req.body.stripe_token
    #   description: 'Example charge'
    # }, (err, charge) ->
    #   if err and err.type == 'StripeCardError'
    #     sails.log.debug "# The card has been declined #{ JSON.stringify err }"
    #   else
    #     sails.log.debug "Stripe charge #{ JSON.stringify charge }"
    #   return
    # )
    
}

