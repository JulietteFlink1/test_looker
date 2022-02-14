view: inventory_hourly {
  sql_table_name: `flink-data-prod.curated.inventory_hourly`
    ;;


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========
  dimension_group: report_timestamp {

    label: "Inventory Report"
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
    sql: ${TABLE}.report_timestamp ;;
  }

  dimension: is_hub_open {

    label: "Is Hub Open"
    description: "A boolean to filter for only open hub hours"
    group_label: "OOS-Dimensions"

    type: yesno
    sql: ${TABLE}.is_hub_open ;;
  }

  dimension: share_of_hours_oos_unaggregated {

    label: "Number of Hours OOS"
    description: "An indicator, to show, whether a SKU was out-of-stock at a given hour, with oos (1) partially oos (0.5) or in stock (0)"
    group_label: "OOS-Dimensions"

    type: number
    sql: ${TABLE}.share_of_hours_oos ;;

    hidden: yes
  }

  dimension: share_of_hours_open_unaggregated {

    label: "Number of Hours Open"
    description: "An indicator, to show, whether a hour was open (1) partially open (0.5) or closed (0)"
    group_label: "OOS-Dimensions"

    type: number
    sql: ${TABLE}.share_of_hours_open ;;

    hidden: yes
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


  # =========  IDs   =========
  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
    hidden: yes
  }

  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
    primary_key: yes
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # ~~~~~~~~~~~~~  START: Out-Of-Stock Metrics  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: sum_of_hours_open_unaggregated {

    label: "# Opening Hours"
    description: "The number of hours, a hub was open (hours were customers could buy)"
    group_label: "OOS-Measures"

    type: sum
    sql: ${share_of_hours_open_unaggregated} ;;

    value_format_name: decimal_1

    hidden: yes
  }

  measure: sum_of_hours_oos_unaggregated {

    label: "# Hours Out-Of-Stock"
    description: "The number of business hours, a specific SKU was not available in a hub"
    group_label: "OOS-Measures"

    type: sum
    sql: ${share_of_hours_oos_unaggregated} ;;

    value_format_name: decimal_1

    hidden: yes

  }

  measure: pct_oos_unaggregated {

    label: "% Out Of Stock"
    description: "This rate gives the sum of all hours, an SKU was out of stock compared to all hours, the hub was open for orders"
    group_label: "OOS-Measures"

    type: number
    sql: ${sum_of_hours_oos_unaggregated} / nullif( ${sum_of_hours_open_unaggregated},0) ;;

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

    hidden: yes
  }

  measure: pct_in_stock_unaggregated {

    label: "% In Stock"
    description: "This rate gives the sum of all hours, an SKU was in stock compared to all hours, the hub was open for orders"
    group_label: "OOS-Measures"

    type: number
    sql: 1 - ${pct_oos_unaggregated} ;;

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

    hidden: yes
  }
  # ~~~~~~~~~~~~~    END: Out-Of-Stock Metrics  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




# ~~~~~~~~~~~~~  START: Inventory Change  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: avg_inventory_unaggregated {

    label: "AVG Inventory Level"
    description: "The average stock level, based on averaged starting and ending inventory level per day and hub"
    group_label: "Inventory Change"

    type: average
    sql: ( (${TABLE}.quantity_from + ${TABLE}.quantity_to) / 2  ) ;;

    value_format_name: decimal_1
    hidden: yes
  }


  measure: avg_quantity_from_unaggregated {

    label: "AVG Quantity From"
    description: "The average inventory quantity at the start of every hour"
    group_label: "Inventory Change"

    type: average
    sql: ${TABLE}.quantity_from ;;

    value_format_name: decimal_1

    hidden: yes
  }

  measure: avg_quantity_to_unaggregated {

    label: "AVG Quantity To"
    description: "The average inventory quantity at the end of every hour"
    group_label: "Inventory Change"

    type: average
    sql: ${TABLE}.quantity_to_unaggregated ;;

    value_format_name: decimal_1

    hidden: yes
  }

  measure: sum_of_total_correction_unaggregated {

    label: "# Corrections - Total"
    description: "The sum of all inventory corrections"
    group_label: "Inventory Change"

    type: sum
    sql: ${TABLE}.number_of_total_correction ;;

    value_format_name: decimal_0

    hidden: yes
  }

  measure: sum_of_total_inbound_unaggregated {

    label: "# Inbound - Total"
    description: "The sum of all inventory re-stockings"
    group_label: "Inventory Change"

    type: sum
    sql: ${TABLE}.number_of_total_inbound ;;

    value_format_name: decimal_0

    hidden: yes
  }

  measure: sum_of_total_outbound_unaggregated {

    label: "# Outbound - Total"
    description: "The sum of all inventory outbounds"
    group_label: "Inventory Change"

    type: sum
    sql: ${TABLE}.number_of_total_outbound ;;

    value_format_name: decimal_0

    hidden: yes
  }


  measure: sum_of_correction_product_damaged_unaggregated {

    label: "# Corrections - Product Damaged"
    description: "The sum of all inventory corrections due to damaged products"
    group_label: "Inventory Change"

    type: sum
    sql: ${TABLE}.number_of_correction_product_damaged ;;

    value_format_name: decimal_0

    hidden: yes
  }

  measure: sum_of_correction_product_expired_unaggregated {

    label: "# Corrections - Product Expired"
    description: "The sum of all inventory corrections due to expired products"
    group_label: "Inventory Change"

    type: sum
    sql: ${TABLE}.number_of_correction_product_expired ;;

    value_format_name: decimal_0

    hidden: yes
  }

  measure: sum_of_correction_stock_taking_increased_unaggregated {

    label: "# Corrections - Stock Taging (Increased)"
    description: "The sum of all inventory corrections due to stock taking activities, that increased the inventory level"
    group_label: "Inventory Change"

    type: sum
    sql: ${TABLE}.number_of_correction_stock_taking_increased ;;

    value_format_name: decimal_0

    hidden: yes
  }

  measure: sum_of_correction_stock_taking_reduced_unaggregated {

    label: "# Corrections - Stock Taging (Reduced)"
    description: "The sum of all inventory corrections due to stock taking activities, that reduced the inventory level"
    group_label: "Inventory Change"

    type: sum
    sql: ${TABLE}.number_of_correction_stock_taking_reduced ;;

    value_format_name: decimal_0

    hidden: yes
  }

  measure: sum_of_outbound_orders_unaggregated {

    label: "# Outbound - Orders"
    description: "The number of all inventory changes due to customer orders"
    group_label: "Inventory Change"

    type: sum
    sql: ${TABLE}.number_of_outbound_orders ;;

    value_format_name: decimal_0

    hidden: yes
  }

  measure: sum_of_outbound_others_unaggregated {

    # TODO: what do these entail?
    label: "# Outbound - Others"
    description: "The sum of outbounded items, that are NOT due to customer orders"
    group_label: "Inventory Change"

    type: sum
    sql: ${TABLE}.number_of_outbound_others ;;

    value_format_name: decimal_0

    hidden: yes
  }



  measure: sum_of_unspecified_unaggregated {

    label: "# Unspecified Inventory Changes"
    description: "The sum of all inventory changes, that are not mapped to specific reasons"
    group_label: "Inventory Change"

    type: sum
    sql: ${TABLE}.number_of_unspecified ;;

    value_format_name: decimal_0

    hidden: yes
  }

  # ~~~~~~~~~~~~~    END: Inventory Change  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~





}
