request = require('supertest')
describe 'UserModel', ->
  test_user = null
  describe 'create', ->
    it "should register a user", (done) ->
      request(sails.hooks.http.app).post('/auth/signup').set('Accept', 'application/json').send(
        'email': 'lllouis@yahoo.com'
        'password': 'Football1'
        'club_admin': true
        'team_admin': true).expect('Content-Type', /json/).expect(200).end (err, res) ->
        sails.log.debug "User register res #{ JSON.stringify res.body }"
        
        token = res.body.token
        user = res.body.user
        sails.log.debug "User registered"
        user.id.should.equal 1
        done()

  describe "find a user", ->

    it "should not have a password", ( done ) ->
      User.findOne( id: 1 ).then( ( user ) ->
        sails.log.debug "User found #{ JSON.stringify user.id }"
        user.email.should.equal("lllouis@yahoo.com")
        user.id.should.equal( 1 )
        user.password.should.not.equal( "Football1" )
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
