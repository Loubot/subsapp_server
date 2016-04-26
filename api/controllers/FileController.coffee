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

    file_name = FileService.get_file_and_bucket_name( req.body, ( err, file_name ) ->
      if err?
        sails.log.debug "FileService erro #{ JSON.stringify err }"
        res.negotiate err
      else 
        sails.log.debug "Filename #{ JSON.stringify file_name }"

        params = 
          Bucket: 'subzapp'
          Prefix: req.body.org_id

        uploadFile = req.file('file').upload {
          adapter: require('skipper-s3')
          key: process.env.AWS_ACCESS_KEY_ID
          secret: process.env.AWS_SECRET_ACCESS_KEY
          # dirName: 'Lakewood'
          saveAs: file_name
          bucket: 'subzapp'
        }, (err, uploadedFiles) ->
          if err
            sails.log.debug "Upload error #{ JSON.stringify err }"
            res.negotiate err
          else
            sails.log.debug "Upload waheeeey #{ JSON.stringify uploadedFiles[0] }"
            Promise.resolve( [ s3.listObjectsAsync( params ) ] ).spread( ( s3_object ) ->
              # sails.log.debug "fts #{ JSON.stringify fts }"
              sails.log.debug "s3 #{ JSON.stringify s3_object }"
              res.json bucket_info: s3_object
            ).catch ( err ) ->
              sails.log.debug "Chain #{ err }"
              res.negotiate err



    ) #end of FileService.get_file_and_bucket_name
    
        
        


 
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
    sails.log.debug "Hit the file controller/parse_players"
    sails.log.debug "params #{ JSON.stringify req.body }"
    
    Promise = require('bluebird')
    

    AWS = require('aws-sdk')

    AWS.config.update({accessKeyId: process.env.AWS_ACCESS_KEY_ID, secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY})

    s3 = Promise.promisifyAll(new AWS.S3())
    # decode = require('urldecode')
    AWS.config.update({accessKeyId: process.env.AWS_ACCESS_KEY_ID, secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY})

    finish_up = ( users ) ->
      sails.log.debug "Finished creating users #{ users.length }"
      res.json users

    bucket_params = 
      Bucket: 'subzapp'
      Prefix: req.body.org_id
    sails.log.debug "bucket_params #{ JSON.stringify bucket_params} "

    File_service = Promise.promisifyAll( FileService ) # promisify the fileservice functions
    sails.log.debug "Check her here #{ JSON.stringify req.body.org_id }"
    File_service.get_file_listAsync( bucket_params ).then( ( file_list ) -> # get list of files in subzapp bucket starting with org_id/
      sails.log.debug "File list returned #{ JSON.stringify file_list }"
      file_names = new Array()
      for file in file_list.Contents #push file keys to an array        
        file_names.push file.Key

      sails.log.debug "File names #{ JSON.stringify file_names }" 

      File_service.get_filesAsync( file_names ).then( ( returned_files ) -> # download files using fileservice get_files method
        sails.log.debug "Returned files #{ returned_files.length }"

        recurse_create_users = ( index, created_users ) ->
          if index >= (returned_files.length )
            finish_up( created_users )
            return created_users
          # sails.log.debug "Check files index #{ JSON.stringify returned_files[index] }"
          File_service.create_usersAsync( returned_files[index], req.body.org_id ).then( ( returned_users ) ->
            sails.log.debug "Returned users #{ JSON.stringify returned_users.length }"
            created_users.push( returned_users )
            ++index
            recurse_create_users( index, created_users )
          ).catch( ( returned_users_err ) ->
            sails.log.debug "returned users err #{ JSON.stringify returned_users_err }"
            res.negotiate returned_users_err
          )



        recurse_create_users( 0, [] )        
        
      ).catch( ( returned_files_err ) ->
        sails.log.debug "Returned files err #{ JSON.stringify returned_files_err }"
        res.negotiate returned_files_err
      )
      
    ).catch( ( file_list_err ) ->
      sails.log.debug "File list returned error #{ JSON.stringify file_list_err }"
      res.negotiate file_list_err
    )
    
    


     

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
