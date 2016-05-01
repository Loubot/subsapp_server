# process.env.TEST = 'true'
# request = require('supertest')

# describe "EventController", ->
#   token = null
#   it "should log in a user", ( done ) ->
#     request(sails.hooks.http.app).post('/auth/signin').set('Accept', 'application/json').send(
#       'email': 'lllouis@yahoo.com'
#       'password': 'Football1').expect('Content-Type', /json/).expect(200).end (err, res) ->
#       sails.log.debug "User logged in"
#       token = res.body.token
#       sails.log.debug "error #{ JSON.stringify err if err? }"
#       res.body.user.id.should.equal 1
#       # res.body.short_name.should.equal 'Test user'
#       # res.body.email.should.equal 'user_test@example.com'
#       # Save the cookie to use it later to retrieve the session
#       # Cookies = res.headers['set-cookie'].pop().split(';')[0]
#       done()

#   # it "should create an event", ( done ) ->
#     