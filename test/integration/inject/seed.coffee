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

describe "Seed data", ->
  it "should create a kid", ( done ) ->
    User.create( 
      "email":null,"password":null,"firstName":"Louis","lastName":"Angelini","address":"","dob":"8-10-1998","mobile_number1":"0851231558","mobile_number2":null,"fair_number":null,"dob_stamp":"1998-08-10","super_admin":null,"club_admin":"0","team_admin":"0","parent_email":"louisangelini@gmail.com","under_age":"1"
    ).then( ( kid ) ->
      kid.parent_email.should.equal( "louisangelini@gmail.com" )
      done()
    ).catch( ( err ) ->
      done( err )
    )