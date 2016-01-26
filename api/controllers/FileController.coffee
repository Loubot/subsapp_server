###*
# EventController
#
# @description :: Server-side logic for managing Files
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###

module.exports = {
  
  upload: ( req, res ) ->
    sails.log.debug "Hit FileController/upload"
    sails.log.debug req.body

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

    uploadFile = req.file('uploadFile').upload {
      adapter: require('skipper-s3')
      key: process.env.AWS_ACCESS_KEY_ID
      secret: process.env.AWS_SECRET_ACCESS_KEY
      # dirName: 'Lakewood'
      saveAs: 'Lakewood/z.xls'  #folder/file
      bucket: 'subzapp'
    }, (err, uploadedFiles) ->
      if err
        sails.log.debug "Upload error #{ JSON.stringify err }"
        res.negotiate err
      else
        sails.log.debug "Upload waheeeey #{ JSON.stringify uploadedFiles }"
        res.json 'Files uploaded ok'

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
    mkdirp = require('mkdirp')

    mkdirp './.tmp/excel_sheets', ( err ) ->
      if err
        sails.log.debug "Can't create dir #{ JSON.stringify err }"
      else
        sails.log.debug "Dir created waheeeey"
        fs.closeSync fs.openSync('./.tmp/excel_sheets/bla.xls', 'w')

    

        tempFile = fs.createWriteStream('./.tmp/excel_sheets/bla.xls')
        tempFile.on 'open', (fd) ->
          http.get 'http://s3.amazonaws.com/subzapp/Lakewood/Louisblabla.xls', (response) ->
            response.on('data', (chunk) ->
              tempFile.write chunk
              return
            ).on 'end', ->          
              tempFile.end()

              sails.log.debug 'yippee'
              obj = xlsx.parse('./.tmp/excel_sheets/bla.xls')
              sails.log.debug "Object #{ JSON.stringify obj }"
              res.json obj
              # fs.renameSync './assets/excel_sheets/bla.xls', filepath
          
  
  aws: ( req, res ) ->
    sails.log.debug "Hit the file controller/aws"
    fs = require('fs')
    xlsx = require('node-xlsx')
    mkdirp = require('mkdirp')
    AWS = require('aws-sdk')
    AWS.config.update({accessKeyId: process.env.AWS_ACCESS_KEY_ID, secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY})
    

    mkdirp './.tmp/excel_sheets', ( err ) ->
      if err
        sails.log.debug "Can't create dir #{ JSON.stringify err }"
      else
        sails.log.debug "Dir created waheeeey"
        fs.closeSync fs.openSync('./.tmp/excel_sheets/bla.xls', 'w')

        tempFile = fs.createWriteStream('./.tmp/excel_sheets/bla.xls')
        tempFile.on 'open', (fd) ->
          (new (AWS.S3)).getObject {
              Bucket: 'subzapp'
              Key: 'x.xls'
            }, (err, data) ->
              sails.log.debug "AWS error #{ JSON.stringify err }" if err?
              if err?
                res.serverError err.message
                return false

              tempFile.write data.Body if !err?

              sails.log.debug 'yippee'
              obj = xlsx.parse(data.Body)
              
              player_array = obj[0].data
              player_array.splice(0,1)
              # sails.log.debug "Array #{ JSON.stringify player_array }"
              User.create_players( player_array, ( err, players ) ->
                sails.log.debug "Players #{ JSON.stringify players }"
                sails.log.debug "Players error #{ JSON.stringify err }" if err?
              )
              res.json obj[0].data

      # (new (AWS.S3)).getObject {
      #   Bucket: 'subzapp'
      #   Key: 'Louisblabla.xls'
      # }, (err, data) ->
      #   sails.log.debug "AWS error #{ JSON.stringify err }" if err?
      #   # sails.log.debug "AWS file #{ data.Body.toString() }"

      #   obj = xlsx.parse(data)
      #   sails.log.debug "Object #{ JSON.stringify obj }"


     

}