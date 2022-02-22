view: cc_conversation_agents {
  sql_table_name: `flink-data-prod.curated.cc_conversation_agents`
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

  dimension: conversation_admin_uuid {
    type: string
    primary_key: yes
    sql: ${TABLE}.conversation_admin_uuid ;;
  }

  dimension_group: conversation_created_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.conversation_created_timestamp ;;
  }

  dimension: conversation_id {
    type: number
    sql: ${TABLE}.conversation_id ;;
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
    sql: ${TABLE}.timezone ;;
  }

  measure: count {
    type: count
    drill_fields: [agent_name, team_name]
  }
}
