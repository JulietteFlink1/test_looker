view: coupa_ordering {
  sql_table_name: `flink-data-dev.dbt_vbreda_curated.coupa_ordering`
    ;;

  dimension: coupa_order_line_uuid {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.coupa_order_line_uuid ;;
  }

  dimension_group: order_created {
    group_label: "Dates & Timestamp"
    type: time
    timeframes: [
      time,
      date,
      week,
      month
    ]
    sql: ${TABLE}.order_created_at_timestamp ;;
  }

  dimension: unit_price {
    type: number
    description: "Price of a single unit of the item that was purchased. In euros."
    sql: ${TABLE}.unit_price ;;
  }

  dimension: item_description {
    type: string
    description: "Description of the item that was ordered."
    sql: ${TABLE}.item_description ;;
  }

  dimension: hub_code {
    type: string
    description: "Code of a hub identical to back-end source tables."
    sql: ${TABLE}.hub_code ;;
  }

  dimension: po_number {
    type: string
    description: "Purchase Order number reported in Coupa."
    sql: ${TABLE}.po_number ;;
  }

  dimension: quantity {
    type: number
    hidden: yes
    description: "Number of units of the item ordered."
    sql: ${TABLE}.quantity ;;
  }

  dimension: amount_ordered {
    type: number
    hidden: yes
    sql: ${TABLE}.amount_ordered ;;
  }

  dimension: requester_name {
    description: "Name of the person who requested the order."
    type: string
    sql: ${TABLE}.requester_name ;;
  }

  dimension: period_name {
    type: string
    description: "Name of the budgeted period. Contains information about the country and month. Eg. DE Budget 10/22."
    sql: ${TABLE}.period_name ;;
  }

  measure: sum_quantity{
    group_label: "Orders"
    label: "Quantity"
    description: "Number of units of the item ordered."
    type: sum
    sql: ${quantity} ;;
  }

  measure: sum_amount_ordered {
    group_label: "Orders"
    label: "Amount Ordered"
    description: "Sum of the unit prices multiplied by the quantities ordered."
    type: sum
    sql: ${amount_ordered} ;;
    value_format_name: decimal_2
  }

  ######### Parameters

  parameter: date_granularity {
    group_label: "Dates & Timestamp"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }

  dimension: date_granularity_pass_through {
    group_label: "Parameters"
    description: "To use the parameter value in a table calculation (e.g WoW, % Growth) we need to materialize it into a dimension "
    type: string
    hidden: no # yes
    sql:
            {% if date_granularity._parameter_value == 'Day' %}
              "Day"
            {% elsif date_granularity._parameter_value == 'Week' %}
              "Week"
            {% elsif date_granularity._parameter_value == 'Month' %}
              "Month"
            {% endif %};;
  }


  ######## Dynamic Dimensions

  dimension: order_created_date_dynamic {
    group_label: "> Dates"
    label: "Order Created Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${order_created_date}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${order_created_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${order_created_month}
    {% endif %};;
  }

}
