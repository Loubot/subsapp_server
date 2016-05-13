'use strict';
angular.module('subzapp').controller('TeamEventsController', [
  '$scope', '$rootScope', '$state', 'COMMS', 'user', 'alertify', 'RESOURCES', function($scope, $rootScope, $state, COMMS, user, alertify, RESOURCES) {
    console.log('Team Events Controller');
    if ((window.localStorage.getItem('team_id')) == null) {
      $state.go('team_manager');
    }
    user.get_user().then((function(res) {
      $scope.user = $rootScope.USER;
      COMMS.GET("/team/" + (window.localStorage.getItem('team_id'))).then((function(team) {
        console.log("Got team info");
        console.log(team);
        $scope.team = team.data;
        return alertify.success("Got team info");
      }), function(team_err) {
        console.log("Team error");
        console.log(team_err);
        return alertify.error("Failed to get team");
      });
      return COMMS.GET("/team/" + (window.localStorage.getItem('team_id')) + "/teams-events").then((function(team) {
        console.log("Got events info");
        console.log(team);
        $scope.events = team.data;
        return alertify.success("Got team info");
      }), function(team_err) {
        console.log("Team error");
        console.log(team_err);
        return alertify.error("Failed to get team");
      });
    }), function(errResponse) {
      $rootScope.USER = null;
      return $state.go('login');
    });
    $scope.format_date = function(date) {
      console.log(date);
      return moment(date).format('YYYY-MM-DD HH:mm');
    };
    $scope.onTimeSet = function(nd, od) {
      console.log(nd);
      console.log(od);
      console.log(moment.duration(moment(od).diff(moment(nd))));
      $scope.date.from = moment(nd).format('DD-MM-YYYY HH:mm');
      return $scope.date.to = moment(od).format('DD-MM-YYYY HH:mm');
    };
    $scope.dt = {};
    $scope.today = function() {
      var date;
      $scope.dt.start_date = new Date();
      date = new Date();
      $scope.dt.end_date = date.setDate(date.getDate() + 1);
      console.log("Date " + $scope.dt.end_date);
    };
    $scope.today();
    $scope.clear = function() {
      $scope.dt = null;
    };
    $scope.open1 = function() {
      $scope.popup1.opened = true;
    };
    $scope.open2 = function() {
      $scope.popup2.opened = true;
    };
    $scope.setDate = function(year, month, day) {
      $scope.dt = new Date(year, month, day);
    };
    $scope.format = "dd-MMMM-yyyy";
    $scope.popup1 = {
      opened: false
    };
    $scope.popup2 = {
      opened: false
    };
    return $scope.get_events = function() {
      console.log("team " + (window.localStorage.getItem('team_id')));
      return COMMS.GET("/team/" + (window.localStorage.getItem('team_id')) + "/teams-events", $scope.dt).then((function(resp) {
        return console.log(resp);
      }), function(errResponse) {
        return console.log(errResponse);
      });
    };
  }
]);

//# sourceMappingURL=../maps/controllers/TeamEventsController.js.map
