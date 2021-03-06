'use strict';
angular.module('subzapp').controller('RegisterController', [
  '$scope', '$state', '$http', '$window', 'alertify', 'RESOURCES', function($scope, $state, $http, $window, alertify, RESOURCES) {
    console.log('Register Controller');
    return $scope.register_submit = function() {
      $scope.register_form_data.club_admin = true;
      $scope.register_form_data.team_admin = true;
      console.log($scope.register_form_data);
      return $http({
        method: 'POST',
        url: RESOURCES.DOMAIN + "/auth/signup",
        headers: {
          'Content-Type': 'application/json'
        },
        data: $scope.register_form_data
      }).then((function(response) {
        console.log("Registration successfull");
        console.log(response);
        window.localStorage.setItem('user_token', response.data.token);
        console.log("user_token " + window.localStorage.getItem('user_token'));
        window.localStorage.setItem('user_id', response.data.user.id);
        alertify.success('Welcome');
        return $state.go('org_admin');
      }), function(errResponse) {
        console.log("Registration failed ");
        setTimeout((function() {
          return $state.go('login');
        }), 5000);
        console.log(errResponse);
        console.log(errResponse.data.invalidAttributes.email[0].message);
        return alertify.error(errResponse.data.invalidAttributes.email[0].message);
      });
    };
  }
]);

//# sourceMappingURL=../maps/controllers/RegisterController.js.map
