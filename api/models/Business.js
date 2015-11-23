// Generated by CoffeeScript 1.10.0

/**
 * User
 * @description :: Model for storing businesses
 */
module.exports = {
  migrate: 'drop',
  adapter: 'mysql',
  autoUpdatedAt: true,
  autoCreatedAt: true,
  autoPK: true,
  schema: true,
  attributes: {
    name: {
      type: 'string',
      defaultsTo: '',
      required: true
    },
    address: {
      type: 'text',
      defaultsTo: '',
      required: true
    },
    admins: [],
    toJSON: function() {
      var obj;
      obj = this.toObject();
      delete obj.password;
      delete obj.socialProfiles;
      return obj;
    }
  },
  beforeUpdate: function(values, next) {
    CipherService.hashPassword(values);
    next();
  },
  beforeCreate: function(values, next) {
    CipherService.hashPassword(values);
    next();
  }
};
