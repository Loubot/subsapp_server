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
    # sails.log.debug "Create payment params #{ JSON.stringify req.body }"
    # sails.log.debug "config #{ sails.config.stripe.stripe_publish }"
    Stripe = require("stripe")(sails.config.stripe.stripe_secret)

    Stripe.customers.create(
      source: req.body.stripe_token
      description: 'hello'
    ).then((customer) ->
      sails.log.debug "Stripe customer #{ JSON.stringify customer }"
      Stripe.charges.create(
        amount: parseInt( req.body.amount )  * 100
        currency: 'eur'
        customer: customer.id
      ).then ( (charge) ->
        sails.log.debug "charge #{ req.body.user_id }"
        
        User.update( { id: req.body.user_id }, stripe_token: charge.customer ).then ( ( updated ) ->
          sails.log.debug "User updated #{ JSON.stringify updated }"
          res.send charge
        ), (errResponse) ->
          sails.log.debug "User update error #{ JSON.stringify errResponse }"

          
        
      )
    ).fail ( err ) ->
      sails.log.debug err
      res.serverError err

    # stripe.customers.create( {
    #   description: 'Customer for test@example.com'
    #   source: req.body.stripe_token
    # }).then( ( customer ) ->
    #   sails.log.debug "Customer #{ JSON.stringify customer }"
    #   User.update(req.body.user_id, stripe_id: customer.id ).exec (err, updated) ->
    #     sails.log.debug "User stripe customer create update error #{ JSON.stringify err }" if err?
    #     sails.log.debug "User stripe customer create update #{ JSON.stringify updated }"
    # ).catch( ( err ) ->
    #     sails.log.debug "Create customer error #{ JSON.stringify err }"
    # ).done ->
    #   sails.log.debug "Create custome done"
      


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

