'use strict';
angular.module('subzapp').controller('EventController', [
  '$scope', '$state', '$http', '$location', '$window', 'user', 'RESOURCES', 'alertify', function($scope, $state, $http, $location, $window, user, RESOURCES, alertify) {
    var user_token;
    console.log('Event Controller');
    user_token = window.localStorage.getItem('user_token');
    if (!(window.USER != null)) {
      user.get_user().then((function(res) {}), function(errResponse) {
        console.log("User get error " + (JSON.stringify(errResponse)));
        window.USER = null;
        return $state.go('login');
      });
    } else {
      console.log("USER already defined");
      $scope.org = window.USER.orgs[0];
    }
    console.log("id " + ($location.search().id));
    return $http({
      method: 'GET',
      url: RESOURCES.DOMAIN + "/get-event-members",
      headers: {
        'Authorization': "JWT " + user_token,
        "Content-Type": "application/json"
      },
      params: {
        event_id: $location.search().id
      }
    }).then((function(res) {
      console.log("Get team members response");
      console.log(res);
      return $scope.event_members = res.data.event_user;
    }), function(errResponse) {
      console.log("Get event members error ");
      return console.log(errResponse);
    });
  }
]);
