###*
# EventController
#
# @description :: Server-side logic for managing Files
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###

module.exports = {
  
  upload: ( req, res ) ->
    sails.log.debug "Hit FileController/upload"
    sails.log.debug req.file
   
    xlsx = require('node-xlsx')
    obj = xlsx.parse('./assets/excel_sheets/file.xls')
    sails.log.debug "xls #{ JSON.stringify obj }"
    res.json 'Hrllo'
    # uploadFile = req.file('uploadFile')
    # console.log uploadFile
    # uploadFile.upload (err, files) ->
    #   # Files will be uploaded to .tmp/uploads
    #   if err
    #     return res.serverError(err)
    #   # IF ERROR Return and send 500 error with error
    #   console.log files
    #   res.json
    #     status: 200
    #     file: files
    #   return
 
}