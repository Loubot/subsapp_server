describe "Location model", ->

  describe "create", ->
    it "should create a location", ( done ) ->
      Location.create(
        address: "Lakewood, Ballincollig, Cork"
        location_owner: "Lakewood F.C."
        location_name: "Main address of Lakewood F.C."
      ).then( ( location ) ->
        sails.log.debug "Location #{ JSON.stringify location }"
        location.id.should.equal( 1 )
        location.address.should.equal( "Lakewood, Ballincollig, Cork" )
        location.location_name.should.equal( "Main address of Lakewood F.C." )
        location.location_owner.should.equal( "Lakewood F.C." )
        location.lat.toFixed( 2 ).should.equal( "51.89" )
        location.lng.toFixed( 2 ).should.equal( "-8.59" )
        done()
      ).catch( ( err ) ->
        done( err )
      )

  describe "update", ->

    it "should update a location", ( done ) ->
      Location.update( 
        id: 1
        {
          address: "Lakewood, Ballincollig, Corks"
        }
      ).then( ( location ) ->
        location[0].id.should.equal( 1 )
        location[0].address.should.equal( "Lakewood, Ballincollig, Corks" )
        location[0].location_name.should.equal( "Main address of Lakewood F.C." )
        location[0].location_owner.should.equal( "Lakewood F.C." )
        location[0].lat.toFixed( 2 ).should.equal( "51.89" )
        location[0].lng.toFixed( 2 ).should.equal( "-8.59" )
        done()
      ).catch( ( err ) -> 
        done( err )
      )

  describe "associate org", ->
    it "should associate an org", ( done ) ->
      Location.findOne( id: 1 ).then( ( location ) ->
        sails.log.debug "Location found #{ JSON.stringify location }"
        location.org_id.add( 1 ) 
        location.save ( location_save_err, location_saved ) ->
          sails.log.debug "here #{ JSON.stringify location_saved.org_id[0] }"
          location_saved.org_id[0].id.should.equal( 1 )
          done()
      ).catch( ( err ) ->
        done( err )
      )