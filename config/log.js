var winston = require('winston');

var customLogger = new winston.Logger({
    transports: [
        new(winston.transports.File)({
            level: 'silly',
            filename: "logfile.log"
            // filename: "C:\\Users\\angell\\Documents\\sails\\subsapp_server\\logfile.log"
        }),
    ],
});

module.exports.log = {
    colors: false,  // To get clean logs without prefixes or color codings
    custom: customLogger
};