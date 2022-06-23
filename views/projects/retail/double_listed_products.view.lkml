view: double_listed_products {
  sql_table_name: `flink-data-prod.curated.double_listed_products`
    ;;


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

  dimension: is_double_listed {
    type: string
    label: "Double listed"
    hidden: no
    sql: ${TABLE}.is_double_listed ;;
  }

dimension: category_name {
    type: string
    label: "Category"
    hidden: no
    sql: ${TABLE}.category_name ;;
  }

  dimension: subcategory_name {
    type: string
    label: "Subcategory"
    hidden: no
    sql: ${TABLE}.subcategory_name ;;
  }

  dimension: is_label {
    type: string
    label: "Listed as Label"
    hidden: no
    sql: ${TABLE}.is_label;;
  }

  dimension: is_special {
    type: string
    label: "Listed as Special"
    hidden: no
    sql: ${TABLE}.is_special;;
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
