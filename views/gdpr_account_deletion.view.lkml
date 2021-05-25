view: gdpr_account_deletion {
  sql_table_name: `flink-backend.gsheet_gdpr.Account_Deletion`
    ;;

  dimension: customer {
    type: string
    hidden: yes
    sql: ${TABLE}.customer ;;
  }

  dimension: date {
    label: "GDPR Deletion Request Date"
    type: string
    hidden: no
    sql: ${TABLE}.date ;;
  }

  dimension: email {
    type: string
    hidden: yes
    sql: ${TABLE}.email ;;
  }


  measure: count {
    type: count
    hidden: yes
    drill_fields: []
  }
}
