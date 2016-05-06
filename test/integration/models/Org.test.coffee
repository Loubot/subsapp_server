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

  # describe "associate location", ->
  #   it "should associate an location", ( done ) ->
  #     Org.findOne( id: 1 ).then( ( org ) ->
  #       sails.log.debug "Org found #{ JSON.stringify org }"
  #       org.org_locations.add( 1 )
  #       org.save( ( org_save_err, org_saved ) ->
  #         sails.log.debug "Org saved #{ JSON.stringify org_saved }"
  #         Org.findOne( id: 1 ).populate('org_locations').then( ( updated_org ) ->
  #           sails.log.debug "Updated org #{ JSON.stringify updated_org.toObject() }"
  #           done()
  #         ).catch( ( updated_org_err) ->
  #           sails.log.debug "updated_org_err #{ JSON.stringify updated_org_err }"
  #           done( updated_org_err )
  #         )
  #       )
  #     ).catch( ( err ) ->
  #       done( err )
  #     )