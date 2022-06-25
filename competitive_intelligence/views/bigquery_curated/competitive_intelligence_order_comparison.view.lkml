view: competitive_intelligence_order_comparison {
  sql_table_name: `flink-data-prod.reporting.competitive_intelligence_order_comparison`
    ;;

  dimension: active_hubs_uuid {
    type: string
    sql: ${TABLE}.active_hubs_uuid ;;
  }

  dimension: city_name {
    type: string
    sql: ${TABLE}.city_name ;;
  }

  dimension: competitive_intelligence_order_comparison_uuid {
    primary_key: yes
    type: string
    sql: ${TABLE}.competitive_intelligence_order_comparison_uuid ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension_group: first_seen {
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
    sql: ${TABLE}.first_seen ;;
  }

  dimension: h3_index {
    type: string
    sql: ${TABLE}.h3_index ;;
  }

  dimension: hub_id {
    type: string
    sql: ${TABLE}.hub_id ;;
  }

  dimension: hub_name {
    type: string
    sql: ${TABLE}.hub_name ;;
  }

  dimension_group: last_seen {
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
    sql: ${TABLE}.last_seen ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: number_of_orders {
    type: number
    sql: ${TABLE}.number_of_orders ;;
  }

  dimension: number_of_orders_internal {
    type: number
    sql: ${TABLE}.number_of_orders_internal ;;
  }

  dimension_group: order {
    type: time
    timeframes: [
      raw,
      date,
      week,
      week_of_year,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.order_date ;;
  }

  dimension: provider {
    type: string
    sql: ${TABLE}.provider ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}.region ;;
  }

  dimension: region_iso {
    type: string
    sql: ${TABLE}.region_iso ;;
  }

  measure: sum_number_of_orders{
    type: sum
    sql: ${number_of_orders} ;;
  }

  measure: sum_number_of_orders_internal{
    type: sum
    sql: ${number_of_orders_internal} ;;
  }

  measure: sum_orders {
    type: sum
    sql:  {% if order_type._parameter_value == 'sum_number_of_orders' %}
        ${number_of_orders}
        {% elsif order_type._parameter_value == 'sum_number_of_orders_internal' %}
        ${number_of_orders_internal}
        {% endif %} ;;
  }

  parameter: order_type {
    label: "Order Type"
    type: unquoted
    allowed_value: {value:"sum_number_of_orders" label:"# orders"}
    allowed_value: {value:"sum_number_of_orders_internal" label:"# internal orders"}
  }
}
