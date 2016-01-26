// Generated by CoffeeScript 1.10.0

/**
 * EventController
 *
 * @description :: Server-side logic for managing Files
 * @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
 */
module.exports = {
  upload: function(req, res) {
    var uploadFile;
    sails.log.debug("Hit FileController/upload");
    sails.log.debug(req.body);
    return uploadFile = req.file('uploadFile').upload({
      adapter: require('skipper-s3'),
      key: process.env.AWS_ACCESS_KEY_ID,
      secret: process.env.AWS_SECRET_ACCESS_KEY,
      saveAs: 'Lakewood/z.xls',
      bucket: 'subzapp'
    }, function(err, uploadedFiles) {
      if (err) {
        sails.log.debug("Upload error " + (JSON.stringify(err)));
        return res.negotiate(err);
      } else {
        sails.log.debug("Upload waheeeey " + (JSON.stringify(uploadedFiles)));
        return res.json('Files uploaded ok');
      }
    });
  },
  parse_users: function(req, res) {
    var fs, http, mkdirp, xlsx;
    sails.log.debug("Hit the FileController/parse_users");
    http = require('http');
    fs = require('fs');
    xlsx = require('node-xlsx');
    mkdirp = require('mkdirp');
    return mkdirp('./.tmp/excel_sheets', function(err) {
      var tempFile;
      if (err) {
        return sails.log.debug("Can't create dir " + (JSON.stringify(err)));
      } else {
        sails.log.debug("Dir created waheeeey");
        fs.closeSync(fs.openSync('./.tmp/excel_sheets/bla.xls', 'w'));
        tempFile = fs.createWriteStream('./.tmp/excel_sheets/bla.xls');
        return tempFile.on('open', function(fd) {
          return http.get('http://s3.amazonaws.com/subzapp/Lakewood/Louisblabla.xls', function(response) {
            return response.on('data', function(chunk) {
              tempFile.write(chunk);
            }).on('end', function() {
              var obj;
              tempFile.end();
              sails.log.debug('yippee');
              obj = xlsx.parse('./.tmp/excel_sheets/bla.xls');
              sails.log.debug("Object " + (JSON.stringify(obj)));
              return res.json(obj);
            });
          });
        });
      }
    });
  },
  aws: function(req, res) {
    var AWS, fs, mkdirp, xlsx;
    sails.log.debug("Hit the file controller/aws");
    fs = require('fs');
    xlsx = require('node-xlsx');
    mkdirp = require('mkdirp');
    AWS = require('aws-sdk');
    AWS.config.update({
      accessKeyId: process.env.AWS_ACCESS_KEY_ID,
      secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY
    });
    return mkdirp('./.tmp/excel_sheets', function(err) {
      var tempFile;
      if (err) {
        return sails.log.debug("Can't create dir " + (JSON.stringify(err)));
      } else {
        sails.log.debug("Dir created waheeeey");
        fs.closeSync(fs.openSync('./.tmp/excel_sheets/bla.xls', 'w'));
        tempFile = fs.createWriteStream('./.tmp/excel_sheets/bla.xls');
        return tempFile.on('open', function(fd) {
          return (new AWS.S3).getObject({
            Bucket: 'subzapp',
            Key: 'x.xls'
          }, function(err, data) {
            var obj, player_array;
            if (err != null) {
              sails.log.debug("AWS error " + (JSON.stringify(err)));
            }
            if (err != null) {
              res.serverError(err.message);
              return false;
            }
            if (err == null) {
              tempFile.write(data.Body);
            }
            sails.log.debug('yippee');
            obj = xlsx.parse(data.Body);
            player_array = obj[0].data;
            player_array.splice(0, 1);
            User.create_players(player_array, function(err, players) {
              sails.log.debug("Players " + (JSON.stringify(players)));
              if (err != null) {
                return sails.log.debug("Players error " + (JSON.stringify(err)));
              }
            });
            return res.json(obj[0].data);
          });
        });
      }
    });
  }
};
