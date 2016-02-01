

module.exports = {

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

}