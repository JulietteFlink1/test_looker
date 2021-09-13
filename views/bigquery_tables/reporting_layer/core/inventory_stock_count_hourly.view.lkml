view: inventory_stock_count_hourly {
  sql_table_name: `flink-data-prod.reporting.inventory_stock_count_hourly`
    ;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========
  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: is_relevant_update{
    type: yesno
    sql: case when ${current_quantity} = 0 or ${current_quantity} != ${previous_quantity} THEN TRUE ELSE FALSE END ;;
  }

  dimension: stock_level_update_type {
    type: string
    sql:
        CASE WHEN ${current_quantity} = 0  THEN 'Out Of Stock'
             WHEN ${current_quantity} > ${previous_quantity} THEN 'Re-Stocking'
             WHEN ${current_quantity} < ${previous_quantity} THEN 'Orders & Book-Outs'
             WHEN ${current_quantity} = ${previous_quantity} THEN 'No Stock Level Change'
             ELSE 'undefined'
        END
    ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: hub_opening_hours_day {
    type: number
    sql: ${TABLE}.hub_opening_hours_day ;;
  }

  dimension: is_hup_opening_timestamp {
    label: "Is Hub-Opening Time"
    type: yesno
    sql: CASE WHEN ${TABLE}.is_hup_opening_timestamp = 1 THEN TRUE
              WHEN ${TABLE}.is_hup_opening_timestamp = 0 THEN FALSE
         END
    ;;
  }

  dimension: is_leading_product {
    type: string
    sql: ${TABLE}.is_leading_product ;;
  }

  dimension: is_noos_product {
    type: string
    sql: ${TABLE}.is_noos_product ;;
  }

  dimension_group: partition_timestamp {
    label: "Stock Level"
    type: time
    datatype: timestamp
    timeframes: [
      raw,
      time,
      minute,
      hour,
      hour_of_day,
      day_of_week,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.partition_timestamp ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }


  # =========  hidden   =========
  dimension: country {
    type: string
    case: {
      when: {
        sql: UPPER(${TABLE}.country_iso) = "DE" ;;
        label: "Germany"
      }
      when: {
        sql: UPPER(${TABLE}.country_iso) = "FR" ;;
        label: "France"
      }
      when: {
        sql: UPPER(${TABLE}.country_iso) = "NL" ;;
        label: "Netherlands"
      }
      else: "Other / Unknown"
    }
    hidden: yes
  }


  dimension: current_quantity {
    hidden: yes
    type: number
    sql: ${TABLE}.current_quantity ;;
  }

  dimension: previous_quantity {
    label: "# Quantity On Stock - Previous Hour"
    description: "Sum of Available items in stock"
    type: number
    hidden: yes
    sql: ${TABLE}.previous_quantity ;;
  }


  # =========  IDs   =========

  # dimension: unique_id {
  #   type: string
  #   primary_key:  yes
  #   hidden: yes
  #   sql: CONCAT(${TABLE}.country_iso,${TABLE}.hub_code,${TABLE}.sku ,CAST(${TABLE}.partition_timestamp AS STRING) ) ;;
  # }
  dimension: stock_inventory_uuid {
    type: string
    sql: ${TABLE}.stock_inventory_uuid ;;
    hidden: yes
    primary_key: yes
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




  measure: avg_previous_quantity {
    label: "# Quantity On Stock - Previous Hour"
    description: "Sum of Available items in stock"
    type: average
    sql: ${TABLE}.previous_quantity ;;
  }


  measure: sum_current_quantity {
    label: "# Quantity On Stock"
    description: "Sum of Available items in stock"
    hidden:  no
    type: sum
    sql: ${TABLE}.current_quantity;;
  }

  measure: avg_current_quantity {
    label: "AVG Quantity On Stock"
    description: "Sum of Available items in stock"
    hidden:  no
    type: average
    sql: ${TABLE}.current_quantity;;
  }

  measure: num_distinct_sku {
    label: "# SKUs"
    description: "Number of distinct SKUs in stock"
    type: count_distinct
    sql:  CASE WHEN ${TABLE}.current_quantity > 0 THEN ${sku} END ;;
  }


  measure: avg_quantity_restocked {
    label: "AVG Quantity Re-Stocked"
    description: "Sum of Available items in stock"
    hidden:  no
    type: average
    sql: ${TABLE}.current_quantity;;
    filters: [stock_level_update_type: "Re-Stocking"]
  }

  measure: avg_quantity_sold_booked_out {
    label: "AVG Quantity Sold or Booked Out"
    description: "Sum of Available items in stock"
    hidden:  no
    type: average
    sql: ${TABLE}.current_quantity;;
    filters: [stock_level_update_type: "Orders & Book-Outs"]
  }




  parameter: select_metric_param {
    group_label: "* Parameters & Dynamic Fields *"
    label: "Select Metric Shown"
    type: unquoted
    allowed_value: { value: "avg_quantity" label: "AVG Quantity On Stock"}
    allowed_value: { value: "re_stocked" label: "AVG Quantity Re-Stocked" }
    allowed_value: { value: "ordered_booked_out" label: "AVG Quantity Sold or Booked Out"}
    default_value: "avg_quantity"
  }

  measure: select_metric_measure {
    group_label: "* Parameters & Dynamic Fields *"
    label: "Measure (Dynamic)"
    label_from_parameter: select_metric_param
    type: number

    sql:
    {% if select_metric_param._parameter_value == 'avg_quantity' %}
      ${avg_current_quantity}
    {% elsif select_metric_param._parameter_value == 're_stocked' %}
      ${avg_quantity_restocked}
    {% elsif select_metric_param._parameter_value == 'ordered_booked_out' %}
      ${avg_quantity_sold_booked_out}
    {% endif %};;
  }
}
