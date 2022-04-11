view: cc_contact_agents {
  sql_table_name: `flink-data-prod.curated.cc_contact_agents`
    ;;

  dimension: agent_email {
    type: string
    sql: ${TABLE}.agent_email ;;
  }

  dimension: agent_id {
    type: number
    sql: ${TABLE}.agent_id ;;
  }

  dimension: agent_name {
    type: string
    sql: ${TABLE}.agent_name ;;
  }

  dimension: contact_admin_uuid {
    type: string
    primary_key: yes
    sql: ${TABLE}.contact_admin_uuid ;;
  }

  dimension_group: contact_created {
    hidden: yes
    type: time
    timeframes: [
      date,
      week,
      month,
      year
    ]
    sql: ${TABLE}.contact_created_timestamp ;;
  }

  dimension: contact_id {
    hidden: yes
    type: number
    sql: ${TABLE}.contact_id ;;
  }

  dimension: country_iso {
    hidden: yes
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: is_last_agent_assignee_id {
    type: yesno
    sql: ${TABLE}.is_last_agent_assignee_id ;;
  }

  dimension: team_id {
    type: number
    sql: ${TABLE}.team_id ;;
  }

  dimension: team_name {
    type: string
    sql: ${TABLE}.team_name ;;
  }

  dimension: timezone {
    type: string
    hidden:yes
    sql: ${TABLE}.timezone ;;
  }

  measure: count {
    type: count
    drill_fields: [agent_name, team_name]
  }
}
