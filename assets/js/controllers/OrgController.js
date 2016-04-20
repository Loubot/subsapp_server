'use strict';
angular.module('subzapp').controller('OrgController', [
  '$scope', '$state', 'COMMS', '$window', '$location', 'user', 'RESOURCES', 'alertify', function($scope, $state, COMMS, $window, $location, user, RESOURCES, alertify) {
    var get_orgs, user_token;
    user_token = window.localStorage.getItem('user_token');
    get_orgs = function() {
      return COMMS.GET('/orgs').then(function(orgs) {
        console.log("Got orgs ");
        console.log(orgs.data);
        return $scope.orgs = orgs.data;
      })["catch"](function(err) {
        console.log("Got orgs error");
        console.log(err);
        return $state.go('login');
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
      console.log("/org/s3-info/" + $scope.org);
      console.log($scope.org);
      return COMMS.GET("/org/s3-info/" + $scope.org).then((function(res) {
        console.log("s3_info response");
        console.log(res.data);
        return $scope.files = res.data.Contents;
      }), function(errResponse) {
        console.log("s3_info error response");
        console.log(errResponse);
        if (errResponse.status === 401) {
          alertify.error("You are not authorised to view this page");
          return $state.go('login');
        }
      });
    };
    return $scope.parse_users = function() {
      console.log('yep');
      return COMMS.POST("/file/parse-players/", {
        org_id: $scope.org
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
