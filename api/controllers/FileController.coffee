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

    uploadFile= req.file('uploadFile').upload {
      adapter: require('skipper-s3')
      key: process.env.AWS_ACCESS_KEY_ID
      secret: process.env.AWS_SECRET_ACCESS_KEY
      dirName: 'Lakewood'
      saveAs: 'Lakewood/Louisblabla.xls'
      bucket: 'subzapp'
    }, (err, uploadedFiles) ->
      if err
        sails.log.debug "Upload error #{ JSON.stringify err }"
        res.negotiate err
      else
        sails.log.debug "Upload waheeeey #{ JSON.stringify uploadedFiles }"
        res.json
          files: uploadedFiles
          textParams: req.params.all()

    # req.file('uploadFile').upload { dirname: './assets/images' }, (err, uploadedFiles) ->
    #   if err
    #     return res.negotiate(err)
    #   res.json message: uploadedFiles.length + ' file(s) uploaded successfully!'
 
   
    # xlsx = require('node-xlsx')
    # obj = xlsx.parse(uploadFile)
    # sails.log.debug "xls #{ JSON.stringify obj }"
    # res.json 'Hrllo'
 
  parse_users: ( req, res ) ->
    sails.log.debug "Hit the FileController/parse_users"
    http = require('http')
    fs = require('fs')
    xlsx = require('node-xlsx')

    file = fs.createWriteStream('./assets/excel_sheets/bla.xls')
    request = http.get('http://s3.amazonaws.com/subzapp/Lakewood/Louisblabla.xls', (response) ->
      response.pipe file
      file.on 'finish', ->
        file.close ->
          sails.log.debug 'yippee'


          
        # close() is async, call callback after close completes.
        
          obj = xlsx.parse('./assets/excel_sheets/bla.xls')
          sails.log.debug "Object #{ JSON.stringify obj }"
          res.json 'Hrllo', obj
    )

     

}