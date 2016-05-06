# describe "OrgTokenBalance model", ->
#   describe "updateOrCreate", ->

#     it "should create a model", ( done ) ->

#       OrgTokenBalance.updateOrCreate(
#         { org_id: 1 }
#         tokens: 2
#         org_id: 1
#         ( err, org_token_balance ) ->
#           if err? 
#             sails.log.debug "Big boo boo"
#             done( err )
#           else
#             sails.log.debug "Sucess #{ JSON.stringify org_token_balance }"
#             org_token_balance.org_id.should.equal( 1 )
#             org_token_balance.tokens.should.equal( 2 )
#             done()
#       )

#     it "should update a model", ( done ) ->

#       OrgTokenBalance.updateOrCreate(
#         { org_id: 1 }
#         tokens: 2
#         org_id: 1
#         ( err, org_token_balance ) ->
#           if err? 
#             sails.log.debug "Couldn't update"
#             done( err )
#           else
#             sails.log.debug "OrgTokenBalance updated #{ JSON.stringify org_token_balance }"
#             org_token_balance[0].org_id.should.equal( 1 )
#             org_token_balance[0].tokens.should.equal( 4 )
#             done()
#       )

#     it "should reduce tokens", ( done ) ->

#       OrgTokenBalance.updateOrCreate(
#         { org_id: 1 }
#         tokens: -2
#         org_id: 1
#         ( err, org_token_balance ) ->
#           if err? 
#             sails.log.debug "Couldn't update"
#             done( err )
#           else
#             sails.log.debug "OrgTokenBalance updated #{ JSON.stringify org_token_balance }"
#             org_token_balance[0].org_id.should.equal( 1 )
#             org_token_balance[0].tokens.should.equal( 2 )
#             done()
#       )

