'use strict'

angular.module('subzapp').controller('TeamController', [
  '$scope'
  '$rootScope'
  '$state'
  'COMMS'
  '$window'
  '$location'
  'user'
  'alertify'
  'RESOURCES'
  '$filter'
  'uiGmapGoogleMapApi'
  ( $scope, $rootScope, $state, COMMS, $window, $location, user, alertify, RESOURCES, $filter, uiGmapGoogleMapApi ) ->    
    console.log 'Team Controller'
    user_token = window.localStorage.getItem 'user_token'
    $scope.location = {}
    $scope.markers = new Array()
    get_team_info = ->

      if $rootScope.USER.club_admin
        COMMS.GET(
          "/team/get-team-info/#{ window.localStorage.getItem 'team_id' }"          
        ).then ( (res) ->
          
          console.log "get_team_info response club admin"
          console.log res
          $scope.team = res.data.team
          $scope.org = res.data.org
          $scope.org_members = res.data.org.org_members
          $scope.locations = res.data.org.org_locations
          
        ), ( errResponse ) ->

          console.log "get_team_info error"
          console.log errResponse
      else
        COMMS.GET(
          "/team/#{ window.localStorage.getItem 'team_id' }"
        ).then ( (res) ->
          
          console.log "Get team info response"
          console.log res.data
          $scope.team = res.data

           
        ), ( errResponse ) ->

          console.log "Get team info error #{ JSON.stringify errResponse }"
          $state.go 'login'

    if !($rootScope.USER?)
      user.get_user().then ( (res) ->
        # console.log "User set to #{ JSON.stringify res }"
        # console.log "TeamController teams #{ JSON.stringify window.USER }"
        $scope.user = $rootScope.USER

        $scope.org = $rootScope.USER.org[0]

        $scope.teams = $rootScope.USER.teams
        return_team( $rootScope.USER.teams, $location.search().id )
        $scope.show_upload = $rootScope.USER.club_admin
        get_team_info() if $rootScope.USER.club_admin
      ), ( errResponse ) ->
        $rootScope.USER = null
        # $state.go 'login'
    else
      console.log "USER already defined"
      $scope.user = $rootScope.USER
      $scope.org = $rootScope.USER.org[0]
      $scope.teams = $rootScope.USER.teams
      $scope.user = $rootScope.USER
      get_team_info() if $rootScope.USER.club_admin
  
      
    $scope.create_event = ->
      $scope.create_event_data.team_id = $scope.team.id
      $scope.create_event_data.user_id = $rootScope.USER.id
      $scope.create_event_data.event_team = $scope.team.id
      if isNaN( $scope.create_event_data.location_id )
        console.log "Not a number"
        alertify.error "You must select a location"
        return false

      console.log $scope.create_event_data
      COMMS.POST(
        "/event"
        $scope.create_event_data
      ).then ( (res) ->
        # console.log "Create event response"
        alertify.success("Event created")
        console.log res.data
        $scope.events = res.data
      ), ( errResponse ) ->
        console.log "Create event error"
        alertify.error "Create event failed"
        console.log errResponse


    $scope.get_players_by_year = ( id ) ->
      console.log "Find by date"
      COMMS.GET(
        "/team/get-players-by-year/#{ $scope.team.id }"
        # params:
        #   team_id: id
      ).then ( (res) ->
         console.log "Playsers by age response"
         console.log res
         
      ), ( errResponse ) ->
        console.log "DOwnload error #{ JSON.stringify errResponse }"

  
    $scope.download = ->
      COMMS.GET(
        "/user/download-file"
      ).then ( (res) ->
         console.log "Download response"
         console.log res
         
      ), ( errResponse ) ->
        console.log "DOwnload error #{ JSON.stringify errResponse }"

    $scope.update_members = ->
      console.log "team id #{ $scope.team.id }"
      console.log "Team members array"
      console.log $scope.team_members_array
      COMMS.POST(
        "/team/update-members/#{ $scope.team.id }"
        team_members: $scope.team_members_array
      ).then ( ( res ) ->
        console.log "Update team members"
        console.log res
        $scope.team_members_array = res.data.team_members.map( ( member ) ->
          member.id
        )
        # $('#select_player_modal').modal('hide')
        alertify.success "Team members updated successfully"
      ), ( errResponse ) ->
        console.log "Update team members error "
        console.log errResponse
        alertify.error "Failed to add team members"

    $scope.update_eligible_date = () ->
      
      console.log $scope.team
      COMMS.POST(
        "/team/update/#{ $scope.team.id }"
        $scope.team
      ).then ( ( res ) ->
        console.log "Update team date"
        console.log res.data
        $scope.team.eligible_date =  moment(res.data[0].eligible_date).format('YYYY-MM-DD')
        $scope.team.eligible_date_end =  moment(res.data[0].eligible_date_end).format('YYYY-MM-DD')
        get_org_and_members()
        alertify.success "Eligible date updated"
      ), ( errResponse ) ->
       
        console.log "Update date error "
        console.log errResponse
        alertify.error "Update failed"

    $('#select_player_modal').on 'shown.bs.modal', (e) -> #get team players when modal is opened
      if $scope.team.eligible_date?
        $scope.team.eligible_date = moment($scope.team.eligible_date).format('YYYY-MM-DD')
        $scope.team.eligible_date_end = moment($scope.team.eligible_date_end).format('YYYY-MM-DD')
        console.log $scope.team.eligible_date
        get_org_and_members() #update eligible player list. 
      else
        alertify.log("Please set the eligible date of this team. Click to dismiss", "", 0)
        
      
      
      


    get_org_and_members = -> #fetch org info with members. Only members under the teams eligible age. 
      console.log "org id #{ $scope.team.main_org.id }"
      
      COMMS.GET(
        "/org/get-org-team-members/#{ $scope.team.main_org.id }"
        $scope.team
      ).then ( ( res ) ->
        console.log "Get org info "
        console.log res.data
        $scope.org_members = res.data.org.org_members
        $scope.team_members_array = res.data.team.team_members.map( ( member ) ->
            member.id ) #create array containing team members user.id
        
        alertify.success "Got players info"
      ), ( errResponse ) ->
        console.log "Get org info error "
        
        console.log errResponse
        alertify.error "Couldn't get players info"

    ###########################################
    #               Map stuff                 #
    #                                         #
    ###########################################

    set_map = ( lat, lng, set_markers, open ) -> # set map to new center/ possibly with marker
      if !( zoom )?
        zoom = 11

      
      for marker in $scope.markers
        marker.setMap( null )
      $scope.markers = new Array()

      if !( zoom )?
        zoom = 11
      
      # console.log " zoom #{ zoom }"
      if open
        $scope.map.setZoom( zoom )
      if move
        $scope.map.setCenter
          lat: lat
          lng: lng


      if set_markers
        marker = new (google.maps.Marker)(
          position: 
            lat: lat
            lng: lng
          title: 'Hello World!')
        $scope.markers.push marker

        marker.setMap $scope.map

          # console.log point
          
      console.log "center #{ JSON.stringify $scope.map.center }"

    $scope.find_address = -> # event triggered after user has stopped typing for a second. Debounce set on html element
      geocoder = new google.maps.Geocoder() # geocode address to lat/lng coordinate
      console.log "Address #{ $scope.map.address }"
      geocoder.geocode( address: $scope.map.address, ( results, status ) ->
        $scope.map.markers = []
        # console.log "results "
        console.log results
        # console.log "Status #{ JSON.stringify status }"

        set_map( results[0].geometry.location.lat(), results[0].geometry.location.lng() , true, 15 )
        
        
          
      )

    $scope.new_location = ->
      if 'new_location' == $scope.create_event_data.location_id
        $('#add_locations').modal 'show'
        return true

    uiGmapGoogleMapApi.then (maps) -> # event fired when maps are loaded
      $scope.map = new (google.maps.Map)(document.getElementById('map-container'),
        center:
          lat: 51.9181688
          lng: -8.5039876
        zoom: 15)
      $scope.markers = new Array()

    $('#add_locations').on 'shown.bs.modal', ->
      google.maps.event.trigger($scope.map, 'resize')
      $scope.show_map = true

      $scope.map.addListener 'click', ( e ) ->
        $scope.location.lat = e.latLng.lat()
        $scope.location.lng = e.latLng.lng()
        # set_map( e.latLng.lat(), e.latLng.lng(), true, $scope.map.zoom, true )

    $scope.save_address = -> # event triggered when user clicks save address button. 
      console.log "Save address"
      console.log $scope.map
      $scope.map.user_id = $rootScope.USER.id
      $scope.map.org_id = $scope.org.id
      COMMS.POST( 
        '/location', $scope.map 
      ).then ( ( res ) ->
        console.log "Save adddres response"
        alertify.success "Adddres saved"
        console.log res.data
        $scope.locations = res.data.org_locations
        # $scope.parsed_data = res
      ), ( errResponse ) ->
        console.log "Save address error"
        console.log errResponse
        alertify.error errResponse.data
      
      

    $scope.onTimeSet = ( nd, od ) ->
      $scope.create_event_data.start_date = moment( nd ).format( 'DD-MM-YYYY HH:mm' )
      $scope.create_event_data.end_date = moment( nd ).add( 2, 'hours' ).format( 'DD-MM-YYYY HH:mm' )
      

])

return_team = ( teams, id ) ->
  team = (team for team in teams when team.id is parseInt( id ))
  console.log "Team #{ JSON.stringify team }"
  return team