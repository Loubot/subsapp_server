request = require('supertest')
describe 'UserModel', ->
  test_user = null
  describe 'create', ->
    it "should create a user", (done) ->
      User.create(
        'email': 'lllouis@yahoo.com'
        'password': 'Football1'
        'club_admin': true
        'team_admin': true
      ).then( ( user ) ->
        sails.log.debug "user #{ JSON.stringify user }"
        user.id.should.equal( 1 )
        done()
      ).catch( ( err ) ->
        done( err )
      )

      
  describe "find a user", ->

    it "should not have a hashed password", ( done ) ->
      User.findOne( id: 1 ).then( ( user ) ->
        sails.log.debug "User found #{ JSON.stringify user }"
        user.email.should.equal("lllouis@yahoo.com")
        user.id.should.equal( 1 )
        user.password.should.not.equal( "Football1" )
        user.club_admin.should.equal( true )
        user.team_admin.should.equal( true )
        test_user = user
        done()
      ).catch( ( err ) ->
        sails.log.debug "User find err "
        done( err )
      )

  describe "update a user", ->

    it "should update correctly", ( done ) ->
      User.update( id: 1, { firstName: "#{ test_user }s" }).then( (user) ->
        sails.log.debug "User updated #{ JSON.stringify user }"
        # res.status(204)
        user[0].firstName.should.equal "#{ test_user }s"
        done()
      ).catch( ( err ) ->
        sails.log.debug "Edit user error #{ JSON.stringify err }"
        done( err )
      )
