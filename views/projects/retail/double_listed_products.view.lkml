view: double_listed_products {
  sql_table_name: `flink-data-prod.curated.double_listed_products`
    ;;

  dimension: category_name {
    type: string
    label: "Category"
    hidden: no
    sql: ${TABLE}.category_name ;;
  }

  dimension: is_double_listed {
    type: string
    label: "Double listed"
    hidden: no
    sql: ${TABLE}.is_double_listed ;;
  }

  dimension_group: report {
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
    sql: ${TABLE}.report_date ;;
  }

  dimension: sku {
    type: string
    label: "SKU"
    hidden: no
    sql: ${TABLE}.sku ;;
  }

  dimension: subcategory_name {
    type: string
    label: "Subcategory"
    hidden: no
    sql: ${TABLE}.subcategory_name ;;
  }

  dimension: subcategory_id {
    type: string
    hidden: yes
    sql: ${TABLE}.subcategory_id ;;
  }

  dimension: table_uuid {
    type: string
    hidden: yes
    sql: ${TABLE}.table_uuid ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: [category_name, subcategory_name]
  }
}
