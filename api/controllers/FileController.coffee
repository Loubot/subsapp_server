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

    req.file('uploadFile').upload {
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
 
   
    xlsx = require('node-xlsx')
    obj = xlsx.parse(uploadFile)
    sails.log.debug "xls #{ JSON.stringify obj }"
    res.json 'Hrllo'
 
  parse_users: ( req, res ) ->
    sails.log.debug "Hit the FileController/parse_users"
    http = require('http')
    fs = require('fs')
    xlsx = require('node-xlsx')

    req = http.get('http://s3.amazonaws.com/subzapp/Lakewood/Louisblabla.xls', (res) ->
      # save the data
      xml = ''
      res.on 'data', (chunk) ->
        xml += chunk
        return
      res.on 'end', ->
        # sails.log.debug "Finished #{ JSON.stringify xml }"
        obj = xlsx.parse(xml)
        # parse xml
        return
      # or you can pipe the data to a parser
      # res.pipe dest
      return
    )
    req.on 'error', (err) ->
      # debug error
      Return

     

}