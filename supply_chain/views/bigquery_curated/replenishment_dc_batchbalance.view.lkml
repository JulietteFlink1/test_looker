view: replenishment_dc_batchbalance {
  sql_table_name: `flink-data-prod.curated.replenishment_dc_batchbalance`
    ;;


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~   Date Dimensions   ~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension_group: stock_balance_date {
    label: "Balance"
    group_label: "* Date Dimensions *"
    description: "Inventory balance date"
    type: time
    timeframes: [
      date
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.stock_balance_date ;;
  }

  dimension_group: stock_balance_timestamp {
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
    hidden: yes
    group_label: "* Date Dimensions *"
    sql: ${TABLE}.stock_balance_timestamp ;;
  }

  dimension_group: delivery_timestamp {
    type: time
    timeframes: [
      date
    ]
    hidden: yes
    group_label: "* Date Dimensions *"
    sql: ${TABLE}.delivery_timestamp ;;
  }

  dimension_group: production_date {
    type: time
    timeframes: [
      date
    ]
    convert_tz: no
    datatype: date
    hidden: yes
    group_label: "* Date Dimensions *"
    sql: ${TABLE}.production_date ;;
  }

  dimension_group: sku_expiration {
    label: "Expiration"
    timeframes: [
      date
    ]
    type: time
    datatype: date
    group_label: "* Date Dimensions *"
    sql: ${TABLE}.sku_expiration_date ;;
  }

  dimension_group: sku_max_outbound {
    label: "Max Outbound"
    type: time
    timeframes: [
      date
    ]
    convert_tz: no
    datatype: date
    group_label: "* Date Dimensions *"
    sql: ${TABLE}.sku_max_outbound_date ;;
  }

  dimension_group: sku_min_outbound {
    label: "Min Outbound"
    type: time
    timeframes: [
      date
    ]
    convert_tz: no
    datatype: date
    group_label: "* Date Dimensions *"
    sql: ${TABLE}.sku_min_outbound_date ;;
  }


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  dimension: table_uuid {
    type: string
    hidden: yes
    sql: ${TABLE}.table_uuid ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: dc_code {
    label: "Distribution Center Code"
    type: string
    sql: ${TABLE}.dc_code ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: sku_description {
    type: string
    sql: ${TABLE}.sku_description ;;
  }

  dimension: origin_file {
    type: string
    hidden: yes
    sql: ${TABLE}.origin_file ;;
  }


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~   Numeric Dimensions   ~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  dimension: available_stock {
    group_label: "* Numeric Dimensions *"
    type: number
    sql: ${TABLE}.available_stock ;;
  }

  dimension: blocked_stock {
    group_label: "* Numeric Dimensions *"
    type: number
    sql: ${TABLE}.blocked_stock ;;
  }

  dimension: current_stock {
    group_label: "* Numeric Dimensions *"
    type: number
    hidden: yes
    sql: ${TABLE}.current_stock ;;
  }


  dimension: inbounded_amount {
    group_label: "* Numeric Dimensions *"
    type: number
    sql: ${TABLE}.inbounded_amount ;;
  }

  dimension: outbounded_amount {
    group_label: "* Numeric Dimensions *"
    type: number
    sql: ${TABLE}.outbounded_amount ;;
  }


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~   Filters   ~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#  parameter: expires_in {
#    group_label: "* Parameters & Dynamic Fields *"
#    label: "Expires in the next 'x' days"
#    type: unquoted
#    allowed_value: { value: "0" label: "7 days" }
#    allowed_value: { value: "1" label: "15 days" }
#    allowed_value: { value: "2" label: "30 days" }
#    default_value: "7"
#  }


  dimension_group: current {
    type: time
    timeframes: [
      date
    ]
    datatype: date
    hidden: yes
    sql: current_date() ;;
  }


  dimension: date_diff_numeric {
    label: "Days until Expiration Date"
    type: number
    sql: date_diff(${sku_expiration_date}, ${current_date}, day) ;;
  }

  dimension: is_expiration_date_in_the_next_7days{
    label: "Expires within the next 7 days"
    group_label: "* Expiration Filters *"
    type: yesno
    sql: ${date_diff_numeric} <= 7 ;;
  }

  dimension: is_expiration_date_in_the_next_15days{
    label: "Expires within the next 15 days"
    group_label: "* Expiration Filters *"
    type: yesno
    sql: ${date_diff_numeric} <= 15 ;;
  }

  dimension: is_expiration_date_in_the_next_30days{
    label: "Expires within the next 30 days"
    group_label: "* Expiration Filters *"
    type: yesno
    sql: ${date_diff_numeric} <= 30 ;;
  }

 # dimension: expires {
#    group_label: "*"
#    type: number
#    sql:
#
#      {% if    ${expires_in}._parameter_value == '0' %}
#       ${is_expiration_date_in_the_next_7days}
#
#      {% ${expires_in}._parameter_value == '1' %}
#      ${is_expiration_date_in_the_next_15days}
#
#      {% ${expires_in}._parameter_value == '2' %}
#      ${is_expiration_date_in_the_next_30days}
#
#      {% endif %}
#      ;;

#  }


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~   Measures   ~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  measure: count {
    type: count
    hidden: yes
    drill_fields: []
  }

  measure: total_stock_available {
    label: "# Total Stock Available"
    description: "Use this metric when checking the current stock"
    type: sum

    sql: ${available_stock} ;;
  }

  measure: avg_stock_available {
    label: "AVG Stock Available"
    hidden: yes
    description: "This metric must be used when comparing different time periods"
    type: average

    sql: ${replenishment_dc_agg_derived_table.total_stock_available} ;;
    value_format_name: decimal_2
  }

  measure: batchs_per_sku {
    label: "# Batches per Sku"
    description: "Total Batches per Sku with different expiration dates"
    type: count_distinct

    sql: ${sku_expiration_date} ;;
  }

  measure: min_expiration_date {
    label: "Min Expiration Date"
    type: date
    datatype: date

    sql: min(${sku_expiration_date}) ;;
  }

  measure: min_days_until_expiration {
    label: "Min Days Until Expiration"
    type: number

    sql: min(${date_diff_numeric}) ;;
  }

  measure: total_stock_available_in_units  {
    label: "# Total Stock Available in Units"
    description: "Use this metric when checking the current stock"
    type: sum
    sql: ${available_stock} * cast(${replenishment_dc_assortment.pu_per_hu} as numeric) ;;
  }

  measure: avg_stock_available_in_units  {
    label: "AVG Stock Available in Units"
    hidden: yes
    description: "This metric must be used when comparing different time periods"
    type: average
    sql: ${replenishment_dc_agg_derived_table.total_stock_available} * cast(${replenishment_dc_assortment.pu_per_hu} as numeric) ;;
    value_format_name: decimal_2
  }



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~   Period Comparison Measures   ~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  measure: stock_available_last_7days  {
    label: "AVG Stock Available in the last 7 days"
    hidden: yes
    group_label: "Variation Metrics"
    type: average
    sql:  ${replenishment_dc_agg_derived_table.total_stock_available};;
    filters: [stock_balance_date_date: "last 7 days"]
    value_format_name: decimal_1
  }


  measure: stock_available_last_7days_pre  {
    label: "Period before the last 7 days"
    hidden: yes
    group_label: "Variation Metrics"
    type: average
    sql:  ${replenishment_dc_agg_derived_table.total_stock_available};;
    filters: [stock_balance_date_date: "14 days ago for 7 days"]
    value_format_name: decimal_1
  }


  measure: delta_last_7days {
    label: "% Delta last 7 days over previous period"
    hidden: yes
    group_label: "Variation Metrics"
    type: number
    sql: (${stock_available_last_7days}/ nullif(${stock_available_last_7days_pre},0)) - 1 ;;
    value_format_name: percent_1
  }


  measure: stock_available_last_15days  {
    label: "AVG Stock Available in the last 15 days"
    hidden: yes
    group_label: "Variation Metrics"
    type: average
    sql:  ${replenishment_dc_agg_derived_table.total_stock_available};;
    filters: [stock_balance_date_date: "last 15 days"]
    value_format_name: decimal_1
  }


  measure: stock_available_last_15days_pre  {
    label: "Period before the last 15 days"
    hidden: yes
    group_label: "Variation Metrics"
    type: average
    sql:  ${replenishment_dc_agg_derived_table.total_stock_available};;
    filters: [stock_balance_date_date: "30 days ago for 15 days"]
    value_format_name: decimal_1
  }


  measure: delta_last_15days {
    label: "% Delta last 15 days over previous period"
    hidden: yes
    group_label: "Variation Metrics"
    type: number
    sql: (${stock_available_last_15days}/ nullif(${stock_available_last_15days_pre},0)) - 1 ;;
    value_format_name: percent_1
  }


  measure: stock_available_last_30days  {
    label: "AVG Stock Available in the last 30 days"
    hidden: yes
    group_label: "Variation Metrics"
    type: average
    sql:  ${replenishment_dc_agg_derived_table.total_stock_available};;
    filters: [stock_balance_date_date: "last 30 days"]
    value_format_name: decimal_1
  }


  measure: stock_available_last_30days_pre  {
    label: "Period before the last 30 days"
    hidden: yes
    group_label: "Variation Metrics"
    type: average
    sql:  ${replenishment_dc_agg_derived_table.total_stock_available};;
    filters: [stock_balance_date_date: "60 days ago for 30 days"]
    value_format_name: decimal_1
  }


  measure: delta_last_30days {
    label: "% Delta last 30 days over previous period"
    hidden: yes
    group_label: "Variation Metrics"
    type: number
    sql: (${stock_available_last_30days}/ nullif(${stock_available_last_30days_pre},0)) - 1 ;;
    value_format_name: percent_1
  }



}
