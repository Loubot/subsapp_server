

module.exports = {

  store_file_info: ( s3_object, org_id, cb) ->    
    sails.log.debug "Hit the file tracker service/store_file_info"
    

    FileTracker.create( url: s3_object.extra.Location, file_name: s3_object.filename ).then( ( filetrack ) ->
      sails.log.debug "File tracker create #{ JSON.stringify filetrack }"
      cb( null, filetrack )

    ).catch( ( err ) ->
      sails.log.debug "File tracker create error #{ JSON.stringify err }"
      cb("No good boss")
    )

}