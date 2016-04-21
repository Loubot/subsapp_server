request = require('supertest')

describe 'Functional Test <Sessions>:', ->
  it 'should create user session for valid user', (done) ->
    request(sails.hooks.http.app).post('/auth/signin').set('Accept', 'application/json').send(
      'email': 'lllouis@yahoo.com'
      'password': 'Football1').expect('Content-Type', /json/).expect(200).end (err, res) ->
      sails.log.debug "res"
      sails.log.debug JSON.stringify res
      sails.log.debug JSON.stringify err if err?
      res.body.user.id.should.equal 1
      # res.body.short_name.should.equal 'Test user'
      # res.body.email.should.equal 'user_test@example.com'
      # Save the cookie to use it later to retrieve the session
      # Cookies = res.headers['set-cookie'].pop().split(';')[0]
      done()
      return
    return
    return
  return


# describe 'UserController', ->
#   describe '#findONe()', ->
#     it 'should return a user', (done) ->
#       request(sails.hooks.http.app).get('/user/1')
      
#       ).expect(302).expect 'location', '/mypage', done
#       return
#     return
#   return

# describe 'GET /user', ->
#   it 'user.name should be an case-insensitive match for "tobi"', (done) ->
#     request(app).get('/user').set('Accept', 'application/json').expect((res) ->
#       res.body.id = 'some fixed id'
#       res.body.name = res.body.name.toUpperCase()
#       return
#     ).expect 200, {
#       id: 'some fixed id'
#       name: 'TOBI'
#     }, done
#     return
#   return