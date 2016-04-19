sails = require('sails')
before (done) ->
  # Increase the Mocha timeout so that Sails has enough time to lift.
  @timeout 30000
  sails.log.debug "Hello"
  sails.lift {}, (err, server) ->
    if err
      return done(err)
    # here you can load fixtures, etc.
    done err, sails
    return
  return
after (done) ->
  # here you can clear fixtures, etc.
  sails.lower done
  return