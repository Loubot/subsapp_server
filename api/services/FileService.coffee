

module.exports = {

  store_file_info: ( s3_object, org_id, team_id, file_name, cb) ->

    sails.log.debug "Hit the file tracker service/store_file_info"
    sails.log.debug "Data #{ s3_object  } #{ org_id  } #{ team_id } #{ file_name }"
    

    FileTracker.create( 
      url: s3_object.extra.Location, 
      file_name: file_name,
      org: org_id,
      team: team_id
      ).then( ( filetrack ) ->
      sails.log.debug "File tracker create #{ JSON.stringify filetrack }"
      FileTracker.find( team_id: team_id ).exec ( err, fts ) ->
        if err?
          sails.log.debug "Find filetrackers err #{ JSON.stringify err }"
          cb(err)
        else
          sails.log.debug "Find filetrackers #{ JSON.stringify fts }"
          cb(null, fts)

    ).catch( ( err ) ->
      sails.log.debug "File tracker create error #{ JSON.stringify err }"
      cb("No good boss")
    )

}