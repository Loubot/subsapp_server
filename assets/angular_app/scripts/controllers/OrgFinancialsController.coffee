'use strict'

angular.module('subzapp').controller('OrgFinancialsController', [
  '$scope'
  '$rootScope'
  '$state'
  '$http'
  'RESOURCES'
  '$location'
  'alertify'
  'user'
  'COMMS'
  ( $scope, $rootScope, $state, $http, RESOURCES, $location, alertify, user, COMMS ) ->
    console.log "OrgFinancialsController"

    check_for_stripe_code = ->
      if $location.search().code?
        console.log $location.search().code
        COMMS.POST(
          "/payment/#{ $scope.org.id }/authenticate-stripe"
          auth_code: $location.search().code
        ).then ( ( res ) ->
          console.log "Authenticated stripe"
          
          
          message = JSON.parse res.data.body
          console.log message.error_description
          if message.error_description?
            alertify.error message.error_description
          else
            alertify.success "Authenticated stripe"

        ), ( errResponse ) ->

          console.log "Failed to authenticate stripe"
          alertify.error "Failed to authenticate stripe"
          console.log errResponse


    user.get_user().then( ( res ) ->
      $scope.user = $rootScope.USER

      COMMS.GET(
        "/org/#{ $scope.user.org[0].id }"
      ).then ( ( res ) ->
        console.log "Got org info"
        console.log res.data.org
        $scope.org = res.data.org
        alertify.success "Got org info"
        check_for_stripe_code()
      ), ( errResponse ) ->
        console.log "Get org error"
        console.log. errResponse
        alertify.error "Failed to get org info"
    ) # end of get_user

    disabled = (data) ->
      date = data.date
      mode = data.mode
      mode == 'day' and (date.getDay() == 0 or date.getDay() == 6)

    getDayClass = (data) ->
      date = data.date
      mode = data.mode
      if mode == 'day'
        dayToCheck = new Date(date).setHours(0, 0, 0, 0)
        i = 0
        while i < $scope.events.length
          currentDay = new Date($scope.events[i].date).setHours(0, 0, 0, 0)
          if dayToCheck == currentDay
            return $scope.events[i].status
          i++
      ''

    $scope.today = ->
      $scope.dt = new Date
      return

    $scope.today()

    $scope.clear = ->
      $scope.dt = null
      return

    $scope.inlineOptions =
      customClass: getDayClass
      minDate: new Date
      showWeeks: true
    $scope.dateOptions =
      dateDisabled: disabled
      formatYear: 'yy'
      maxDate: new Date(2020, 5, 22)
      minDate: new Date
      startingDay: 1

    $scope.toggleMin = ->
      $scope.inlineOptions.minDate = if $scope.inlineOptions.minDate then null else new Date
      $scope.dateOptions.minDate = $scope.inlineOptions.minDate
      return

    $scope.toggleMin()

    $scope.open1 = ->
      $scope.popup1.opened = true
      return

    $scope.open2 = ->
      $scope.popup2.opened = true
      return

    $scope.setDate = (year, month, day) ->
      $scope.dt = new Date(year, month, day)
      return

    $scope.formats = [
      'dd-MMMM-yyyy'
      'yyyy/MM/dd'
      'dd.MM.yyyy'
      'shortDate'
    ]
    $scope.format = $scope.formats[0]
    $scope.altInputFormats = [ 'M!/d!/yyyy' ]
    $scope.popup1 = opened: false
    $scope.popup2 = opened: false
    tomorrow = new Date
    tomorrow.setDate tomorrow.getDate() + 1
    afterTomorrow = new Date
    afterTomorrow.setDate tomorrow.getDate() + 1
    $scope.events = [
      {
        date: tomorrow
        status: 'full'
      }
      {
        date: afterTomorrow
        status: 'partially'
      }
    ]


])