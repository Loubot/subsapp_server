###*
# Default model configuration
# (sails.config.models)
#
# Unless you override them, the following properties will be included
# in each of your models.
#
# For more info on Sails models, see:
# http://sailsjs.org/#!/documentation/concepts/ORM
###

module.exports.models = {
  migrate: 'drop'
  connection: 'subsapp_db'
}

# ---
# generated by js2coffee 2.1.0