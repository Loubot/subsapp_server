// Generated by CoffeeScript 1.10.0

/**
 * Built-in Log Configuration
 * (sails.config.log)
 *
 * Configure the log level for your app, as well as the transport
 * (Underneath the covers, Sails uses Winston for logging, which
 * allows for some pretty neat custom transports/adapters for log messages)
 *
 * For more information on the Sails logger, check out:
 * http://sailsjs.org/#!/documentation/concepts/Logging
 */
var logger, winston;

winston = require('winston');


/*see the documentation for Winston:  https://github.com/flatiron/winston */

logger = new winston.Logger({
  transports: [
    new winston.transports.Console({}), new winston.transports.File({
      filename: 'logfile.log',
      level: 'debug',
      json: false,
      colorize: false
    })
  ]
});

module.exports.log = {
  custom: logger,
  level: 'debug'
};
