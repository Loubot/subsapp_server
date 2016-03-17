winston = require('winston')
customLogger = new (winston.Logger)(transports: [ new (winston.transports.File)(
  level: 'debug'
  filename: "logfile.log") ])

module.exports.log =
  colors: false
  custom: customLogger