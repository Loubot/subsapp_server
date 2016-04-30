describe "Location model", ->

  describe "create", ->
    it "should create a location", ( done ) ->
      Location.create(
        address: "Lakewood, Ballincollig, Cork"
        location_owner: "Lakewood F.C."
        location_name: "Main address of Lakewood F.C."
      ).then( ( location ) ->
        location.location_name.should.equal( "Main address of Lakewood F.C." )
        done()
      ).catch( ( err ) ->
        done( err )
      )