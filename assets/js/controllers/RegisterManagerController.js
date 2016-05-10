'use strict';
angular.module('subzapp').controller('RegisterManagerController', [
  '$scope', '$state', '$http', '$window', 'alertify', '$location', 'RESOURCES', 'COMMS', function($scope, $state, $http, $window, alertify, $location, RESOURCES, COMMS) {
    console.log('Register Manager Controller');
    $scope.register_manager_form_data = $location.search();
    console.log($location.search());
    $http({
      method: 'GET',
      url: RESOURCES.DOMAIN + "/get-invite",
      headers: {
        'Content-Type': 'application/json'
      },
      params: {
        invite_id: $location.search().id
      }
    }).then((function(response) {
      console.log("Get invite response");
      console.log(response.data);
      window.localStorage.setItem('team_id', response.data.team_id);
      $scope.register_manager_form_data = response.data;
      $scope.register_manager_form_data.invited_email = response.data.invited_email;
      return $scope.team_id = response.data.team_id;
    }), function(errResponse) {
      console.log("Get invite error");
      return console.log(errResponse);
    });
    return $scope.register_manager_submit = function() {
      console.log(JSON.stringify($scope.register_manager_form_data));
      $scope.register_manager_form_data.team_admin = true;
      $scope.register_manager_form_data.team_id = $scope.team_id;
      $scope.register_manager_form_data.email = $scope.register_manager_form_data.invited_email;
      delete $scope.register_manager_form_data.invited_email;
      console.log($scope.register_manager_form_data);
      return COMMS.POST("/auth/signup/team_manager", $scope.register_manager_form_data).then((function(response) {
        console.log("Registration successfull ");
        console.log(response);
        window.localStorage.setItem('user_token', response.data.token);
        window.localStorage.setItem('user_id', response.data.user.id);
        return $state.go('team_manager');
      }), function(errResponse) {
        console.log("Registration failed ");
        alertify.error("Registration failed " + (JSON.stringify(errResponse)));
        setTimeout((function() {
          return $state.go('login');
        }), 5000);
        return console.log(errResponse);
      });
    };
  }
]);

//# sourceMappingURL=../maps/controllers/RegisterManagerController.js.map
