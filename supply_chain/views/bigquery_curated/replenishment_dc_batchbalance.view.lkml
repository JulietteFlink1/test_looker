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
    type: sum

    sql: ${available_stock} ;;
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


}
