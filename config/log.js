var winston = require('winston');

require('winston-papertrail').Papertrail;

  var logger = new winston.Logger({
    transports: [
        new winston.transports.Papertrail({
            level: 'silly',
            host: 'logs.papertrailapp.com',
            port: 12345
        })
    ]
  });

module.exports.log = {
    colors: false,  // To get clean logs without prefixes or color codings
    custom: logger
};