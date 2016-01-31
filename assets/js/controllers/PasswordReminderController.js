'use strict';
angular.module('subzapp').controller('PasswordReminderController', [
  '$scope', '$state', '$http', '$window', 'user', '$location', 'RESOURCES', 'alertify', function($scope, $state, $http, $window, user, $location, RESOURCES, alertify) {
    var remind_password_token, user_token;
    console.log('PasswordReminder Controller');
    user_token = window.localStorage.getItem('user_token');
    remind_password_token = $location.search().remind_password_token;
    return $scope.password_remind = function() {
      console.log($scope.password_remind_data);
      return $http({
        method: 'POST',
        url: RESOURCES.DOMAIN + "/post_remind",
        headers: {
          'Authorization': "JWT " + user_token,
          "Content-Type": "application/json"
        },
        data: {
          user_email: $scope.password_remind_data.email
        }
      }).then((function(response) {
        console.log("Send password reminder mail");
        console.log(response);
        return alertify.success("Password Reminder sent ok");
      }), function(errResponse) {
        console.log("Send Password Reminder email");
        console.log(errResponse);
        alertify.error(errResponse.message);
        return $state.go('password-reminder');
      });
    };
  }
]);
