view: sku_performance_base {
  sql_table_name: `flink-data-dev.reporting.sku_performance_base`
    ;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~       Sets.         ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }



  # =========  hidden   =========


  # =========  IDs   =========
  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
    primary_key: yes
  }


  measure: unique_skus {

    label:       "# Unique SKUs"
    description: "The number of unique SKUs"

    type: count_distinct
    sql: ${sku} ;;

    value_format_name: decimal_0
  }

  measure: count {
    type: count
    drill_fields: []
  }



























  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Hidden Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  dimension: pop_unit_price_gross {
    type: number
    sql: ${TABLE}.pop_unit_price_gross ;;
    hidden: yes
  }

  dimension: buying_price {
    required_access_grants: [can_view_buying_information]
    type: number
    sql: ${TABLE}.buying_price ;;
    hidden: yes
  }

  dimension: unit_price_gross {
    type: number
    sql: ${TABLE}.unit_price_gross ;;
    hidden: yes
  }


  dimension: total_assortment_size {
    type: number
    sql: ${TABLE}.total_assortment_size ;;
    hidden: yes
  }

  dimension: pop_total_assortment_size {
    type: number
    sql: ${TABLE}.total_assortment_size ;;
    hidden: yes
  }



  dimension: item_revenue_gross_corrected {
    type: number
    sql: ${TABLE}.item_revenue_gross_corrected ;;
    hidden: yes
  }

  dimension: number_of_connections {
    type: number
    sql: ${TABLE}.number_of_connections ;;
    hidden: yes
  }

  dimension: number_of_orders_corrected {
    type: number
    sql: ${TABLE}.number_of_orders_corrected ;;
    hidden: yes
  }


  dimension: order_value_gross_corrected {
    type: number
    sql: ${TABLE}.order_value_gross_corrected ;;
    hidden: yes
  }

  dimension: pop_item_revenue_gross_corrected {
    type: number
    sql: ${TABLE}.pop_item_revenue_gross_corrected ;;
    hidden: yes
  }

  dimension: pop_number_of_orders_corrected {
    type: number
    sql: ${TABLE}.pop_number_of_orders_corrected ;;
    hidden: yes
  }

  dimension: pop_order_value_gross_corrected {
    type: number
    sql: ${TABLE}.pop_order_value_gross_corrected ;;
    hidden: yes
  }

  dimension: pop_quantity_sold_corrected {
    type: number
    sql: ${TABLE}.pop_quantity_sold_corrected ;;
    hidden: yes
  }

  dimension: pop_share_of_hours_oos {
    type: number
    sql: ${TABLE}.pop_share_of_hours_oos ;;
    hidden: yes
  }

  dimension: pop_share_of_hours_open {
    type: number
    sql: ${TABLE}.pop_share_of_hours_open ;;
    hidden: yes
  }

  dimension: pop_total_avg_order_value_gross_corrected {
    type: number
    sql: ${TABLE}.pop_total_avg_order_value_gross_corrected ;;
    hidden: yes
  }

  dimension: pop_total_item_revenue_gross_corrected {
    type: number
    sql: ${TABLE}.pop_total_item_revenue_gross_corrected ;;
    hidden: yes
  }

  dimension: pop_total_number_of_orders_corrected {
    type: number
    sql: ${TABLE}.pop_total_number_of_orders_corrected ;;
    hidden: yes
  }

  dimension: pop_total_quantity_sold_corrected {
    type: number
    sql: ${TABLE}.pop_total_quantity_sold_corrected ;;
    hidden: yes
  }

  dimension: pop_total_waste_damaged {
    type: number
    sql: ${TABLE}.pop_total_waste_damaged ;;
    hidden: yes
  }

  dimension: pop_total_waste_expired {
    type: number
    sql: ${TABLE}.pop_total_waste_expired ;;
    hidden: yes
  }

  dimension: pop_waste_damaged {
    type: number
    sql: ${TABLE}.pop_waste_damaged ;;
    hidden: yes
  }

  dimension: pop_waste_expired {
    type: number
    sql: ${TABLE}.pop_waste_expired ;;
    hidden: yes
  }

  dimension: quantity_sold_corrected {
    type: number
    sql: ${TABLE}.quantity_sold_corrected ;;
    hidden: yes
  }

  dimension: share_of_hours_oos {
    type: number
    sql: ${TABLE}.share_of_hours_oos ;;
    hidden: yes
  }

  dimension: share_of_hours_open {
    type: number
    sql: ${TABLE}.share_of_hours_open ;;
    hidden: yes
  }

  dimension: total_avg_order_value_gross_corrected {
    type: number
    sql: ${TABLE}.total_avg_order_value_gross_corrected ;;
    hidden: yes
  }

  dimension: total_item_revenue_gross_corrected {
    type: number
    sql: ${TABLE}.total_item_revenue_gross_corrected ;;
    hidden: yes
  }

  dimension: total_number_of_orders_corrected {
    type: number
    sql: ${TABLE}.total_number_of_orders_corrected ;;
    hidden: yes
  }

  dimension: total_quantity_sold_corrected {
    type: number
    sql: ${TABLE}.total_quantity_sold_corrected ;;
    hidden: yes
  }

  dimension: total_waste_damaged {
    type: number
    sql: ${TABLE}.total_waste_damaged ;;
    hidden: yes
  }

  dimension: total_waste_expired {
    type: number
    sql: ${TABLE}.total_waste_expired ;;
    hidden: yes
  }

  dimension: waste_damaged {
    type: number
    sql: ${TABLE}.waste_damaged ;;
    hidden: yes
  }

  dimension: waste_expired {
    type: number
    sql: ${TABLE}.waste_expired ;;
    hidden: yes
  }

}
