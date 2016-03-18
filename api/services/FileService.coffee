

module.exports = {

  get_org_files: ( body, cb ) ->
    Promise = require('bluebird')
    AWS = require('aws-sdk')

    AWS.config.update({accessKeyId: process.env.AWS_ACCESS_KEY_ID, secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY})

    s3 = Promise.promisifyAll(new AWS.S3())
    params = 
      Bucket: 'subzapp'
      Prefix: String( body.org_id )

    s3.listObjectsAsync( params ).then( ( bucket ) ->
      sails.log.debug "s3 bucket #{ JSON.stringify bucket }"
      file_keys = new Array()
      for file in bucket.Contents
        sails.log.debug "Log Key #{ file.Key }"
        file_keys.push( file.Key )

      cb( null, file_keys )  
    
    
    ).catch( ( s3_bucket_err ) ->
      sails.log.debug "S3 error #{ JSON.stringify s3_bucket_err }"
      cb( s3_bucket_err )
    )


  get_file_body: ( file, cb ) ->
    sails "Hit the file service/get_file_body"
    if file.body?
      cb( null, file.body )
    else
      cb( "Can't get file.body" )




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