'use strict'

angular.module('subzapp').controller('OrgFinancialsController', [
  '$scope'
  '$rootScope'
  '$state'
  '$http'
  'RESOURCES'
  'alertify'
  'user'
  'COMMS'
  'stripe'
  '$location'
  ( $scope, $rootScope, $state, $http, RESOURCES, alertify, user, COMMS, stripe, $location ) ->
    console.log "OrgFinancialsController"
    $scope.withdrawl = {}
    $scope.display_stripe = true

    $scope.account = {}
    $scope.account.country = "IE"
    $scope.account.currency = "EUR"
    $scope.options = [ "individual", "company" ]
    stripe.setPublishableKey 'pk_test_bedFzS7vnmzthkrQolmUjXNn'


    check_for_stripe_code = ->
      display_stripe = $rootScope.USER.tokens[0].stripe_user_id == null
      if $location.search().code?
        console.log $location.search().code
        COMMS.POST(
          "/payment/#{ $scope.org.id }/authenticate-stripe"
          auth_code: $location.search().code
        ).then ( ( res ) ->
          console.log "Authenticated stripe"
          
          console.log res
          try 
            message = JSON.parse res.data.body
            console.log message.error_description
          catch error
            alert "No good boss"
          if message? and message.error_description?
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
        "/org/#{ $rootScope.USER.org[0].id }"
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

   

    $scope.withdraw_tokens = ->
      console.log $scope.withdrawl.amount


])




 # $scope.add_bank_details = ->

    #   console.log $scope.account
    #   stripe.bankAccount.createToken( $scope.account ).then ( ( stripe_account ) ->
    #     stripe_account.org_id = $scope.org.id
    #     console.log "Stripe response"
    #     console.log stripe_account
    #     stripe_account.account_id = stripe_account.id
    #     delete stripe_account.id
    #     COMMS.POST(
    #       "/org/#{ $scope.org.id }/bank-account"
    #       stripe_account
    #     ).then ( ( account_saved ) ->
    #       console.log "Account saved"
    #       console.log account_saved
    #       alertify.success "Account saved ok"
    #     ), ( account_err ) ->
    #       console.log "Save account err"
    #       console.log account_err
    #       alertify.error "Failed to save account"
    #   ), ( errResponse ) ->
    #     console.log errResponse