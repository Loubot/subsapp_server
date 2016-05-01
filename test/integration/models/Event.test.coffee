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
        event.id.should.equal( 1 )
      ).catch( ( err ) ->
        done( err )
      )
