view: geographic_pricing_hub_cluster {
  sql_table_name: `flink-data-prod.google_sheets.geographic_pricing_hub_cluster`;;



  dimension: price_hub_cluster {
    type: string
    sql: ${TABLE}.price_hub_cluster ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }
}
