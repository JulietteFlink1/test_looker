explore: dc_bucket {
    hidden: yes
}

view: dc_bucket {
  view_label: "*DC Bucket Data*"
  sql_table_name: `flink-supplychain-prod.curated.dc_bucket`
    ;;
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # =========  __main__   =========
  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }
  dimension: sku {
    type: number
    sql: ${TABLE}.sku ;;
  }
  dimension: dc_name {
    type: string
    sql: ${TABLE}.dc_name ;;
  }
  dimension: is_active {
    description: "Indicates if product location is found in hub"
    type: string
    sql: ${TABLE}.is_active ;;
  }
  dimension: available_stock {
    type: number
    sql: ${TABLE}.available_stock ;;
  }
}
