# process.env.TEST = 'true'
# request = require('supertest')

# describe 'UserController', ->
#   token = null
#   user = null

#   it "should register a user", (done) ->
#     request(sails.hooks.http.app).post('/auth/signup').set('Accept', 'application/json').send(
#       'email': 'lllouis@yahoo.com'
#       'password': 'Football1').expect('Content-Type', /json/).expect(200).end (err, res) ->
#       sails.log.debug "User register res"
      
#       token = res.body.token
#       user = res.body.user
#       sails.log.debug "User registered #{ JSON.stringify user }"
#       user.id.should.equal 1
#       done()

    

#   it 'should create user session for valid user', (done) ->
#     request(sails.hooks.http.app).post('/auth/signin').set('Accept', 'application/json').send(
#       'email': 'lllouis@yahoo.com'
#       'password': 'Football1').expect('Content-Type', /json/).expect(200).end (err, res) ->
#       sails.log.debug "res"
      
#       sails.log.debug "error #{ JSON.stringify err if err? }"
#       user.id.should.equal 1
#       # res.body.short_name.should.equal 'Test user'
#       # res.body.email.should.equal 'user_test@example.com'
#       # Save the cookie to use it later to retrieve the session
#       # Cookies = res.headers['set-cookie'].pop().split(';')[0]
#       done()
      
    

#   it "should find a user with id = 1", ( done ) ->
#     sails.log.debug "token #{ token }"
#     request( sails.hooks.http.app ).get('/user/1').set('Accept', 'application/json').set(
#       'Authorization', "JWT #{ token }").expect(
#       200).expect('Content-Type', /json/).end ( err, res )->
#       sails.log.debug "res"
#       sails.log.debug JSON.stringify res.body
#       sails.log.debug "Error #{ JSON.stringify err }" if err?
#       res.body.id.should.equal 1
#       sails.log.debug "*************************************************************"

#       done()
    
  
#   it "should update the users name", ( done ) ->
#     request(sails.hooks.http.app).post('/user/edit/1').set('Accept', 'application/json').set(
#       'Authorization', "JWT #{ token }").send(
#       'firstName': "#{ user.firstName }s").expect('Content-Type', /json/).expect(200).end (err, res) ->
#       sails.log.debug "res"
#       sails.log.debug JSON.stringify res.body[0]
#       sails.log.debug "error #{ JSON.stringify err if err? }"
#       res.body[0].firstName.should.equal "#{ user.firstName }s"
#       # res.body.short_name.should.equal 'Test user'
#       # res.body.email.should.equal 'user_test@example.com'
#       # Save the cookie to use it later to retrieve the session
#       # Cookies = res.headers['set-cookie'].pop().split(';')[0]
#       done()




# #mocha test/bootstrap.test.coffee test/integration/**/*.test.coffee
