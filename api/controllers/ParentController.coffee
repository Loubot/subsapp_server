##
# ParentController
#
# @description :: Server-side logic for managing Parents
# @help        :: See http://sailsjs.org/#!/documentation/concepts/Controllers
##
Promise = require('bluebird')

module.exports = {
  associate_kids: ( req, res ) ->
    sails.log.debug "ParentController/associate_kids"
    sails.log.debug "Params #{ req.param('id') }"
    assocations = Promise.promisifyAll( AssociationService )
    assocations.associate_kidsAsync( req.user ).then( ( parent ) ->
      sails.log.debug "Parent assocaition #{ JSON.stringify parent }"
      res.json parent
    ).catch( ( parent_err ) ->
      sails.log.debug "Parent associate err #{ JSON.stringify parent_err }"
      res.negotiate parent_err
    )

  parents_with_events: ( req, res ) ->
    sails.log.debug "Hit the UserController/parents_with_events"
    User.query("select a.email, a.firstName, a.lastName, a.id as parent_id, a.createdAt, a.updatedAt, b.amount as tokens
      from user a
      left outer join token b on a.id = b.owner
      where a.id=#{ req.param('id') };", ( err, parentData ) ->
        if err?
          sails.log.debug "parents_with_events parentData err #{ err }"
          res.negotiate err
        else
          sails.log.debug "parents_with_events parentData #{ JSON.stringify parentData }"
          User.query("select a.id, a.name, a.details, a.start_date, a.end_date, a.event_parent as parent_id
            from parentevent a
            where a.event_parent=#{ req.param('id') };", ( err, parentEventData ) ->
              if err?
                sails.log.debug "parents_with_events parentEventData err #{ err }"
                res.negotiate err
              else
                sails.log.debug "parents_with_events parentEventData #{ JSON.stringify parentEventData }"
                User.query("select b.id, b.firstName, b.lastName, b.dob, b.parent_email, a.id as parent_id, c.team_team_members as team_id, d.name as team_name, o.org_org_members as club_id, e.name as club_name
                  from user a
                  inner join user b on a.email = b.parent_email
                  left outer join org_org_members__user_user_orgs o on b.id = o.user_user_orgs
                  left outer join team_team_members__user_user_teams c on b.id = c.user_user_teams
                  left outer join team d on c.team_team_members = d.id
                  left outer join org e on o.org_org_members = e.id
                  where a.id=#{ req.param('id') };", ( err, kidsData ) ->
                    if err?
                      sails.log.debug "parents_with_events kidsData err #{ err }"
                      res.negotiate err
                    else
                      sails.log.debug "parents_with_events kidsData #{ JSON.stringify kidsData }"
                      User.query("select b.id, a.id as parent_id, e.event_event_user as event_id, f.name as title, f.details, f.start_date, f.end_date, f.price, g.paid, g.declined, g.createdAt as paid_date
                        from user a 
                        inner join user b on a.email = b.parent_email
                        right join event_event_user__user_user_events e on b.id = e.user_user_events
                        right join event f on e.event_event_user = f.id
                        left outer join tokentransaction g on a.id = g.parent_id and f.id = g.event_id and b.id = g.user_id
                        where a.id=#{ req.param('id') };", ( err, kidsEventsData ) ->
                          if err?
                            sails.log.debug "parents_with_events kidsEventsData err #{ err }"
                            res.negotiate err
                          else
                            sails.log.debug "parents_with_events kidsEventsData #{ JSON.stringify kidsEventsData }"
                            NULL = ''
                            masterJsonData = {}
                            # masterJsonData.kids = kidsData
                            sails.log.debug "masterJsonData kids #{ JSON.stringify masterJsonData }"
                            masterJsonData.kidsWithEvents = []
                            masterJsonData.parent = parentData
                            masterJsonData.parentEvents = parentEventData
                            i = 0
                            while i < kidsData.length
                              kid = kidsData[i]
                              kidID = kid.id
                              temporaryKidEvents = []
                              j = 0
                              while j < kidsEventsData.length
                                kid_event = kidsEventsData[j]
                                kidEventID = kid_event.id
                                if kidID == kidEventID
                                  temporaryKidEvents.push kid_event
                                kid.events = temporaryKidEvents
                                
                                j++
                              masterJsonData.kidsWithEvents.push kid
                              sails.log.debug "Masterjsondata in loop #{ JSON.stringify masterJsonData }"
                              i++
                            sails.log.debug "Masterjsondata #{ JSON.stringify masterJsonData }"
                            res.json masterJsonData
                      )
                )
          )
    )

  #end of parents_with_events

}