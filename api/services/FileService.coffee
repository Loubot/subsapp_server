Promise = require('bluebird')
AWS = require('aws-sdk')

AWS.config.update({accessKeyId: process.env.AWS_ACCESS_KEY_ID, secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY})




module.exports = {

  get_file_list: ( params, cb ) ->
    sails.log.debug "Hit the fileservice/get_file_list"
    sails.log.debug "Bucket Params #{ JSON.stringify params }"
    s3 = Promise.promisifyAll( new AWS.S3() )

    s3.listObjectsAsync( params ).then( ( bucket_info ) ->
      sails.log.debug "Bucket info #{ JSON.stringify bucket_info }"
      cb( null, bucket_info )
    ).catch( ( bucket_info_err ) ->
      sails.log.debug "Bucket info error #{ JSON.stringify bucket_info_err }"
      cb( bucket_info_err ) 
    )

  get_files: ( file_list, cb ) ->
    sails.log.debug "Hit the fileservice/get_files"
    sails.log.debug "File list #{ JSON.stringify file_list }"
    s3 = Promise.promisifyAll( new AWS.S3() )
    

    finish_up = ( files ) -> # downloads finished, execute call back
      sails.log.debug "Finish up #{ files.length }"
      cb( null, files )

    
    params = 
      Bucket: 'subzapp'

    do_download = ( counter, downloaded_files ) -> #recursive function to download a number of s3 files. execute finish_up when it's finished. 
      sails.log.debug "Downloaded files size #{ JSON.stringify downloaded_files.length }"
      sails.log.debug "size in loop #{ file_list.length }"
      counter = 0 if !(counter)?

      if counter >= file_list.length
        finish_up( downloaded_files )
        return downloaded_files

      params.Key = file_list[counter]
      s3.getObjectAsync( params ).then( ( downloaded_file ) ->
        sails.log.debug "Downloaded file ok"
        downloaded_files.push( downloaded_file )
        ++counter
        do_download( counter, downloaded_files )
      ).catch( ( downloaded_file_err ) ->
        sails.log.debug "downloaded_file_err #{ JSON.stringify downloaded_file_err }"
        cb( downloaded_file_err )
      )

    do_download( 0, [] ) # start recursively downloading files. 
    

  # end of get_files()

  create_users: ( file, cb ) ->
    xlsx = require('node-xlsx')
    sails.log.debug "Hit the fileservice/create_users"
    sails.log.debug "Files #{ JSON.stringify file }"
    obj = xlsx.parse( file.Body )
    player_array = obj[0].data
    player_array.splice(0,1)
    return_players = new Array()

    sails.log.debug "Player array #{ JSON.stringify player_array }"

    # finish_up = ( users ) ->
    #   sails.log.debug "Create users finish up #{ users.length }"
    #   cb( null, users )

    # recurse_users = ( counter, users ) ->
    cb( null, player_array )

  store_file_info: ( s3_object, org_id, team_id, file_name, cb) ->

    sails.log.debug "Hit the file tracker service/store_file_info"
    sails.log.debug "Data #{ s3_object  } #{ org_id  } #{ team_id } #{ file_name }"
    store_object = JSON.stringify s3_object
    sails.log.debug "Store object #{ s3_object.extra.Key}"

    FileTracker.create( 
      s3_object: store_object
      url: s3_object.extra.Location 
      file_name: file_name
      org: org_id
      team: team_id
      key: s3_object.extra.Key
      ).then( ( filetrack ) ->
      sails.log.debug "File tracker create #{ JSON.stringify filetrack }"
      # FileTracker.find( team_id: team_id ).exec ( err, fts ) ->
      #   if err?
      #     sails.log.debug "Find filetrackers err #{ JSON.stringify err }"
      #     cb(err)
      #   else
      #     sails.log.debug "Find filetrackers #{ JSON.stringify fts }"
      cb(null, filetrack )

    ).catch( ( err ) ->
      sails.log.debug "File tracker create error #{ JSON.stringify err }"
      cb("No good boss")
    )

  get_file_and_bucket_name: ( body, cb ) ->
    sails.log.debug "Hit the file service/get_file_and_bucket_name"
    sails.log.debug "Params #{ JSON.stringify body }"

    if ( body.team_name )?
      sails.log.debug "yep"
      team_name = body.team_name
      team_name = team_name.replace(/\s/g, "")
      sails.log.debug "No space #{ body.org_id }/#{ body.team_id}/#{ team_name }"
      return_name = "#{ body.org_id }/#{ body.team_id}/#{ team_name }.xls" #folder/file
      sails.log.debug "Return name #{ return_name }"
      cb( null, return_name )
    else
      sails.log.debug "nope"
      Org.findOne( id: body.org_id ).then( ( org ) ->
        sails.log.debug "File service get_file_and_bucket/Org findOne #{ JSON.stringify org }"
        return_name = "#{ body.org_id }/#{ org.name.replace(/[.,\/#!$%\^&\*;:{}=\-_`~()]/g,"").replace(/\s/g, "") }.xls"
        sails.log.debug "Return name #{ return_name }"
        cb( null, return_name )
      ).catch( ( err ) ->
        sails.log.debug "Org findOne error #{ JSON.stringify err }"
        cb( err )
      )
     

    

    

}