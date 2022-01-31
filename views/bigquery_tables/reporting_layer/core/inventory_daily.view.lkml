view: inventory_daily {
  sql_table_name: `flink-data-prod.reporting.inventory_daily`
    ;;

  # defines all fields, that only work together with other views being joined
  # .. coupled together in a set, so that they can easily be excluded
  set: cross_referenced_metrics {
    fields: [
      number_of_total_skus_per_day_and_hub,
      pct_products_booked_in_same_day
    ]
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~     Parameter & Dynamic Fields     ~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter: date_granularity {
    group_label: "* Parameters & Dynamic Fields *"
    label: "Select Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Week"
  }
  dimension: report_date_dynamic {
    group_label: "* Parameters & Dynamic Fields *"
    label: "Inventory Report Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${report_date}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${report_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${report_month}
    {% endif %};;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========
  dimension_group: report {
    label: "Inventory Report"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.report_date ;;
  }


  # =========  hidden   =========
  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
    hidden: yes
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
    hidden: yes
  }


  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
    hidden: yes
  }


  # =========  IDs   =========
  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
    primary_key: yes
  }

  # =========  Measures - Dims per Day/Hub/SKU   =========
  dimension: number_of_correction_product_damaged {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.number_of_correction_product_damaged ;;
  }

  dimension: number_of_correction_product_expired {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.number_of_correction_product_expired ;;
  }

  dimension: number_of_correction_stock_taking_increased {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.number_of_correction_stock_taking_increased ;;
  }

  dimension: number_of_correction_stock_taking_reduced {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.number_of_correction_stock_taking_reduced ;;
  }

  dimension: number_of_hours_oos {
    group_label: "OOS-Dimensions"
    type: number
    sql: ${TABLE}.number_of_hours_oos ;;
  }

  dimension: number_of_hours_open {
    group_label: "OOS-Dimensions"
    type: number
    sql: ${TABLE}.number_of_hours_open ;;
  }

  dimension: number_of_outbound_orders {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.number_of_outbound_orders ;;
  }

  dimension: number_of_outbound_others {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.number_of_outbound_others ;;
  }

  dimension: number_of_total_correction {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.number_of_total_correction ;;
  }

  dimension: number_of_total_inbound {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.number_of_total_inbound ;;
  }

  dimension: number_of_total_outbound {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.number_of_total_outbound ;;
  }

  dimension: number_of_unspecified {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.number_of_unspecified ;;
  }

  dimension: quantity_from {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.quantity_from ;;
  }

  dimension: quantity_to {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.quantity_to ;;
  }



  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  # ~~~~~~~~~~~~~  START: Out-Of-Stock Metrics  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: sum_of_hours_open {

    label: "# Opening Hours"
    description: "The number of hours, a hub was open (hours were customers could buy)"
    group_label: "OOS-Measures"

    type: sum
    sql: ${number_of_hours_open} ;;

    value_format_name: decimal_1
  }

  measure: sum_of_hours_oos {

    label: "# Hours Out-Of-Stock"
    description: "The number of business hours, a specific SKU was not available in a hub"
    group_label: "OOS-Measures"

    type: sum
    sql: ${number_of_hours_oos} ;;

    value_format_name: decimal_1

  }

  measure: pct_oos {

    label: "% Out Of Stock"
    description: "This rate gives the sum of all hours, an SKU was out of stock compared to all hours, the hub was open for orders"
    group_label: "OOS-Measures"

    type: number
    sql: ${sum_of_hours_oos} / nullif( ${sum_of_hours_open},0) ;;

    value_format_name: percent_1
    html:
    {% if value >= 0.9 %}
      <p style="color: white; background-color: #FF206E;font-size: 100%; text-align:center">{{ rendered_value }}</p>
    {% elsif value >= 0.8 %}
      <p style="color: white; background-color: #FF5C95; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% elsif value >= 0.6 %}
      <p style="color: white; background-color: #FF99BD; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% elsif value >= 0.4 %}
      <p style="color: black; background-color: #FFD6E4; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% elsif value >= 0.2 %}
      <p style="color: black; background-color: #FEFFC2; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% elsif value > 0 %}
      <p style="color: black; background-color: #FFFFEB; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% else %}
      <p style="color: black; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% endif %};;
  }

  measure: pct_in_stock {

    label: "% In Stock"
    description: "This rate gives the sum of all hours, an SKU was in stock compared to all hours, the hub was open for orders"
    group_label: "OOS-Measures"

    type: number
    sql: 1 - ${pct_oos} ;;

    value_format_name: percent_1
    html:
    {% if value <= 0.1 %}
    <p style="color: white; background-color: #FF206E;font-size: 100%; text-align:center">{{ rendered_value }}</p>
    {% elsif value <= 0.2 %}
    <p style="color: white; background-color: #FF5C95; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% elsif value <= 0.4 %}
    <p style="color: white; background-color: #FF99BD; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% elsif value <= 0.6 %}
      <p style="color: black; background-color: #FFD6E4; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% elsif value <= 0.8 %}
      <p style="color: black; background-color: #FEFFC2; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% elsif value <= 1 %}
      <p style="color: black; background-color: #FFFFEB; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% else %}
      <p style="color: black; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% endif %};;
  }
  # ~~~~~~~~~~~~~    END: Out-Of-Stock Metrics  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~








  # ~~~~~~~~~~~~~  START: Inventory Change  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: avg_inventory {

    label: "AVG Inventory Level"
    description: "The average stock level, based on averaged starting and ending inventory level per day and hub"
    group_label: "Inventory Change"

    type: average
    sql: ( (${quantity_from} + ${quantity_to}) / 2  ) ;;

    value_format_name: decimal_1
  }

  measure: sum_of_total_correction {

    label: "# Corrections - Total"
    description: "The sum of all inventory corrections"
    group_label: "Inventory Change"

    type: sum
    sql: ${number_of_total_correction} ;;

    value_format_name: decimal_0
  }

  measure: sum_of_total_inbound {

    label: "# Inbound - Total"
    description: "The sum of all inventory re-stockings"
    group_label: "Inventory Change"

    type: sum
    sql: ${number_of_total_inbound} ;;

    value_format_name: decimal_0
  }

  measure: sum_of_total_outbound {

    label: "# Outbound - Total"
    description: "The sum of all inventory outbounds"
    group_label: "Inventory Change"

    type: sum
    sql: ${number_of_total_outbound} ;;

    value_format_name: decimal_0
  }


  measure: sum_of_correction_product_damaged {

    label: "# Corrections - Product Damaged"
    description: "The sum of all inventory corrections due to damaged products"
    group_label: "Inventory Change"

    type: sum
    sql: ${number_of_correction_product_damaged} ;;

    value_format_name: decimal_0
  }

  measure: sum_of_correction_product_expired {

    label: "# Corrections - Product Expired"
    description: "The sum of all inventory corrections due to expired products"
    group_label: "Inventory Change"

    type: sum
    sql: ${number_of_correction_product_expired} ;;

    value_format_name: decimal_0
  }

  measure: sum_of_correction_stock_taking_increased {

    label: "# Corrections - Stock Taging (Increased)"
    description: "The sum of all inventory corrections due to stock taking activities, that increased the inventory level"
    group_label: "Inventory Change"

    type: sum
    sql: ${number_of_correction_stock_taking_increased} ;;

    value_format_name: decimal_0
  }

  measure: sum_of_correction_stock_taking_reduced {

    label: "# Corrections - Stock Taging (Reduced)"
    description: "The sum of all inventory corrections due to stock taking activities, that reduced the inventory level"
    group_label: "Inventory Change"

    type: sum
    sql: ${number_of_correction_stock_taking_reduced} ;;

    value_format_name: decimal_0
  }

  measure: sum_of_outbound_orders {

    label: "# Outbound - Orders"
    description: "The number of all inventory changes due to customer orders"
    group_label: "Inventory Change"

    type: sum
    sql: ${number_of_outbound_orders} ;;

    value_format_name: decimal_0
  }

  measure: sum_of_outbound_others {

    # TODO: what do these entail?
    label: "# Outbound - Others"
    description: "The sum of outbounded items, that are NOT due to customer orders"
    group_label: "Inventory Change"

    type: sum
    sql: ${number_of_outbound_others} ;;

    value_format_name: decimal_0
  }



  measure: sum_of_unspecified {

    label: "# Unspecified Inventory Changes"
    description: "The sum of all inventory changes, that are not mapped to specific reasons"
    group_label: "Inventory Change"

    type: sum
    sql: ${number_of_unspecified} ;;

    value_format_name: decimal_0
  }

  measure: turnover_rate {

    label:       "Product Turnover Rate"
    description: "Defined as the quantity sold per SKU divided by the Average Inventory over the observed period of time"
    group_label: "Inventory Change"

    type: average
    sql: abs(${number_of_outbound_orders}) / nullif(${quantity_from},0) ;;

    value_format_name: decimal_2

  }

  # ~~~~~~~~~~~~~    END: Inventory Change  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



  #   >>>>   https://goflink.atlassian.net/browse/DATA-1419
  measure: number_of_inbounded_skus_per_day_and_hub  {

    hidden: yes

    type: count_distinct
    sql: concat(${sku}, ${report_date}, ${hub_code}) ;;
    filters: [number_of_total_inbound: ">0"]

    value_format_name: decimal_0

  }

  measure: number_of_total_skus_per_day_and_hub  {

    hidden: yes

    type: count_distinct
    sql: concat(${products_hub_assignment.sku}, ${products_hub_assignment.report_date}, ${products_hub_assignment.hub_code}) ;;

    value_format_name: decimal_0

  }

  measure: pct_products_booked_in_same_day {

    label: "% of products booked in same day"
    description: "Defined as No of products booked in / No of total products per day and hub"
    group_label: "Inventory Management"

    type: number
    sql: ${number_of_inbounded_skus_per_day_and_hub} / nullif( ${number_of_total_skus_per_day_and_hub} ,0) ;;

    value_format_name: percent_1
  }

  #   https://goflink.atlassian.net/browse/DATA-1419  <<<<


  measure: count {

    type: count
  }








}
