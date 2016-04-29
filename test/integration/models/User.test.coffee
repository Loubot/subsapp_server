describe 'UserModel', ->
  describe '#findOne()', ->
    it 'should find a user', (done) ->
      User.findOne( id: 1 ).then((user) ->
        sails.log.debug user
        user.should.be.an.instanceOf(Object).and.have.property 'email', 'lllouis@yahoo.com'
        done()
        return
      ).catch done
      return
    return
  return