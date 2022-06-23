view: geographic_pricing_sku_cluster {
  sql_table_name: `flink-data-prod.google_sheets.geographic_pricing_sku_cluster`;;



  dimension: price_sku_cluster {
    type: string
    sql: ${TABLE}.price_sku_cluster ;;
  }

  dimension: price_sku_cluster_desc {
    type: string
    sql: ${TABLE}.price_sku_cluster_desc ;;
  }

  dimension: sku {
    type: string
    sql: cast(${TABLE}.sku as string) ;;
  }

  dimension: price_sku_cluster_actual {
    type: string
    sql: ${TABLE}.price_sku_cluster_actual ;;
  }

  }
