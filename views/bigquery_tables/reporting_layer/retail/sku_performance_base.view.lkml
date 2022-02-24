view: sku_performance_base {
  sql_table_name: `flink-data-dev.reporting.sku_performance_base`
    ;;

  dimension: buying_price {
    type: number
    sql: ${TABLE}.buying_price ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: item_revenue_gross_corrected {
    type: number
    sql: ${TABLE}.item_revenue_gross_corrected ;;
  }

  dimension: number_of_connections {
    type: number
    sql: ${TABLE}.number_of_connections ;;
  }

  dimension: order_value_gross_corrected {
    type: number
    sql: ${TABLE}.order_value_gross_corrected ;;
  }

  dimension: quantity_sold_corrected {
    type: number
    sql: ${TABLE}.quantity_sold_corrected ;;
  }

  dimension: share_of_hours_oos {
    type: number
    sql: ${TABLE}.share_of_hours_oos ;;
  }

  dimension: share_of_hours_open {
    type: number
    sql: ${TABLE}.share_of_hours_open ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
    primary_key: yes
  }

  dimension: total_avg_order_value_gross_corrected {
    type: number
    sql: ${TABLE}.total_avg_order_value_gross_corrected ;;
  }

  dimension: total_item_revenue_gross_corrected {
    type: number
    sql: ${TABLE}.total_item_revenue_gross_corrected ;;
  }

  dimension: total_quantity_sold_corrected {
    type: number
    sql: ${TABLE}.total_quantity_sold_corrected ;;
  }

  dimension: unit_price_gross {
    type: number
    sql: ${TABLE}.unit_price_gross ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
