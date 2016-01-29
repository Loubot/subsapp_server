// Generated by CoffeeScript 1.10.0

/**
 * User
 * @description :: Model keeping track of s3 uploads
 */
module.exports = {
  autoUpdatedAt: true,
  autoCreatedAt: true,
  autoPK: true,
  schema: true,
  attributes: {
    url: {
      type: 'string',
      required: true,
      defaultsTo: null
    },
    file_name: {
      type: 'string',
      required: true,
      defaultsTo: null
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
