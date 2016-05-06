describe "Event model", ->
  
  describe "create", ->
     
    it "should create a new event", ( done ) ->
      start_date = 
      Event.create(
        name:"TEST"
        details:"TEST"
        start_date: "2016-05-31T18:00:00.000Z"
        end_date: "2016-05-31T20:00:00.000Z"
        price: 5
        location_id: 1
        team_id: 1
        user_id: 1
        event_team :1
        done()
      ).then( ( event ) ->
        sails.log.debug "Event created #{ JSON.stringify event }"
        global_event = event
        event.id.should.equal( 1 )
      ).catch( ( err ) ->
        done( err )
      )


  describe "associate", ->

    it "should associate with a user", ( done ) ->
      Event.findOne( id: 1 ).then( ( event) ->
        sails.log.debug "Event found #{ JSON.stringify event }"
        event.event_user.add( 1 )
        event.save().then( ( event_saved ) ->
          sails.log.debug "Event saved #{ JSON.stringify event_saved }"
          event_saved.event_user[0].email.should.equal( "lllouis@yahoo.com" )
          event_saved.event_user[0].id.should.equal( 1 )
          done()
        ).catch( ( event_saved_err ) ->
          done( event_saved_err )
        )
      ).catch( ( event_err ) ->
        done( event_err )
      )
 


    # it "should associate events ", ( done ) ->
    #   Event.findOne( id: 1 ).populateAll().then( ( event) ->
    #     sails.log.debug "Event found #{ JSON.stringify event }"
    #     event.event_team.add( 1 )
    #     event.save().then( ( event_saved ) ->
    #       sails.log.debug "Event saved #{ JSON.stringify event_saved }"
          
    #       done()
    #     ).catch( ( event_saved_err ) ->
    #       done( event_saved_err )
    #     )
    #   ).catch( ( event_err ) ->
    #     done( event_err )
    #   )
