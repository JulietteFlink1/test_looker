view: sequence_added{
  sql_table_name: `flink-data-prod.reporting.sequence_added`;;
#   derived_table: {
#     sql:
# select a.* from `flink-data-prod.reporting.sequence_added` a
#   left join  `flink-data-prod.curated.products` b
#   on a.sku = b.product_sku;;
# }


  dimension: partition_date {
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


  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }


  dimension: seq_added {
    type: string
    sql: case when ${TABLE}.seq_added="10+" then "Higher than 9" else ${TABLE}.seq_added end  ;;
  }

  measure: sum_item_price_gross {
    type: sum
    sql: ${TABLE}.sum_item_price_gross ;;
  }

  measure: number_of_orders {
    type: sum
    sql: ${TABLE}.number_of_orders ;;
  }



  measure: aiv {
    type: number
    description: "AIV"
    value_format_name: decimal_2
    sql: ${sum_item_price_gross}/nullif(${number_of_orders},0) ;;

  }





  dimension_group: created {
    group_label: "* Dates and Timestamps *"
    label: "Order"
    description: "Order Placement Date"
    type: time
    timeframes: [
      date,
      day_of_week,
      week,
      month,
      year
    ]
    sql: ${TABLE}.order_date ;;
    datatype: date

  }


  dimension: day {
    type: date
    datatype: date
    sql: ${TABLE}.order_date ;;
  }

  dimension: month {
    type: date_month
    datatype: date
    sql: ${TABLE}.order_date ;;
  }


  dimension: week {
    type: date_week
    datatype: date
    sql: ${TABLE}.order_date ;;
  }


  parameter: date_granularity {
    group_label: "* Dates and Timestamps *"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }

  dimension: order_date {
    group_label: "* Dates and Timestamps *"
    label: "Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
      {% if date_granularity._parameter_value == 'Day' %}
      ${day}
      {% elsif date_granularity._parameter_value == 'Week' %}
      ${week}
      {% elsif date_granularity._parameter_value == 'Month' %}
      ${month}
      {% endif %};;
  }




  # dimension: substitute_group {
  #   type: string
  #   sql: ${TABLE}.substitute_group ;;
  # }



  # dimension: category {
  #   type: string
  #   sql: ${TABLE}.category ;;
  # }


  # dimension: subcategory {
  #   type: string
  #   sql: ${TABLE}.subcategory ;;
  # }

  # dimension: product_name {
  #   type: string
  #   sql: ${TABLE}.product_name ;;
  # }





  # parameter: product_granularity_parameter {
  #   group_label: "> Product Attributes"
  #   label: "Product Granularity Parameter"
  #   type: unquoted
  #   allowed_value: { value: "Subcategory" }
  #   allowed_value: { value: "Category" }
  #   allowed_value: { value: "Substitute" }
  #   default_value: "Category"
  # }

  # dimension: product_granularity {
  #   group_label: "> Product Attributes"
  #   label: "Product Granularity (Dynamic)"
  #   label_from_parameter: product_granularity_parameter
  #   sql:
  #   {% if product_granularity_parameter._parameter_value == 'Subcategory' %}
  #     ${subcategory}
  #   {% elsif product_granularity_parameter._parameter_value == 'Category' %}
  #     ${category}
  #   {% elsif product_granularity_parameter._parameter_value == 'Substitute' %}
  #     coalesce(${substitute_group},${product_name})
  #   {% endif %};;
  # }


}
