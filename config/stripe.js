// config/stripe.js
module.exports.stripe = {
  stripe_secret: process.env.SUBZAPP_STRIPE_SECRET,
  stripe_publish: process.env.SUBZAPP_STRIPE_PUBLIC,
  stripe_comm_precent: 0.014,
  stripe_comm_euro: 0.25,
  vat: 1.23
};