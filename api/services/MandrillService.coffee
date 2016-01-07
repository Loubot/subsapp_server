mandrill = require('mandrill-api/mandrill')
m = new mandrill.Mandrill("#{ process.env.SUBZAPP_MANDRILL }")

module.exports = {

  m: m
}