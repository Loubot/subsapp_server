describe "Team model", ->
  describe "create", ->

    it "should create a team", ( done ) ->
      Team.create(
        name: "U17 boys"
        main_org: 1
        done()
      ).then( ( team ) ->
        sails.log.debug "Team created #{ JSON.stringify team }"
        team.id.should.equal( 1 )
      ).catch( ( err ) ->
        done( err )
      )

  describe "update", ->

    it "should update a teams eligible_date", ( done ) ->
      Team.update( 
        id: 1
        {
          eligible_date: "1979-01-01T00:00:00.000Z"
          eligible_date_end: "1979-12-31T00:00:00.000Z"
        }
      ).then( ( team ) ->
        or_eligible_date = new Date("1979-01-01 00:00:00.000 -0000").getTime()
        or_eligible_date_end = new Date( "1979-12-31T00:00:00.000Z" ).getTime()

        returned_eligible_date = new Date( team[0].eligible_date ).getTime()
        returned_eligible_date.should.equal( or_eligible_date )
        
        returned_eligible_date_end = new Date( team[0].eligible_date_end ).getTime()
        or_eligible_date_end.should.equal( returned_eligible_date_end )
        done()
      ).catch( ( err ) -> 
        done( err )
      ) 


  # describe "associate", ->

  #   it "should associate user_id ", ( done ) ->
  #     Team.findOne( id: 1 ).then( ( team ) ->
  #       sails.log.debug "Team #{ JSON.stringify team }"
  #       team.events.add( 1 )
  #       team.save().then( ( team_saved ) ->
  #         sails.log.debug "Team saved #{ JSON.stringify team_saved }"
  #         done()
  #       ).catch( ( team_save_err ) ->
  #         done( team_save_err )
  #       )
  #     ).catch( ( team_err ) ->
  #       sails.log.debug "Team error #{ JSON.stringify team_err }"
  #       done( team_err )
  #     )


    