###*
# Production environment settings
#
# This file can include shared settings for a production environment,
# such as API keys or remote database passwords.  If you're using
# a version control solution for your Sails app, this file will
# be committed to your repository unless you add it to your .gitignore
# file.  If your repository will be publicly viewable, don't add
# any private information to this file!
#
###

module.exports = 
  models: 
    connection: 'subsapp_db_prod'

  session:
    secret: process.env.SESSION_SECRET
    adapter: 'redis'
    host: process.env.REDIS_HOST
    port: process.env.REDIS_PORT
    db: process.env.REDIS_DB
    pass: process.env.REDIS_PASS


###
# Session Configuration
# (sails.config.session)
#
# Sails session integration leans heavily on the great work already done by
# Express, but also unifies Socket.io with the Connect session store. It uses
# Connect's cookie parser to normalize configuration differences between Express
# and Socket.io and hooks into Sails' middleware interpreter to allow you to access
# and auto-save to `req.session` with Socket.io the same way you would with Express.
#
# For more information on configuring the session, check out:
# http://sailsjs.org/#!/documentation/reference/sails.config/sails.config.session.html
###