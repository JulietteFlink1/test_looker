view: commercial_department_names {
  sql_table_name: `flink-data-prod.google_sheets.commercial_department_names`
    ;;

  dimension: unique_id {
    hidden: yes
    primary_key: yes
    type: string
    sql: concat(${TABLE}.department, ${TABLE}.category, ${TABLE}.subcategory) ;;
  }

  dimension: category {
    label: "Category Name"
    group_label: "> Product Attributes"
    type: string
    hidden: yes
    sql: ${TABLE}.category ;;
  }

  dimension: department {
    label: "Department Name"
    group_label: "> Product Attributes"
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: subcategory {
    label: "Subcategory Name"
    group_label: "> Product Attributes"
    type: string
    hidden: yes
    sql: ${TABLE}.sub_category ;;
  }

  measure: count {
    type: count
    drill_fields: []
    hidden: yes
  }
}
