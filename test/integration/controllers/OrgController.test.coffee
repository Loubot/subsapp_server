process.env.TEST = 'true'
request = require('supertest')

describe "OrgController", ->
  token = null
  it "should log in a user", ( done ) ->
    request(sails.hooks.http.app).post('/auth/signup').set('Accept', 'application/json').send(
      'email': 'lllouis@yahoo.com'
      'password': 'Football1'
      'club_admin': true
      'team_admin': true).expect('Content-Type', /json/).expect(200).end (err, res) ->
      sails.log.debug "User signup"
      sails.log.debug JSON.stringify res
      token = res.body.token
      done()

  it "should create an org", ( done ) ->
    request(sails.hooks.http.app).post('/org').set('Accept', 'application/json').set(
      'Authorization', "JWT #{ token }").send(
      "name":"Lakewood A.F.C."
      "address":"Lakewood, Ballincollig, Cork"
      "user_id":"1").expect('Content-Type', /json/).expect(200).end ( err, res ) ->
      sails.log.debug "Org create"

      sails.log.debug "res.body #{ JSON.stringify res.body }"
      res.body.name.should.equal "Lakewood A.F.C."
      sails.log.debug JSON.stringify err

      done()