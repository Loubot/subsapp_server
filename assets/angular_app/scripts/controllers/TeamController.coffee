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
    $scope.training_or_match = 'disabled'
    $scope.location = {}
    $scope.markers = new Array()

    get_team_info = ->
      COMMS.GET(
        "/locations"
      ).then ( ( locations ) -> 
        console.log "Got locations"
        console.log locations
        alertify.success "Got locations"
        $scope.locations = locations.data
      ), ( errResponse ) ->
        console.log "Failed to get locations"
        alertify.error "Failed to get locations"

      fetch_info = ->
        if $rootScope.USER.club_admin
          COMMS.GET(
            "/team/get-team-info/#{ window.localStorage.getItem 'team_id' }"          
          ).then ( (res) ->
            
            console.log "get_team_info response club admin"
            console.log res
            $scope.team = res.data.team
            $scope.org = res.data.org

            $scope.org_members = res.data.org.org_members
            
          ), ( errResponse ) ->

            console.log "get_team_info error"
            console.log errResponse
        else
          console.log 'helllo'
          COMMS.GET(
            "/team/#{ window.localStorage.getItem 'team_id' }"
          ).then ( (res) ->
            
            console.log "Get team info response"
            console.log res.data
            $scope.team = res.data
            $scope.org = res.data.main_org
            alertify.success "Got team info"

             
          ), ( errResponse ) ->

            console.log "Get team info error #{ JSON.stringify errResponse }"
            alertify.error "Failed to get team info"
            $state.go 'login'

      if !( window.localStorage.getItem 'team_id' )?
        console.log "Setting team id"
        if $rootScope.USER.teams[0]?
          window.localStorage.setItem 'team_id', $rootScope.USER.teams[0].id
          fetch_info()
      else
        fetch_info()

    if !($rootScope.USER?)
      user.get_user().then ( (res) ->
        # console.log "User set to #{ JSON.stringify res }"
        # console.log "TeamController teams #{ JSON.stringify window.USER }"
        $scope.user = $rootScope.USER

        $scope.org = $rootScope.USER.org[0]

        $scope.teams = $rootScope.USER.teams
        return_team( $rootScope.USER.teams, $location.search().id )
        $scope.show_upload = $rootScope.USER.club_admin
        get_team_info() 
      ), ( errResponse ) ->
        $rootScope.USER = null
        $state.go 'login'
    else
      console.log "USER already defined"
      $scope.user = $rootScope.USER
      $scope.org = $rootScope.USER.org[0]
      $scope.teams = $rootScope.USER.teams
      $scope.user = $rootScope.USER
      get_team_info() if $rootScope.USER.club_admin
  
      
    $scope.create_event = ->
      console.log $scope.training_or_match
      console.log JSON.stringify $scope.create_event_data
      $scope.create_event_data.team_id = $scope.team.id
      $scope.create_event_data.user_id = $rootScope.USER.id
      $scope.create_event_data.event_team = $scope.team.id
      if $scope.training_or_match == 'false'
        console.log 'yep'
        delete $scope.create_event_data.kick_off_date 
      console.log "delete"
      console.log JSON.stringify $scope.create_event_data
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
        $scope.team = res.data
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
        get_org_and_members()   #update eligible player list. 
      else
        alertify.log("Please set the eligible date of this team. Click to dismiss", "", 0)
        
      
      
      


    get_org_and_members = -> #fetch org info with members. Only members under the teams eligible age. 
      console.log "org id #{ $scope.team.main_org.id }"
      
      if $rootScope.USER.club_admin
        console.log "Fetching org and team members"
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
      else
        COMMS.GET(
          "/team/org-members/#{ $scope.team.id }"
          $scope.team
        ).then ( ( res ) ->
          console.log "Get org members"
          console.log res.data
          $scope.org_members = res.data
          $scope.team_members_array = $scope.team.team_members.map ( member ) ->
            member.id
        ), ( errResponse ) ->
          
          console.log "Get org members error"
          console.log errResponse
          alertify.error "Failed to fetch org members"

    ###########################################
    #               Map stuff                 #
    #                                         #
    ###########################################

    set_map = ( lat, lng, set_markers, zoom ) -> # set map to new center/ possibly with marker
      if !( zoom )?
        zoom = 11

      
      for marker in $scope.markers
        marker.setMap( null )
      $scope.markers = new Array()


      # console.log " zoom #{ zoom }"
      
      $scope.map.setZoom( zoom )
    
      # $scope.map.setCenter
      #   lat: lat
      #   lng: lng


      if set_markers
        marker = new (google.maps.Marker)(
          position: 
            lat: lat
            lng: lng
          title: 'Hello World!')
        $scope.markers.push marker

        marker.setMap $scope.map

        # google.maps.event.trigger($scope.map, 'resize')

          # console.log point
          
      console.log "center #{ JSON.stringify $scope.map.center }"

    $scope.find_address = -> # event triggered after user has stopped typing for a second. Debounce set on html element
      geocoder = new google.maps.Geocoder() # geocode address to lat/lng coordinate
      console.log "Address #{ $scope.map.address }"
      geocoder.geocode( address: $scope.location.address, ( results, status ) ->
        console.log results
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
          lat: 51.8959843
          lng: -8.5330899
        zoom: 8)
      $scope.markers = new Array()

    $( document ).on 'shown.bs.modal', '#add_locations', ->
      # $scope.map.center = 
      #   lat: 51.8959843
      #   lng: -8.5330899
    
      # $scope.location.location_owner = $scope.org.name # set name of location_owner in text field
      google.maps.event.trigger($scope.map, 'resize')

      $scope.map.addListener 'click', ( e ) ->
        $scope.location.lat = e.latLng.lat()
        $scope.location.lng = e.latLng.lng()
        set_map( e.latLng.lat(), e.latLng.lng(), true, $scope.map.zoom )

    $scope.save_address = -> # event triggered when user clicks save address button. 
      console.log "Save address"
      console.log $scope.location
      $scope.location.user_id = $rootScope.USER.id
      $scope.location.org_id = $scope.org.id
      COMMS.POST( 
        '/location', $scope.location 
      ).then ( ( res ) ->
        console.log "Save adddres response"
        alertify.success "Adddres saved"
        console.log res.data
        $scope.locations = res.data.org_locations
        $('#add_locations').modal 'hide'
        # $scope.parsed_data = res
      ), ( errResponse ) ->
        console.log "Save address error"
        # console.log errResponse
        alertify.error errResponse.data

######################## end of map stuff #############################
    $scope.invite_manager_data = {}
    $scope.invite_manager = ->
      console.log $scope.invite_manager_data
      COMMS.POST(
        '/invite-manager'
        { org_id: $scope.org.id

        team_id: $scope.team.id
        club_admin_id: $scope.user.id
        club_admin_email: $scope.user.email
        invited_email: $scope.invite_manager_data.invited_email
        main_org_name: $scope.org.name
        team_name: $scope.team.name }

      ).then ( ( response ) ->
        console.log "Send invite mail"
        console.log response
        alertify.success "Invite sent ok"
        $('#invite_manager').modal 'hide'
      ), ( errResponse ) ->
        console.log "Send invite mail"
        console.log errResponse
        alertify.error errResponse.message 
      
      

    $scope.onTimeSet = ( nd, od ) ->
      $scope.create_event_data.start_date = moment( nd ).format( 'DD-MM-YYYY HH:mm' )
      $scope.create_event_data.kick_off_date = moment( nd ).add( 1, 'hours' ).format( 'DD-MM-YYYY HH:mm' )
      $scope.create_event_data.end_date = moment( nd ).add( 2, 'hours' ).format( 'DD-MM-YYYY HH:mm' )
      
      

])

return_team = ( teams, id ) ->
  team = (team for team in teams when team.id is parseInt( id ))
  console.log "Team #{ JSON.stringify team }"
  return team