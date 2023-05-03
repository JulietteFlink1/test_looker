view: key_value_items {
  sql_table_name: `flink-data-prod.reporting.key_value_items`;;


dimension: kvi_date {
  type: date
  datatype: date
  sql: case when concat(extract(year from ${TABLE}.partition_date)||extract(month from ${TABLE}.partition_date)) =
                 concat(extract(year from current_date())||extract(month from current_date()))
  then ${TABLE}.partition_date else null end;;
}



  dimension: country_iso {
    type: string
    sql: select ${TABLE}.country_iso;;
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

  }
