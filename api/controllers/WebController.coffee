###*
# UserController
#
# @description :: Server-side logic for managing Web pages
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
###

module.exports = {
  homepage: (req, res) ->
    sails.log.debug 'This is the homepage'
    res.view('homepage')

  welcome: (req, res)  ->
    sails.log.debug 'This is the welcome page'
    res.view('webcontroller/welcome')

  register: (req, res) ->
    sails.log.debug 'This is the register page'
    res.view('webcontroller/register')
}