process.env.TEST = 'true'
request = require('supertest')

describe "OrgController", ->
  token = null
  it "should log in a user", ( done ) ->
    request(sails.hooks.http.app).post('/auth/signin').set('Accept', 'application/json').send(
      'email': 'lllouis@yahoo.com'
      'password': 'Football1').expect('Content-Type', /json/).expect(200).end (err, res) ->
      sails.log.debug "User logged in"
      token = res.body.token
      sails.log.debug "error #{ JSON.stringify err if err? }"
      res.body.user.id.should.equal 1
      # res.body.short_name.should.equal 'Test user'
      # res.body.email.should.equal 'user_test@example.com'
      # Save the cookie to use it later to retrieve the session
      # Cookies = res.headers['set-cookie'].pop().split(';')[0]
      done()

  it "should create an org", ( done ) ->
    request(sails.hooks.http.app).post('/org').set('Accept', 'application/json').set(
      'Authorization', "JWT #{ token }").send(
      "name":"Lakewood A.F.C."
      "address":"Lakewood, Ballincollig, Cork"
      "user_id":"1").expect('Content-Type', /json/).expect(200).end ( err, res ) ->
      sails.log.debug "Org create"

      sails.log.debug "res.body #{ JSON.stringify res.body }"
      res.body.org.name.should.equal "Lakewood A.F.C."
      res.body.location.org_id[0].name.should.equal "Lakewood A.F.C."
      res.body.location.location_owner.should.equal "Lakewood A.F.C."
      res.body.location.location_name.should.equal "Main address of Lakewood A.F.C."
      sails.log.debug JSON.stringify err

      done()