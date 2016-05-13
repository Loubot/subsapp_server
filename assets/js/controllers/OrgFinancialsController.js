'use strict';
angular.module('subzapp').controller('OrgFinancialsController', [
  '$scope', '$rootScope', '$state', '$http', 'RESOURCES', '$location', 'alertify', 'user', 'COMMS', function($scope, $rootScope, $state, $http, RESOURCES, $location, alertify, user, COMMS) {
    var afterTomorrow, check_for_stripe_code, disabled, getDayClass, tomorrow;
    console.log("OrgFinancialsController");
    check_for_stripe_code = function() {
      if ($location.search().code != null) {
        console.log($location.search().code);
        return COMMS.POST("/payment/" + $scope.org.id + "/authenticate-stripe", {
          auth_code: $location.search().code
        }).then((function(res) {
          var message;
          console.log("Authenticated stripe");
          message = JSON.parse(res.data.body);
          console.log(message.error_description);
          if (message.error_description != null) {
            return alertify.error(message.error_description);
          } else {
            return alertify.success("Authenticated stripe");
          }
        }), function(errResponse) {
          console.log("Failed to authenticate stripe");
          alertify.error("Failed to authenticate stripe");
          return console.log(errResponse);
        });
      }
    };
    user.get_user().then(function(res) {
      $scope.user = $rootScope.USER;
      return COMMS.GET("/org/" + $scope.user.org[0].id).then((function(res) {
        console.log("Got org info");
        console.log(res.data.org);
        $scope.org = res.data.org;
        alertify.success("Got org info");
        return check_for_stripe_code();
      }), function(errResponse) {
        console.log("Get org error");
        console.log.errResponse;
        return alertify.error("Failed to get org info");
      });
    });
    disabled = function(data) {
      var date, mode;
      date = data.date;
      mode = data.mode;
      return mode === 'day' && (date.getDay() === 0 || date.getDay() === 6);
    };
    getDayClass = function(data) {
      var currentDay, date, dayToCheck, i, mode;
      date = data.date;
      mode = data.mode;
      if (mode === 'day') {
        dayToCheck = new Date(date).setHours(0, 0, 0, 0);
        i = 0;
        while (i < $scope.events.length) {
          currentDay = new Date($scope.events[i].date).setHours(0, 0, 0, 0);
          if (dayToCheck === currentDay) {
            return $scope.events[i].status;
          }
          i++;
        }
      }
      return '';
    };
    $scope.today = function() {
      $scope.dt = new Date;
    };
    $scope.today();
    $scope.clear = function() {
      $scope.dt = null;
    };
    $scope.inlineOptions = {
      customClass: getDayClass,
      minDate: new Date,
      showWeeks: true
    };
    $scope.dateOptions = {
      dateDisabled: disabled,
      formatYear: 'yy',
      maxDate: new Date(2020, 5, 22),
      minDate: new Date,
      startingDay: 1
    };
    $scope.toggleMin = function() {
      $scope.inlineOptions.minDate = $scope.inlineOptions.minDate ? null : new Date;
      $scope.dateOptions.minDate = $scope.inlineOptions.minDate;
    };
    $scope.toggleMin();
    $scope.open1 = function() {
      $scope.popup1.opened = true;
    };
    $scope.open2 = function() {
      $scope.popup2.opened = true;
    };
    $scope.setDate = function(year, month, day) {
      $scope.dt = new Date(year, month, day);
    };
    $scope.formats = ['dd-MMMM-yyyy', 'yyyy/MM/dd', 'dd.MM.yyyy', 'shortDate'];
    $scope.format = $scope.formats[0];
    $scope.altInputFormats = ['M!/d!/yyyy'];
    $scope.popup1 = {
      opened: false
    };
    $scope.popup2 = {
      opened: false
    };
    tomorrow = new Date;
    tomorrow.setDate(tomorrow.getDate() + 1);
    afterTomorrow = new Date;
    afterTomorrow.setDate(tomorrow.getDate() + 1);
    return $scope.events = [
      {
        date: tomorrow,
        status: 'full'
      }, {
        date: afterTomorrow,
        status: 'partially'
      }
    ];
  }
]);

//# sourceMappingURL=../maps/controllers/OrgFinancialsController.js.map
