view: key_value_items {
  sql_table_name: `flink-data-prod.reporting.key_value_items`;;


dimension: kvi_date {
  type: date
  datatype: date
  sql: ${TABLE}.partition_date ;;
}



  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }


  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }


  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }


  dimension: subs_grp_obst_gemuse {
    type: string
    sql: ${TABLE}.subs_grp_obst_gemuse ;;
  }

  dimension: kvi_ranking {
    type: number
    sql: ${TABLE}.rank_country_kvi ;;
  }

  dimension: is_kvi {
    type: yesno
    sql: ${TABLE}.is_kvi ;;
    label: "Is KVI"
  }

  dimension: kvi {
    type: string
    sql: case when (${sku} is not null) then "KVI" else "Not KVI" end ;;
  }


  }
