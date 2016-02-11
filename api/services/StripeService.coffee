

module.exports = {

  add_fees: ( token_amount ) ->

    sails.log.debug "Hit the stripe service/calculate fees"
    sails.log.debug "Amount #{ token_amount } "
    amount = token_amount
    sails.log.debug "Amount * 100 #{ amount }"
    amount = amount * sails.config.stripe.stripe_comm_precent
    amount = amount + sails.config.stripe.stripe_comm_euro
    amount = amount * sails.config.stripe.vat
    amount = amount + token_amount
    amount = amount * 100
    sails.log.debug "Amount after percentage #{ amount }"
    # amount = amount + ( + sails.config.stripe.stripe_comm_euro ) * sails.config.stripe.vat 
    # sails.log.debug "Amount after multiplication #{ amount }"
    return Math.round( amount )

}