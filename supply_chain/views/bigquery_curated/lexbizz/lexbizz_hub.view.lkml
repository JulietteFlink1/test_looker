view: lexbizz_hub {
  sql_table_name: `flink-data-prod.curated.lexbizz_hub`
    ;;

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: company_id {
    type: string
    sql: ${TABLE}.company_id ;;
  }

  dimension: country_hub {
    type: string
    sql: ${TABLE}.country_hub ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: gln {
    type: string
    sql: ${TABLE}.gln ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: hub_id {
    type: string
    sql: ${TABLE}.hub_id ;;
  }

  dimension: hub_name {
    type: string
    sql: ${TABLE}.hub_name ;;
  }

  dimension_group: ingestion {
    type: time
    timeframes: [
      date
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.ingestion_date ;;
  }

  dimension: is_hub_active {
    type: yesno
    sql: ${TABLE}.is_hub_active ;;
  }

  dimension: postal_code {
    type: string
    sql: ${TABLE}.postal_code ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: street {
    type: string
    sql: ${TABLE}.street ;;
  }

  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
    primary_key: yes
  }

  measure: count {
    type: count
    drill_fields: [hub_name]
  }
}
