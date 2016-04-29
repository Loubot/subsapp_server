process.env.TEST = 'true'
request = require('supertest')

describe "EventController", ->
  token = null
  it "should log in a user", ( done ) ->
    request(sails.hooks.http.app).post('/auth/signup').set('Accept', 'application/json').send(
      'email': 'lllouis@yahoo.com'
      'password': 'Football1').expect('Content-Type', /json/).expect(200).end (err, res) ->
      sails.log.debug "User signin"
      # sails.log.debug JSON.stringify res
      token = res.body.token
      done()

  it "should create an event"