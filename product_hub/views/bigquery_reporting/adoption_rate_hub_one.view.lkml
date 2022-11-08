# Owner: Product Analytics, Flavia Alvarez
# Created: 2022-11-08

view: adoption_rate_hub_one {
  sql_table_name: `flink-data-dev.reporting.adoption_rate_hub_one`
    ;;

  dimension: table_uuid {
    primary_key: yes
    hidden: yes
    type: string
    description: "Concatenation of date and hub_code."
    sql: ${TABLE}.table_uuid ;;
  }

  dimension: country_iso {
    type: string
    description: "Country ISO based on 'hub_code'."
    sql: ${TABLE}.country_iso ;;
  }

  dimension_group: event {
    type: time
    timeframes: [
      date,
      week,
      month
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.event_date ;;
  }

  dimension: hub_code {
    type: string
    description: "Code of a hub identical to back-end source tables."
    sql: ${TABLE}.hub_code ;;
  }

  measure: hub_one_orders {
    type: sum
    description: "Count of orders from hub one."
    sql: ${TABLE}.hub_one_orders ;;
  }

  measure: number_of_orders {
    type: sum
    description: "Count of orders from order table."
    sql: ${TABLE}.number_of_orders ;;
  }

  measure: picker_app_orders {
    type: sum
    description: "Count of orders from picker app."
    sql: ${TABLE}.picker_app_orders ;;
  }

  measure: picking_adoption_rate {
    type: number
    value_format: "0.00%"
    description: "Percentage of HubOne Orders over Total Orders."
    sql: ${hub_one_orders}/${number_of_orders} ;;
  }
}
