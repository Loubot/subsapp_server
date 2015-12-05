// Generated by CoffeeScript 1.10.0

/**
 * Token
 * @description :: Model for storing tokens
 */
module.exports = {
  migrate: 'safe',
  adapter: 'mysql',
  autoUpdatedAt: true,
  autoCreatedAt: true,
  autoPK: true,
  schema: true,
  attributes: {
    amount: {
      type: 'integer',
      required: true,
      defaultsTo: 0
    },
    owner: {
      model: 'user'
    },
    toJSON: function() {
      var obj;
      obj = this.toObject();
      delete obj.password;
      delete obj.socialProfiles;
      return obj;
    }
  }
};
