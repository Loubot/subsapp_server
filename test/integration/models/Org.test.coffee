describe "Org model", ->

  describe "create", ->
    it "should create an org", ( done ) ->
      Org.create( 
        name: "Lakewood F.C."
        user_id: 1        
      ).then( ( org ) ->
        org.id.should.equal( 1 )
        org.name.should.equal( "Lakewood F.C." )
        done()
      ).catch( ( err ) -> 
        done( err )
      )


  describe "update", ->
    it "should update an org", ( done ) ->
      Org.update( 
        id: 1
        {
          name: "Lakewood F.C.s"
        }
      ).then( ( org ) ->
        org[0].id.should.equal( 1 )
        org[0].name.should.equal( "Lakewood F.C.s" )
        done()
      ).catch( ( err ) -> 
        done( err )
      )

 # describe "associate", ->

 #  it "should associate user_id ", ( done ) ->
 #    Org.findOne( id: 1 ).then( ( org ) ->
 #      sails.log.debug "Org #{ JSON.stringify org }"
 #      org.user_id.add( 1 )
 #      org.save().then( ( org_saved ) ->
 #        sails.log.debug "Org saved #{ JSON.stringify org_saved }"
 #        done()
 #      ).catch( ( org_save_err ) ->
 #        done( org_save_err )
 #      )
 #    ).catch( ( org_err ) ->
 #      sails.log.debug "Org error #{ JSON.stringify org_err }"
 #      done( org_err )
 #    )