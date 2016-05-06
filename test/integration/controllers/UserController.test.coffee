
process.env.TEST = 'true'
request = require('supertest')

describe 'UserController', ->
  token = null
  user = null

  # it "should register a user", (done) ->
  #   request(sails.hooks.http.app).post('/auth/signup').set('Accept', 'application/json').send(
  #     'email': 'louisangelini@gmail.com'
  #     'password': 'Football1'
  #     'club_admin': true
  #     'team_admin': true).expect('Content-Type', /json/).expect(200).end (err, res) ->
  #     sails.log.debug "User register res"
      
      
  #     sails.log.debug "User registered #{ JSON.stringify user }"
  #     done()

    

  it 'should create user session for valid user', (done) ->
    request(sails.hooks.http.app).post('/auth/signin').set('Accept', 'application/json').send(
      'email': 'lllouis@yahoo.com'
      'password': 'Football1').expect('Content-Type', /json/).expect(200).end (err, res) ->
      sails.log.debug "res "
      token = res.body.token
      user = res.body.user
      sails.log.debug "error #{ JSON.stringify err if err? }"

      user.id.should.equal 1
      done()
      
    

  it "should find a user with id = 1", ( done ) ->
    sails.log.debug "token #{ token }"
    request( sails.hooks.http.app ).get('/user/1').set('Accept', 'application/json').set(
      'Authorization', "JWT #{ token }").expect(
      200).expect('Content-Type', /json/).end ( err, res )->
      sails.log.debug "/user/1 test response "
      sails.log.debug "Error #{ JSON.stringify err }" if err?
      res.body.id.should.equal 1
      sails.log.debug "*************************************************************"

      done()
    
  
  it "should update the users name", ( done ) ->
    request(sails.hooks.http.app).post('/user/edit/1').set('Accept', 'application/json').set(
      'Authorization', "JWT #{ token }").send(
      'firstName': "#{ user.firstName }s").expect('Content-Type', /json/).expect(200).end (err, res) ->
      sails.log.debug "res"
      sails.log.debug JSON.stringify res.body[0]
      sails.log.debug "error #{ JSON.stringify err if err? }"
      res.body[0].firstName.should.equal "#{ user.firstName }s"
      done()




#mocha test/bootstrap.test.coffee test/integration/**/*.test.coffee
