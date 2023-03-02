view: availability_waterfall {
  sql_table_name: `flink-supplychain-prod.curated.availability_waterfall`
    ;;

  dimension: block_flag {
    type: number
    sql: ${TABLE}.block_flag ;;
  }

  dimension: bucket {
    type: string
    sql: ${TABLE}.bucket ;;
  }

  dimension: category_master {
    type: string
    sql: ${TABLE}.category_master ;;
  }

  dimension: co_mrp_flag {
    type: number
    sql: ${TABLE}.co_mrp_flag ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: country_sum_of_hours_oos {
    type: number
    sql: ${TABLE}.country_sum_of_hours_oos ;;
  }

  dimension: country_sum_of_hours_open {
    type: number
    sql: ${TABLE}.country_sum_of_hours_open ;;
  }

  dimension: ct_substitute_group {
    type: string
    sql: ${TABLE}.ct_substitute_group ;;
  }

  dimension: delivery_issue_flag {
    type: number
    sql: ${TABLE}.delivery_issue_flag ;;
  }

  dimension: first_inbound_flag {
    type: number
    sql: ${TABLE}.first_inbound_flag ;;
  }

  dimension: fr_missing_ods {
    type: number
    sql: ${TABLE}.fr_missing_ods ;;
  }

  dimension: frequent_oos_flag {
    type: number
    sql: ${TABLE}.frequent_oos_flag ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: hub_status {
    type: string
    sql: ${TABLE}.hub_status ;;
  }

  dimension: hubs_ct_is_active_hub {
    type: string
    sql: ${TABLE}.hubs_ct_is_active_hub ;;
  }

  dimension: incorrect_pu_flag {
    type: number
    sql: ${TABLE}.incorrect_pu_flag ;;
  }

  dimension_group: ingestion {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.ingestion_date ;;
  }

  dimension: late_inbound_flag {
    type: number
    sql: ${TABLE}.late_inbound_flag ;;
  }

  dimension: long_term_oos_flag {
    type: number
    sql: ${TABLE}.long_term_oos_flag ;;
  }

  dimension: new_hub_flag {
    type: number
    sql: ${TABLE}.new_hub_flag ;;
  }

  dimension: newly_reactived_flag {
    type: number
    sql: ${TABLE}.newly_reactived_flag ;;
  }

  dimension: no_inbound_all_hubs_flag {
    type: number
    sql: ${TABLE}.no_inbound_all_hubs_flag ;;
  }

  dimension: no_orders_flag {
    type: number
    sql: ${TABLE}.no_orders_flag ;;
  }

  dimension: oos_hours {
    type: number
    sql: ${TABLE}.oos_hours ;;
  }

  dimension: opening_hours {
    type: number
    sql: ${TABLE}.opening_hours ;;
  }

  dimension: parent_bucket {
    type: string
    sql: ${TABLE}.parent_bucket ;;
  }

  dimension: parent_category {
    type: string
    sql: ${TABLE}.parent_category ;;
  }

  dimension: pct_in_stock {
    type: number
    sql: ${TABLE}.pct_in_stock ;;
  }

  dimension: pct_oos {
    type: number
    sql: ${TABLE}.pct_oos ;;
  }

  dimension: po_inbound_less_80pct_flag {
    type: number
    sql: ${TABLE}.po_inbound_less_80pct_flag ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: promotion_filter {
    type: string
    sql: ${TABLE}.promotion_filter ;;
  }

  dimension: promotion_flag {
    type: number
    sql: ${TABLE}.promotion_flag ;;
  }

  dimension: promotion_no_disc_flag {
    type: number
    sql: ${TABLE}.promotion_no_disc_flag ;;
  }

  dimension: really_long_term_oos_flag {
    type: number
    sql: ${TABLE}.really_long_term_oos_flag ;;
  }

  dimension: replenishment_group {
    type: string
    sql: ${TABLE}.replenishment_group ;;
  }

  dimension_group: report_week {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.report_week ;;
  }

  dimension: risky_flag {
    type: number
    sql: ${TABLE}.risky_flag ;;
  }

  dimension: sales_greater_forecast {
    type: number
    sql: ${TABLE}.sales_greater_forecast ;;
  }

  dimension: sku {
    type: string
    sql: cast(${TABLE}.sku as string) ;;
  }

  dimension: sl1_too_early_out_flag {
    type: number
    sql: ${TABLE}.sl1_too_early_out_flag ;;
  }

  dimension: sl1_too_late_inb_flag {
    type: number
    sql: ${TABLE}.sl1_too_late_inb_flag ;;
  }

  dimension: space_rest_flag {
    type: number
    sql: ${TABLE}.space_rest_flag ;;
  }

  dimension: sub_category {
    type: string
    sql: ${TABLE}.sub_category ;;
  }

  dimension: supplier_id {
    type: string
    sql: ${TABLE}.supplier_id ;;
  }

  dimension: supplier_name {
    type: string
    sql: ${TABLE}.supplier_name ;;
  }

  dimension: supplier_oos_flag {
    type: number
    sql: ${TABLE}.supplier_oos_flag ;;
  }

  dimension: technical_issue_flag {
    type: number
    sql: ${TABLE}.technical_issue_flag ;;
  }

  dimension: too_early_out_slgreater1_flag {
    type: number
    sql: ${TABLE}.too_early_out_slgreater1_flag ;;
  }

  dimension: under_fcst_flag {
    type: number
    sql: ${TABLE}.under_fcst_flag ;;
  }

  measure: count {
    type: count
    drill_fields: [product_name, supplier_name]
  }
}
