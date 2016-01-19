// Generated by CoffeeScript 1.10.0

/**
 * EventController
 *
 * @description :: Server-side logic for managing Files
 * @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
 */
module.exports = {
  upload: function(req, res) {
    var obj, xlsx;
    sails.log.debug("Hit FileController/upload");
    sails.log.debug(req.file);
    req.file('uploadFile').upload({
      adapter: require('skipper-s3'),
      key: process.env.AWS_ACCESS_KEY_ID,
      secret: process.env.AWS_SECRET_ACCESS_KEY,
      dirName: 'Lakewood',
      saveAs: 'Lakewood/Louisblabla.xls',
      bucket: 'subzapp'
    }, function(err, uploadedFiles) {
      if (err) {
        sails.log.debug("Upload error " + (JSON.stringify(err)));
        return res.negotiate(err);
      } else {
        sails.log.debug("Upload waheeeey " + (JSON.stringify(uploadedFiles)));
        return res.json({
          files: uploadedFiles,
          textParams: req.params.all()
        });
      }
    });
    xlsx = require('node-xlsx');
    obj = xlsx.parse(uploadFile);
    sails.log.debug("xls " + (JSON.stringify(obj)));
    return res.json('Hrllo');
  },
  parse_users: function(req, res) {
    var fs, http, xlsx;
    sails.log.debug("Hit the FileController/parse_users");
    http = require('http');
    fs = require('fs');
    xlsx = require('node-xlsx');
    req = http.get('http://s3.amazonaws.com/subzapp/Lakewood/Louisblabla.xls', function(res) {
      var xml;
      xml = '';
      res.on('data', function(chunk) {
        xml += chunk;
      });
      res.on('end', function() {
        var obj;
        obj = xlsx.parse(xml);
      });
    });
    return req.on('error', function(err) {
      return Return;
    });
  }
};
