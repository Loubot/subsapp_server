Sails = require('sails')
# Global before hook
before (done) ->
  # Lift Sails with test database
  Sails.lift {
    log: level: 'error'
    models:
      connection: 'test'
      migrate: 'drop'
  }, (err) ->
    if err
      return done(err)
    # Anything else you need to set up
    # ...
    done()
    return
  return
# Global after hook
after (done) ->
  console.log()
  # Skip a line before displaying Sails lowering logs
  Sails.lower done
  return