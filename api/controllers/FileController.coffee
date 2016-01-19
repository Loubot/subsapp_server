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

    # uploadFile = req.file('uploadFile')
    # sails.log.debug "uploaded file #{ JSON.stringify uploadFile }"
    # uploadFile.upload (err, files) ->
    #   # Files will be uploaded to .tmp/uploads
    #   if err
    #     return res.serverError(err)
    #   # IF ERROR Return and send 500 error with error
    #   sails.log.debug files
    #   # res.json
    #   #   status: 200
    #   #   file: files
    #   return

    req.file('uploadFile').upload { dirname: './assets/images' }, (err, uploadedFiles) ->
      if err
        return res.negotiate(err)
      res.json message: uploadedFiles.length + ' file(s) uploaded successfully!'
 
   
    # xlsx = require('node-xlsx')
    # obj = xlsx.parse(uploadFile)
    # sails.log.debug "xls #{ JSON.stringify obj }"
    # res.json 'Hrllo'
    
}