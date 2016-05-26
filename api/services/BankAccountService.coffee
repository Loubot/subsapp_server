
module.exports = {

  add_tokens: ( amount, id ) ->

    sails.log.debug "Hit the BankAccountService/add_tokens"

    sails.log.debug "Amount #{ amount }"
    Team.findOne( id ).then( ( team ) ->
      sails.log.debug "Team found #{ JSON.stringify team }"
      
      BankAccount.updateOrCreate(
        { org_id: team.main_org } 
        org_id: team.main_org
        tokens: amount
        ( err, bank_account ) ->
          if err?
            sails.log.debug "BankAccount create err #{ JSON.stringify err }"
          else
            sails.log.debug "BankAccount created #{ JSON.stringify bank_account[0] }"
            # bank_account[0].org_id.add( team.main_org )


      )

     
      
    ).catch( ( team_err ) ->
      sails.log.debug "Team find err #{ JSON.stringify team_err }"
    )

}