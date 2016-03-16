winston = require('winston')
customLogger = new (winston.Logger)(transports: [ new (winston.transports.File)(
  level: 'silly'
  filename: "logfile.log") ])

module.exports.log =
  colors: false
  custom: customLogger