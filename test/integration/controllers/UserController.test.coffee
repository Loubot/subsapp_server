request = require('supertest')

before ( done ) ->


describe "UserController", ->
  describe '#findOne', ->
    it 'should be successful', (done) ->
      request(sails.hooks.http.app).get('/org/1').expect(200).end done
      return
    return
  return