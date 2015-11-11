// Generated by CoffeeScript 1.10.0

/**
 * Passport configuration file where you should configure strategies
 */
var ALGORITHM, AUDIENCE, EXPIRES_IN_MINUTES, ISSUER, JWT_STRATEGY_CONFIG, JwtStrategy, LOCAL_STRATEGY_CONFIG, LocalStrategy, SECRET, _onJwtStrategyAuth, _onLocalStrategyAuth, passport;

passport = require('passport');

LocalStrategy = require('passport-local').Strategy;

JwtStrategy = require('passport-jwt').Strategy;

EXPIRES_IN_MINUTES = 60 * 24;

SECRET = process.env.tokenSecret || '4ukI0uIVnB3iI1yxj646fVXSE3ZVk4doZgz6fTbNg7jO41EAtl20J5F7Trtwe7OM';

ALGORITHM = 'HS256';

ISSUER = 'nozus.com';

AUDIENCE = 'nozus.com';


/**
 * Configuration object for local strategy
 */

LOCAL_STRATEGY_CONFIG = {
  usernameField: 'email',
  passwordField: 'password',
  passReqToCallback: false
};


/**
 * Configuration object for JWT strategy
 */

JWT_STRATEGY_CONFIG = {
  secretOrKey: SECRET,
  issuer: ISSUER,
  audience: AUDIENCE,
  passReqToCallback: false
};


/**
 * Triggers when user authenticates via local strategy
 */

_onLocalStrategyAuth = function(email, password, next) {
  User.findOne({
    email: email
  }).exec(function(error, user) {
    if (error) {
      return next(error, false, {});
    }
    if (!user) {
      return next(null, false, {
        code: 'E_USER_NOT_FOUND',
        message: email + ' is not found'
      });
    }
    if (!CipherService.comparePassword(password, user)) {
      return next(null, false, {
        code: 'E_WRONG_PASSWORD',
        message: 'Password is wrong'
      });
    }
    return next(null, user, {});
  });
};


/**
 * Triggers when user authenticates via JWT strategy
 */

_onJwtStrategyAuth = function(payload, next) {
  var user;
  user = payload.user;
  return next(null, user, {});
};

passport.use(new LocalStrategy(LOCAL_STRATEGY_CONFIG, _onLocalStrategyAuth));

passport.use(new JwtStrategy(JWT_STRATEGY_CONFIG, _onJwtStrategyAuth));

module.exports.jwtSettings = {
  expiresInMinutes: EXPIRES_IN_MINUTES,
  secret: SECRET,
  algorithm: ALGORITHM,
  issuer: ISSUER,
  audience: AUDIENCE
};
