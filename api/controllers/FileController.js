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
    xlsx = require('node-xlsx');
    obj = xlsx.parse('./assets/excel_sheets/file.xls');
    sails.log.debug("xls " + (JSON.stringify(obj)));
    return res.json('Hrllo');
  }
};
