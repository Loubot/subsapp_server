'use strict';
var return_team;

angular.module('subzapp').controller('TeamController', [
  '$scope', '$rootScope', '$state', 'COMMS', '$window', '$location', 'user', 'alertify', 'RESOURCES', '$filter', 'uiGmapGoogleMapApi', function($scope, $rootScope, $state, COMMS, $window, $location, user, alertify, RESOURCES, $filter, uiGmapGoogleMapApi) {
    var get_org_and_members, get_team_info, set_map, user_token;
    console.log('Team Controller');
    user_token = window.localStorage.getItem('user_token');
    $scope.location = null;
    get_team_info = function() {
      if ($rootScope.USER.club_admin) {
        return COMMS.GET("/team/get-team-info/" + (window.localStorage.getItem('team_id'))).then((function(res) {
          console.log("get_team_info response club admin");
          console.log(res);
          $scope.team = res.data.team;
          $scope.org = res.data.org;
          $scope.org_members = res.data.org.org_members;
          return $scope.locations = res.data.org.org_locations;
        }), function(errResponse) {
          console.log("get_team_info error");
          return console.log(errResponse);
        });
      } else {
        return COMMS.GET("/team/" + (window.localStorage.getItem('team_id'))).then((function(res) {
          console.log("Get team info response");
          console.log(res.data);
          return $scope.team = res.data;
        }), function(errResponse) {
          console.log("Get team info error " + (JSON.stringify(errResponse)));
          return $state.go('login');
        });
      }
    };
    if (!($rootScope.USER != null)) {
      user.get_user().then((function(res) {
        $scope.user = $rootScope.USER;
        $scope.teams = $rootScope.USER.teams;
        return_team($rootScope.USER.teams, $location.search().id);
        $scope.show_upload = $rootScope.USER.club_admin;
        if ($rootScope.USER.club_admin) {
          return get_team_info();
        }
      }), function(errResponse) {
        return $rootScope.USER = null;
      });
    } else {
      console.log("USER already defined");
      $scope.user = $rootScope.USER;
      $scope.org = $rootScope.USER.orgs[0];
      $scope.teams = $rootScope.USER.teams;
      $scope.user = $rootScope.USER;
      if ($rootScope.USER.club_admin) {
        get_team_info();
      }
    }
    $scope.create_event = function() {
      $scope.create_event_data.team_id = $scope.team.id;
      $scope.create_event_data.user_id = $rootScope.USER.id;
      $scope.create_event_data.event_team = $scope.team.id;
      if (isNaN($scope.create_event_data.location_id)) {
        console.log("Not a number");
        alertify.error("You must select a location");
        return false;
      }
      console.log($scope.create_event_data);
      return COMMS.POST("/event", $scope.create_event_data).then((function(res) {
        alertify.success("Event created");
        console.log(res.data);
        return $scope.events = res.data;
      }), function(errResponse) {
        console.log("Create event error");
        alertify.error("Create event failed");
        return console.log(errResponse);
      });
    };
    $scope.get_players_by_year = function(id) {
      console.log("Find by date");
      return COMMS.GET("/team/get-players-by-year/" + $scope.team.id).then((function(res) {
        console.log("Playsers by age response");
        return console.log(res);
      }), function(errResponse) {
        return console.log("DOwnload error " + (JSON.stringify(errResponse)));
      });
    };
    $scope.download = function() {
      return COMMS.GET("/user/download-file").then((function(res) {
        console.log("Download response");
        return console.log(res);
      }), function(errResponse) {
        return console.log("DOwnload error " + (JSON.stringify(errResponse)));
      });
    };
    $scope.update_members = function() {
      console.log("team id " + $scope.team.id);
      console.log("Team members array");
      console.log($scope.team_members_array);
      return COMMS.POST("/team/update-members/" + $scope.team.id, {
        team_members: $scope.team_members_array
      }).then((function(res) {
        console.log("Update team members");
        console.log(res);
        $scope.team_members_array = res.data.team_members.map(function(member) {
          return member.id;
        });
        return alertify.success("Team members updated successfully");
      }), function(errResponse) {
        console.log("Update team members error ");
        console.log(errResponse);
        return alertify.error("Failed to add team members");
      });
    };
    $scope.update_eligible_date = function() {
      console.log($scope.team);
      return COMMS.POST("/team/update/" + $scope.team.id, $scope.team).then((function(res) {
        console.log("Update team date");
        console.log(res.data);
        $scope.team.eligible_date = moment(res.data[0].eligible_date).format('YYYY-MM-DD');
        $scope.team.eligible_date_end = moment(res.data[0].eligible_date_end).format('YYYY-MM-DD');
        get_org_and_members();
        return alertify.success("Eligible date updated");
      }), function(errResponse) {
        console.log("Update date error ");
        console.log(errResponse);
        return alertify.error("Update failed");
      });
    };
    $('#select_player_modal').on('shown.bs.modal', function(e) {
      if ($scope.team.eligible_date != null) {
        $scope.team.eligible_date = moment($scope.team.eligible_date).format('YYYY-MM-DD');
        $scope.team.eligible_date_end = moment($scope.team.eligible_date_end).format('YYYY-MM-DD');
        console.log($scope.team.eligible_date);
        return get_org_and_members();
      } else {
        return alertify.log("Please set the eligible date of this team. Click to dismiss", "", 0);
      }
    });
    get_org_and_members = function() {
      console.log("org id " + $scope.team.main_org.id);
      return COMMS.GET("/org/get-org-team-members/" + $scope.team.main_org.id, $scope.team).then((function(res) {
        console.log("Get org info ");
        console.log(res.data);
        $scope.org_members = res.data.org.org_members;
        $scope.team_members_array = res.data.team.team_members.map(function(member) {
          return member.id;
        });
        return alertify.success("Got players info");
      }), function(errResponse) {
        console.log("Get org info error ");
        console.log(errResponse);
        return alertify.error("Couldn't get players info");
      });
    };
    set_map = function(lat, lng, set_markers, zoom) {
      var marker;
      if (zoom == null) {
        zoom = 11;
      }
      $scope.map = {
        center: {
          latitude: lat,
          longitude: lng
        },
        zoom: zoom,
        markers: []
      };
      console.log($scope.map);
      if (set_markers) {
        console.log("setting markers");
        marker = {
          idKey: Date.now(),
          coords: {
            latitude: lat,
            longitude: lng
          }
        };
        $scope.map.markers.push(marker);
      }
      $scope.map.events = {
        dragend: function(point) {
          console.log('yep');
          $scope.map.center = {
            latitude: point.center.lat(),
            longitude: point.center.lng()
          };
          set_map(point.center.lat(), point.center.lng(), true, zoom);
          console.log($scope.map.center);
          return drag_display_info();
        }
      };
      return console.log("center " + (JSON.stringify($scope.map.center)));
    };
    $scope.find_address = function(address) {
      var geocoder;
      geocoder = new google.maps.Geocoder();
      console.log("Address " + address);
      return geocoder.geocode({
        address: address
      }, function(results, status) {
        $scope.map.markers = [];
        console.log("results ");
        console.log(results);
        console.log("Status " + (JSON.stringify(status)));
        set_map(results[0].geometry.location.lat(), results[0].geometry.location.lng(), true, 15);
        return $scope.$apply();
      });
    };
    $scope.new_location = function() {
      if ('new_location' === $scope.create_event_data.location_id) {
        $('#add_locations').modal('show');
        return true;
      }
    };
    $('#add_locations').on('shown.bs.modal', function() {
      $scope.show_map = true;
      set_map(51.9181688, -8.5039876, false);
      return $scope.$apply();
    });
    $scope.save_address = function() {
      console.log($scope.map.center);
      $scope.map.user_id = $rootScope.USER.id;
      $scope.map.org_id = $scope.org.id;
      return COMMS.POST('/location', $scope.map).then((function(res) {
        console.log("Save adddres response");
        alertify.success("Adddres saved");
        console.log(res);
        return $scope.locations = res.data.org.org_locations;
      }), function(errResponse) {
        console.log("Save address error");
        console.log(errResponse);
        return alertify.error(errResponse.data);
      });
    };
    return $scope.onTimeSet = function(nd, od) {
      $scope.create_event_data.start_date = moment(nd).format('DD-MM-YYYY HH:mm');
      return $scope.create_event_data.end_date = moment(nd).add(2, 'hours').format('DD-MM-YYYY HH:mm');
    };
  }
]);

return_team = function(teams, id) {
  var team;
  team = (function() {
    var i, len, results1;
    results1 = [];
    for (i = 0, len = teams.length; i < len; i++) {
      team = teams[i];
      if (team.id === parseInt(id)) {
        results1.push(team);
      }
    }
    return results1;
  })();
  console.log("Team " + (JSON.stringify(team)));
  return team;
};

//# sourceMappingURL=../maps/controllers/TeamController.js.map
