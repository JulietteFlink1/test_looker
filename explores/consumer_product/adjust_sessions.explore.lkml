include: "/views/sql_derived_tables/adjust_sessions.view.lkml"
include: "/views/sql_derived_tables/adjust_events.view.lkml"


explore: adjust_sessions {
  hidden: yes
  label: "Adjust app data"
  view_label: "Adjust sessions"
  group_label: "06) Adjust app data"
  description: "Adjust events by session from mobile apps data"
  #always_filter: {
  #  filters:
  #  [
  #    adjust_sessions._partitiondate: "7 days"
  #  ]
  #}

  access_filter: {
    field: adjust_sessions.country
    user_attribute: country_iso
  }

  access_filter: {
    field: adjust_sessions.city
    user_attribute: city
  }


  join: adjust_events {
    sql_on: ${adjust_sessions._adid_} = ${adjust_events._adid_}
          AND datetime(${adjust_events.event_time_raw}, 'Europe/Berlin') >= ${adjust_sessions.session_start_at_raw}
          AND
            (
              datetime(${adjust_events.event_time_raw}, 'Europe/Berlin') < ${adjust_sessions.next_session_start_at_raw}
              OR ${adjust_sessions.next_session_start_at_raw} is NULL
            )
              ;;
    relationship: one_to_many
    type: left_outer
  }

}
