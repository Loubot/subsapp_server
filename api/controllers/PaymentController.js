// Generated by CoffeeScript 1.10.0

/**
 * PaymentController
 *
 * @description :: Server-side logic for managing Payments
 * @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
 */
var passport;

passport = require('passport');

module.exports = {
  create_payment: function(req, res) {
    var Stripe, charge;
    sails.log.debug("Hit the Payment controller/create_payment");
    sails.log.debug("Create payment params " + (JSON.stringify(req.body)));
    Stripe = require("stripe")(sails.config.stripe.stripe_secret);
    return charge = Stripe.charges.create({
      source: req.body.stripe_token,
      description: 'Example charge',
      amount: parseInt(req.body.amount),
      currency: 'eur'
    }).then(function(charge) {
      sails.log.debug("Charge response " + (JSON.stringify(charge)));
      return Token.findOne({
        owner: req.body.user_id
      }).exec(function(err, token) {
        sails.log.debug("Token amount " + token.amount);
        token.amount = token.amount + charge.amount;
        return token.save(function(err, token) {
          sails.log.debug("Token saved " + (JSON.stringify(token)));
          if ((err != null)) {
            sails.log.debug("Token saved error " + (JSON.stringify(err)));
          }
          return res.json({
            token: token,
            message: 'Tokens purchased successfully',
            charge: charge
          });
        });
      });
    })["catch"](function(err) {
      sails.log.debug("Charge error " + (JSON.stringify(err)));
      return res.json({
        status: 401,
        error: err
      });
    });
  },
  get_transactions: function(req, res) {
    var Promise;
    sails.log.debug("Hit the payment controller/get_transactions");
    sails.log.debug("Params " + (JSON.stringify(req.query)));
    Promise = require('q');
    return Promise.all([
      User.findOne({
        id: req.query.id
      }).populate('tokens').populate('transactions'), {
        charges: {
          vat: sails.config.stripe.vat,
          stripe_comm_precent: sails.config.stripe.stripe_comm_precent,
          stripe_comm_euro: sails.config.stripe.stripe_comm_euro
        }
      }
    ]).spread(function(user, charges) {
      sails.log.debug("Sripte stuff " + (JSON.stringify(charges)));
      return res.json({
        user: user,
        charges: charges
      });
    })["catch"](function(err) {
      sails.log.debug("User found err " + (JSON.stringify(err)));
      return res.serverError(err);
    });
  }
};
