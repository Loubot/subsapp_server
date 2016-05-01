# request = require('supertest')
# describe "data seeding", ->
#   it "should register a user", (done) ->
#     request(sails.hooks.http.app).post('/auth/signup').set('Accept', 'application/json').send(
#       'email': 'lllouis@yahoo.com'
#       'password': 'Football1'
#       'club_admin': true
#       'team_admin': true).expect('Content-Type', /json/).expect(200).end (err, res) ->
#       sails.log.debug "User register res"
      
#       token = res.body.token
#       user = res.body.user
#       sails.log.debug "User registered #{ JSON.stringify user }"
#       user.id.should.equal 1
#       done()

#   it "should create an org"