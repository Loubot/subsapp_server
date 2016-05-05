
module.exports = {

  add_tokens: ( amount, id ) ->

    sails.log.debug "Hit the OrgTokenService/add_tokens"

    sails.log.debug "Amount #{ amount }"
    Team.findOne( id ).then( ( team ) ->
      sails.log.debug "Team found #{ JSON.stringify team }"
      
      OrgTokenBalance.updateOrCreate(
        { id: team.main_org } 
        org_id: team.main_org
        tokens: amount
      )

     
      
    ).catch( ( team_err ) ->
      sails.log.debug "Team find err #{ JSON.stringify team_err }"
      cb( team_err )
    )

}