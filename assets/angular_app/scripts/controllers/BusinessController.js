// Generated by CoffeeScript 1.10.0
'use strict';
angular.module('subzapp').controller('BusinessController', [
  '$scope', '$state', '$http', '$window', 'message', 'RESOURCES', function($scope, $state, $http, $window, message, RESOURCES) {
    var user_token;
    console.log('Business Controller');
    user_token = JSON.parse(window.localStorage.getItem('user_token'));
    return $http({
      method: 'GET',
      url: RESOURCES.DOMAIN + "/find-all",
      headers: {
        'Authorization': "JWT " + user_token,
        "Content-Type": "application/json"
      }
    }).then((function(response) {
      return console.log("Business respons " + (JSON.stringify(response)));
    }), function(errResponse) {
      console.log("Business error " + (JSON.stringify(err)));
      return message.error(errResponse.data.message);
    });
  }
]);
