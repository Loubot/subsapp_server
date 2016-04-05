'use strict';
var return_org;

angular.module('subzapp').controller('OrgAdminController', [
  '$scope', '$state', '$http', 'user', 'RESOURCES', 'alertify', 'Upload', 'usSpinnerService', 'uiGmapGoogleMapApi', function($scope, $state, $http, user, RESOURCES, alertify, Upload, usSpinnerService, uiGmapGoogleMapApi) {
    var check_club_admin, display_info, drag_display_info, set_map, user_token;
    check_club_admin = function(user) {
      if (!user.club_admin) {
        $state.go('login');
        return alertify.error('You are not a club admin. Contact subzapp admin team for assitance');
      }
    };
    console.log('OrgAdmin Controller');
    user_token = window.localStorage.getItem('user_token');
    user.get_user().then((function(res) {
      check_club_admin(window.USER);
      $scope.org = window.USER.orgs[0];
      console.log("org id " + (JSON.stringify($scope.org)));
      $scope.user = window.USER;
      $scope.orgs = window.USER.orgs;
      $scope.show_team_admin = window.USER.orgs.length === 0;
      $scope.show_map = true;
      if ($scope.org != null) {
        usSpinnerService.spin('spinner-1');
        return $http({
          method: 'GET',
          url: RESOURCES.DOMAIN + "/org/" + $scope.org.id,
          headers: {
            'Authorization': "JWT " + user_token,
            "Content-Type": "application/json"
          },
          params: {
            org_id: $scope.org.id
          }
        }).then((function(org_and_teams) {
          usSpinnerService.stop('spinner-1');
          console.log("Get org and teams");
          console.log(org_and_teams);
          $scope.teams = org_and_teams.data.org.teams;
          return $scope.files = org_and_teams.data.s3_object.Contents;
        }), function(errResponse) {
          usSpinnerService.stop('spinner-1');
          console.log("Get teams failed");
          console.log(errResponse);
          return alertify.error('Failed to fetch teams');
        });
      }
    }));
    $scope.view_team = function(id) {
      window.localStorage.setItem('team_id', id);
      return $state.go('team_manager');
    };
    $scope.org_create = function() {
      console.log(RESOURCES.DOMAIN + "/org/create");
      user_token = window.localStorage.getItem('user_token');
      $scope.business_form_data.user_id = window.localStorage.getItem('user_id');
      console.log("Form data " + (JSON.stringify($scope.business_form_data)));
      return $http({
        method: 'POST',
        url: RESOURCES.DOMAIN + "/org/create",
        headers: {
          'Authorization': "JWT " + user_token,
          "Content-Type": "application/json"
        },
        data: $scope.business_form_data
      }).then((function(response) {
        $scope.orgs = response.data;
        $scope.org = response.data[0];
        console.log("Org set: " + (JSON.stringify($scope.org)));
        alertify.success("Club created successfully");
        $('.business_name').val("");
        return $('.business_address').val("");
      }), function(errResponse) {
        console.log("Business create error response " + (JSON.stringify(errResponse)));
        return $state.go('login');
      });
    };
    $scope.edit_org = function(id) {
      console.log("Org " + (JSON.stringify($scope.org)));
      $scope.show_team_admin = false;
      return $http({
        method: 'GET',
        url: RESOURCES.DOMAIN + "/org-admins",
        headers: {
          'Authorization': "JWT " + user_token,
          "Content-Type": "application/json"
        },
        params: {
          org_id: id
        }
      }).then((function(response) {
        console.log("get org-admins");
        console.log(response);
        $scope.admins = response.data.admins;
        return $scope.teams = response.data.teams;
      }), function(errResponse) {
        console.log("Get org admins error");
        return console.log(errResponse);
      });
    };
    $scope.team_create = function() {
      console.log("Org id " + (JSON.stringify($scope.org)));
      $scope.team_form_data.org_id = $scope.org.id;
      console.log("Form data " + (JSON.stringify($scope.team_form_data)));
      return $http({
        method: 'POST',
        url: RESOURCES.DOMAIN + "/create-team",
        headers: {
          'Authorization': "JWT " + user_token,
          "Content-Type": "application/json"
        },
        data: $scope.team_form_data
      }).then((function(response) {
        console.log("Team create");
        console.log(response);
        alertify.success(response.data.message);
        $scope.teams = response.data.org.teams;
        $scope.team_form.$setPristine();
        return $scope.team_form_data = '';
      }), function(errResponse) {
        console.log("Team create error");
        console.log(errResponse);
        return alertify.error(errResponse);
      });
    };
    $scope.delete_team = function(id) {
      return $http({
        url: RESOURCES.DOMAIN + "/delete-team",
        method: 'DELETE',
        headers: {
          'Authorization': "JWT " + user_token,
          "Content-Type": "application/json"
        },
        data: {
          team_id: id,
          org_id: $scope.org.id
        }
      }).then((function(res) {
        console.log("Team delete");
        console.log(res);
        return $scope.teams = res.data.teams;
      }), function(errResponse) {
        console.log("Team delete error");
        return console.log(errResponse);
      });
    };
    $scope.submit = function() {
      usSpinnerService.spin('spinner-1');
      return $scope.upload($scope.file);
    };
    $scope.upload = function(file) {
      var file_info;
      console.log("Upload");
      if ($scope.file.info != null) {
        file_info = JSON.parse($scope.file.info);
        console.log("Defined " + file_info);
        file_info = {
          org_id: $scope.org.id,
          team_id: file_info[0],
          team_name: file_info[1]
        };
        console.log("file_info " + (JSON.stringify(file_info)));
      } else {
        console.log("Not defined ");
        file_info = {
          org_id: $scope.org.id
        };
      }
      return Upload.upload({
        method: 'post',
        url: '/file/upload',
        data: file_info,
        file: file
      }).then((function(resp) {
        usSpinnerService.stop('spinner-1');
        console.log('Success ' + JSON.stringify(resp + 'uploaded. Response: ' + JSON.stringify(resp.data)));
        console.log(resp);
        $scope.files = resp.data.bucket_info.Contents;
        alertify.success("File uploaded ok");
      }), (function(resp) {
        usSpinnerService.stop('spinner-1');
        console.log('Error status: ' + resp.status);
        alertify.error("File failed to upload");
        console.log(resp);
        alertify.error("File upload failed. Status: " + resp.status);
      }), function(evt) {
        var progressPercentage;
        progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
        return console.log('progress: ' + progressPercentage + '% ' + evt.config.data);
      });
    };
    $scope.convert_date = function(date) {
      console.log("date " + date);
      console.log("New date " + (moment(date).format("DD-MM-YYYY")));
      return moment(date).format("DD-MM-YYYY");
    };
    display_info = function() {
      alertify.log("Enter your clubs address");
      setTimeout((function() {
        return alertify.log("You can drag the map to fine tune your clubs position");
      }), 3000);
      return setTimeout((function() {
        return alertify.log("Click save to upate the location");
      }), 6000);
    };
    drag_display_info = function() {
      alertify.log("You can save this new location");
      return setTimeout((function() {
        return alertify.log("Just click the Save Address button");
      }), 2000);
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
    uiGmapGoogleMapApi.then(function(maps) {
      if (($scope.org != null) && ($scope.org.lat != null)) {
        return set_map($scope.org.lat, $scope.org.lng, true);
      } else {
        set_map(51.9181688, -8.5039876, false);
        return display_info();
      }
    });
    $scope.find_address = function() {
      var geocoder;
      geocoder = new google.maps.Geocoder();
      return geocoder.geocode({
        address: $scope.address
      }, function(results, status) {
        $scope.map.markers = [];
        console.log("results " + (JSON.stringify(results[0].geometry.location)));
        console.log("Status " + (JSON.stringify(status)));
        set_map(results[0].geometry.location.lat(), results[0].geometry.location.lng(), true, 15);
        return $scope.$apply();
      });
    };
    return $scope.save_address = function() {
      console.log($scope.map.center);
      $scope.map.user_id = $scope.user.id;
      return $http({
        method: 'PUT',
        url: RESOURCES.DOMAIN + "/org/" + $scope.org.id,
        headers: {
          'Authorization': "JWT " + user_token,
          "Content-Type": "application/json"
        },
        data: $scope.map.center
      }).then((function(res) {
        console.log("Save adddres response");
        alertify.success("Adddres saved");
        return console.log(res);
      }), function(errResponse) {
        console.log("Save address error");
        console.log(errResponse);
        return alertify.error(errResponse.data);
      });
    };
  }
]);

return_org = function(orgs, search) {
  var i, len, org;
  for (i = 0, len = orgs.length; i < len; i++) {
    org = orgs[i];
    if (parseInt(org.id) === parseInt(search.id)) {
      return org;
    }
  }
};

//# sourceMappingURL=../maps/controllers/OrgAdminController.js.map
