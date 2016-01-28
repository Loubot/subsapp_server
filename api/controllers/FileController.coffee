###*
# EventController
#
# @description :: Server-side logic for managing Files
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###

module.exports = {
  
  upload: ( req, res ) ->
    sails.log.debug "Hit FileController/upload"
    sails.log.debug JSON.stringify req.body
    team_name = req.body.team_name.replace(/\s+/g, '')

    uploadFile = req.file('file').upload {
      adapter: require('skipper-s3')
      key: process.env.AWS_ACCESS_KEY_ID
      secret: process.env.AWS_SECRET_ACCESS_KEY
      # dirName: 'Lakewood'
      saveAs: "#{ req.body.org_id }/#{ req.body.team_id}/#{ JSON.stringify req.body.team_name }.xls" #folder/file
      bucket: 'subzapp'
    }, (err, uploadedFiles) ->
      if err
        sails.log.debug "Upload error #{ JSON.stringify err }"
        res.negotiate err
      else
        sails.log.debug "Upload waheeeey #{ JSON.stringify uploadedFiles }"
        FileService.store_file_info( uploadedFiles[0], req.body.org_id, ( err, ft ) ->
          sails.log.debug "Callback #{ JSON.stringify ft }"
          sails.log.debug "Callback err #{ JSON.stringify err }" if err?
        )
        res.json uploadedFiles


 
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
          
  
  parse_players: ( req, res ) ->
    sails.log.debug "Hit the file controller/aws"
    fs = require('fs')
    xlsx = require('node-xlsx')
    mkdirp = require('mkdirp')
    AWS = require('aws-sdk')
    decode = require('urldecode')
    AWS.config.update({accessKeyId: process.env.AWS_ACCESS_KEY_ID, secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY})
    

    # mkdirp './.tmp/excel_sheets', ( err ) ->
    #   if err
    #     sails.log.debug "Can't create dir #{ JSON.stringify err }"
    #   else
    #     sails.log.debug "Dir created waheeeey"
    #     fs.closeSync fs.openSync('./.tmp/excel_sheets/bla.xls', 'w')

    #     tempFile = fs.createWriteStream('./.tmp/excel_sheets/bla.xls')
    #     tempFile.on 'open', (fd) ->

    FileTracker.findOne( id: 4 ).then( ( filet ) ->
      sails.log.debug "File tracker #{ JSON.stringify filet }"
      sails.log.debug "url #{ decode filet.url }"
    )
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