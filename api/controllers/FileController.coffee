###*
# EventController
#
# @description :: Server-side logic for managing Files
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###

module.exports = {
  
  upload: ( req, res ) ->
    sails.log.debug "Hit FileController/upload"
    sails.log.debug "Params #{ JSON.stringify req.body }"
    Promise = require('bluebird')
    sails.log.debug JSON.stringify req.body
    

    AWS = require('aws-sdk')

    AWS.config.update({accessKeyId: process.env.AWS_ACCESS_KEY_ID, secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY})

    s3 = Promise.promisifyAll(new AWS.S3())

    file_name = FileService.get_file_and_bucket_name( req.body )
    sails.log.debug "Filename #{ JSON.stringify file_name }"
    # uploadFile = req.file('file').upload {
    #   adapter: require('skipper-s3')
    #   key: process.env.AWS_ACCESS_KEY_ID
    #   secret: process.env.AWS_SECRET_ACCESS_KEY
    #   # dirName: 'Lakewood'
    #   saveAs: file_name
    #   bucket: 'subzapp'
    # }, (err, uploadedFiles) ->
    #   if err
    #     sails.log.debug "Upload error #{ JSON.stringify err }"
    #     res.negotiate err
    #   else
    #     sails.log.debug "Upload waheeeey #{ JSON.stringify uploadedFiles[0] }"
    #     Promise.resolve( [ s3.listObjectsAsync( params ) ] ).spread( ( s3_object ) ->
    #       # sails.log.debug "fts #{ JSON.stringify fts }"
    #       sails.log.debug "s3 #{ JSON.stringify s3_object }"
    #       res.json bucket_info: s3_object
    #     ).catch ( err ) ->
    #       sails.log.debug "Chain #{ err }"
    #       res.serverError err

    res.json file_name

        
        


 
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
    sails.log.debug "params #{ JSON.stringify req.query }"
    xlsx = require('node-xlsx')
    Promise = require('bluebird')
    sails.log.debug JSON.stringify req.body
    

    AWS = require('aws-sdk')

    AWS.config.update({accessKeyId: process.env.AWS_ACCESS_KEY_ID, secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY})

    s3 = Promise.promisifyAll(new AWS.S3())
    # decode = require('urldecode')
    AWS.config.update({accessKeyId: process.env.AWS_ACCESS_KEY_ID, secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY})
    

    Promise.resolve(
      params = 
        Bucket: 'subzapp'
        Delimiter: '/'
        Prefix: '1/1/'

      s3.listObjectsAsync( params ).then( ( stuff ) ->
        sails.log.debug "S3"
        sails.log.debug "s3 stuff #{ JSON.stringify stuff }"
        return [ 
                  stuff.Contents, 
                  s3.getObjectAsync( Bucket: 'subzapp', Key: stuff.Contents[0].Key ),
                  # Team.findOne( id: req.query.team_id )
                ]
      ).spread ( s3_bucket, s3_file ) ->
        sails.log.debug "Bucket #{ JSON.stringify s3_bucket }"
        sails.log.debug "Bucket #{ s3_file }"
        obj = xlsx.parse(s3_file.Body)
        player_array = obj[0].data
        player_array.splice(0,1)
        # sails.log.debug "Array #{ JSON.stringify player_array }"
        User.create_players( player_array, req.query.org_id, ( err, players ) ->
          sails.log.debug "Players #{ JSON.stringify players }"
          sails.log.debug "Players error #{ JSON.stringify err }" if err?
          res.serverError err if err?
        )
        res.json obj[0].data
    )

    

    # FileTracker.findOne( id: 4 ).then( ( filet ) ->
    #   sails.log.debug "File tracker #{ JSON.stringify filet }"
    #   sails.log.debug "url #{ decode filet.url }"
    # )
    # (new (AWS.S3)).getObject {
    #     Bucket: 'subzapp'
    #     Key: '1/1/U17Boys'
    #   }, (err, data) ->
    #     sails.log.debug "AWS error #{ JSON.stringify err }" if err?
    #     if err?
    #       res.serverError err.message
    #       return false

    #     tempFile.write data.Body if !err?

    #     sails.log.debug 'yippee'
    #     obj = xlsx.parse(data.Body)
        
    #     player_array = obj[0].data
    #     player_array.splice(0,1)
    #     # sails.log.debug "Array #{ JSON.stringify player_array }"
    #     User.create_players( player_array, ( err, players ) ->
    #       sails.log.debug "Players #{ JSON.stringify players }"
    #       sails.log.debug "Players error #{ JSON.stringify err }" if err?
    #     )
    #     res.json obj[0].data

      


     

  download_file: ( req, res ) ->
    sails.log.debug "Hit the FileController/download_file"
    sails.log.debug "Query #{ req.query }"
    AWS = require('aws-sdk')

    AWS.config.update({accessKeyId: process.env.AWS_ACCESS_KEY_ID, secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY})

    s3 = new (AWS.S3)
    params = 
      Bucket: 'subzapp'
      Delimiter: '/'
      Prefix: '1/1/'
    s3.listObjects params, (err, data) ->
      if err
        throw err
      sails.log.debug "Got file"
      sails.log.debug JSON.stringify data
      return
}
