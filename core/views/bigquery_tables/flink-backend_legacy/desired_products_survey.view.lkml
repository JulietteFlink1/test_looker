view: desired_products_survey {
  sql_table_name: `flink-backend.gsheet_desired_products.Pickery_Brands`
    ;;

  dimension_group: submitted {
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
    sql: ${TABLE}.submitted_at ;;
  }

  dimension: token {
    type: string
    primary_key: yes
    sql: ${TABLE}.token ;;
  }

  dimension: answer {
    type: string
    sql: ${TABLE}.welches_produkt_oder_marke_fehlt_dir_ ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
