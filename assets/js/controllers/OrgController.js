'use strict';
angular.module('subzapp').controller('OrgController', [
  '$scope', '$state', '$http', '$window', '$location', 'user', 'RESOURCES', 'alertify', function($scope, $state, $http, $window, $location, user, RESOURCES, alertify) {
    var check_club_admin, user_token;
    user_token = window.localStorage.getItem('user_token');
    check_club_admin = function(user) {
      if (!user.team_admin) {
        $state.go('login');
      }
      alertify.error('You are not a club admin. Contact subzapp admin team for assitance');
      return false;
    };
    console.log('Org Controller');
    if (!(window.USER != null)) {
      user.get_user().then((function(res) {
        return $scope.org = window.USER.orgs[0];
      }), function(errResponse) {
        console.log("User get error " + (JSON.stringify(errResponse)));
        window.USER = null;
        return $state.go('login');
      });
    } else {
      console.log("USER already defined");
      $scope.org = window.USER.orgs[0];
    }
    return $scope.parse_users = function() {
      return $http({
        method: 'GET',
        url: RESOURCES.DOMAIN + "/parse-players",
        headers: {
          'Authorization': "JWT " + user_token,
          "Content-Type": "application/json"
        }
      }).then((function(res) {
        console.log("parse users response");
        console.log(res);
        return $scope.parsed_data = res;
      }), function(errResponse) {
        console.log("Parse users error");
        return console.log(errResponse);
      });
    };
  }
]);

//# sourceMappingURL=../maps/controllers/OrgController.js.map