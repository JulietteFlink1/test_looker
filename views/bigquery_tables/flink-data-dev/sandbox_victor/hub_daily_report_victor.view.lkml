# Owner:   Victor Breda
# Created: 2022-03-21

# This views contains performance measures, aggregated by date, hub and country


view: hub_daily_report_victor {
  sql_table_name: `flink-data-prod.sandbox_victor.hub_daily_report_victor`
    ;;
  view_label: "* Hub Daily Report Victor *"





  parameter: date_granularity {
    group_label: "* Dates and Timestamps *"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }

  parameter: KPI_parameter {
    label: "* KPI Parameter *"
    type: unquoted
    allowed_value: { value: "orders" label: "# Orders"}
    allowed_value: {value: "hours_worked" label: "# Hours Worked"}
    allowed_value: {value: "riders_worked" label: "# Riders Worked"}
    allowed_value: {value: "avg_nb_items" label: "AVG # Items"}
    allowed_value: {value: "avg_fulfillment_time" label: "AVG Fulfillment Time"}
    default_value: "orders"
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  dimension: country_iso {

    label:       "Country ISO"
    description: "Country identifier"
    group_label: "* Dimension *"

    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {

    label:       "Hub Code"
    description: "Hub identifier"
    group_label: "* Dimension *"

    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension_group: created {
    group_label: "* Dates and Timestamps *"
    label: "Order"
    description: "Date at which order was placed"
    type: time
    timeframes: [
      date,
      week,
      month,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.order_date ;;
  }

  dimension: date {
    group_label: "* Dates and Timestamps *"
    label: "Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${created_date}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${created_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${created_month}
    {% endif %};;
  }

  dimension: hub_daily_uuid {

    label:       "Hub Daily ID"
    description: "Unique identifier"
    group_label: "* Dimension *"
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.hub_daily_uuid ;;

  }

  dimension: number_of_orders {
    label:"# orders"
    description: ""
    hidden:  yes
    type: number
    sql: ${TABLE}.number_of_orders ;;

    value_format_name: decimal_1
  }

  dimension: number_of_worked_employees {
    label:       "# riders worked"
    description: "# riders who worked in the hub on that day"
    hidden:  yes
    type: number
    sql: ${TABLE}.number_of_worked_employees ;;

    value_format_name: decimal_1
  }

  dimension: number_of_worked_hours {
    label:       "# hours worked"
    description: "# hours worked in the hub on that day"
    hidden:  yes
    type: number
    sql: ${TABLE}.number_of_worked_hours ;;

    value_format_name: decimal_1
  }

  # dimension: number_of_orders_1o {
  #   label:       "# orders [orders table]"
  #   description: "# orders from orders table, debug comparison"
  #   hidden:  yes
  #   type: number
  #   sql: ${TABLE}.number_of_orders_1o ;;

  #   value_format_name: decimal_1
  # }

  dimension: total_fulfillment_time {
    label:       "Total amount of fulfillment time"
    description: "Sum of fulfillment time for all orders"
    hidden:  yes
    type: number
    sql: ${TABLE}.total_fulfillment_time ;;

    value_format_name: decimal_1
  }

  dimension: total_number_of_items {
    label:       "# items"
    description: "# items"
    hidden:  yes
    type: number
    sql: ${TABLE}.total_number_of_items ;;

    value_format_name: decimal_1
  }

  dimension: date_granularity_pass_through {
    group_label: "* Parameters *"
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


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



  measure: KPI {
    group_label: "* Dynamic KPI Fields *"
    label: "KPI - Dynamic"
    label_from_parameter: KPI_parameter
    value_format: "#,##0.00"
    type: number
    sql:
    {% if KPI_parameter._parameter_value == 'orders' %}
      ${nb_of_orders}
    {% elsif KPI_parameter._parameter_value == 'hours_worked' %}
      ${nb_of_worked_hours}
    {% elsif KPI_parameter._parameter_value == 'riders_worked' %}
      ${nb_of_worked_employees}
    {% elsif KPI_parameter._parameter_value == 'avg_nb_items' %}
      ${weighted_avg_number_of_items}
    {% elsif KPI_parameter._parameter_value == 'avg_fulfillment_time' %}
      ${weighted_avg_fulfillment_time}

    {% endif %};;
    }


  measure: nb_of_orders {

    label: "# Orders"
    type: sum
    sql: ${number_of_orders} ;;

    value_format_name: decimal_1
  }

  measure: nb_of_worked_employees {

    label:       "# Riders Worked"
    description: "# riders who worked in the hub on that day"
    type: sum
    sql: ${number_of_worked_employees} ;;

    value_format_name: decimal_1
  }


  measure: nb_of_worked_hours {

    label:       "# Hours Worked"
    description: "# hours worked in the hub on that day"
    type: sum
    sql: ${number_of_worked_hours} ;;

    value_format_name: decimal_1
  }



  measure: tot_fulfillment_time {

    label:       "Total amount of fulfillment time"
    description: "Sum of fulfillment time for all orders"
    hidden:  yes
    type: sum
    sql: ${total_fulfillment_time} ;;

    value_format_name: decimal_1
  }

  measure: tot_number_of_items {

    label:       "# Items"
    description: "# items"
    hidden:  yes
    type: sum
    sql: ${total_number_of_items} ;;

    value_format_name: decimal_1
  }

  measure: weighted_avg_fulfillment_time{
    label:       "AVG Fulfillment Time"
    type: number
    sql: ${tot_fulfillment_time}/${nb_of_orders} ;; #*(60/86400)

    value_format_name: decimal_1 #"mm:ss"
  }

  measure: weighted_avg_number_of_items{
    label:       "AVG #Items"
    type: number
    sql: ${tot_number_of_items}/${nb_of_orders} ;;

    value_format_name: decimal_1
  }

  measure: rider_utr {
    label: "AVG Rider UTR"
    type: number
    description: "# Orders from opened hub / # Worked Rider Hours"
    sql: ${nb_of_orders} / NULLIF(${nb_of_worked_hours}, 0);;
    value_format_name: decimal_2
    group_label: "UTR"
  }
}
