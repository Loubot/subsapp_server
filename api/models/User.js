// Generated by CoffeeScript 1.10.0

/**
 * User
 * @description :: Model for storing users
 */
module.exports = {
  migrate: 'safe',
  adapter: 'mysql',
  autoUpdatedAt: true,
  autoCreatedAt: true,
  autoPK: true,
  schema: true,
  attributes: {
    password: {
      type: 'string'
    },
    email: {
      type: 'email',
      required: true,
      unique: true
    },
    firstName: {
      type: 'string',
      defaultsTo: ''
    },
    lastName: {
      type: 'string',
      defaultsTo: ''
    },
    tokens: {
      collection: 'token',
      via: 'owner'
    },
    orgs: {
      collection: 'org',
      via: 'admins'
    },
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
