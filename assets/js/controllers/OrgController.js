'use strict';
angular.module('subzapp').controller('OrgController', [
  '$scope', '$state', '$http', '$window', '$location', 'user', 'RESOURCES', 'alertify', 'usSpinnerService', function($scope, $state, $http, $window, $location, user, RESOURCES, alertify, usSpinnerService) {
    var get_orgs, user_token;
    user_token = window.localStorage.getItem('user_token');
    get_orgs = function() {
      return $http({
        method: 'GET',
        url: RESOURCES.DOMAIN + "/orgs",
        headers: {
          'Authorization': "JWT " + user_token,
          "Content-Type": "application/json"
        }
      }).then(function(orgs) {
        console.log("Got orgs ");
        console.log(orgs.data);
        return $scope.orgs = orgs.data;
      })["catch"](function(err) {
        console.log("Got orgs error");
        console.log(err);
        if (err.status === 401) {
          alertify.error("You are not authorised to view this page");
          return $state.go('login');
        }
      });
    };
    console.log('Org Controller');
    if (!(window.USER != null)) {
      user.get_user().then((function(res) {
        return get_orgs();
      }), function(errResponse) {
        console.log("User get error " + (JSON.stringify(errResponse)));
        window.USER = null;
        return $state.go('login');
      });
    } else {
      get_orgs();
      console.log("USER already defined");
    }
    $scope.get_org_info = function(id) {
      usSpinnerService.spin('spinner-1');
      console.log($scope.org);
      return $http({
        method: 'GET',
        url: RESOURCES.DOMAIN + "/org/s3-info/" + $scope.org,
        headers: {
          'Authorization': "JWT " + user_token,
          "Content-Type": "application/json"
        }
      }).then((function(res) {
        usSpinnerService.stop('spinner-1');
        console.log("s3_info response");
        console.log(res.data);
        return $scope.files = res.data.Contents;
      }), function(errResponse) {
        usSpinnerService.stop('spinner-1');
        console.log("s3_info error response");
        console.log(err);
        if (err.status === 401) {
          alertify.error("You are not authorised to view this page");
          return $state.go('login');
        }
      });
    };
    return $scope.parse_users = function() {
      console.log('yep');
      return $http({
        method: 'POST',
        url: RESOURCES.DOMAIN + "/file/parse-players",
        headers: {
          'Authorization': "JWT " + user_token,
          "Content-Type": "application/json"
        },
        data: {
          org_id: 1
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
