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

  parameter: show_oos_formatting {

    label:       "Enable conditional formatting for in-stock (oos) rate"
    group_label: "* Parameters & Dynamic Fields *"

    type: unquoted

    allowed_value: { value: "1" label: "Enable" }
    allowed_value: { value: "0" label: "Disable"}

    default_value: "0"


  }

  #Added this new filter provisory to check if it works

  parameter: in_stock_cutoff_hours {
    group_label: "* Parameters & Dynamic Fields *"
    label: "Select In Stock Cut Off Hours"
    type: unquoted
    allowed_value: { value: "1" label: "With Cut Off Hours" }
    allowed_value: { value: "0" label: "Without Cut Off Hours" }
    default_value: "1"
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
      month,
      day_of_week,
      day_of_week_index
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

  dimension: parent_sku {
    type: string
    sql: ${TABLE}.parent_sku ;;
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
  dimension: number_of_correction_product_damaged_unaggregated {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.number_of_correction_product_damaged ;;

    hidden: yes
  }

  dimension: number_of_correction_product_expired_unaggregated {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.number_of_correction_product_expired ;;

    hidden: yes
  }

  dimension: number_of_correction_stock_taking_increased_unaggregated {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.number_of_correction_stock_taking_increased ;;

    hidden: yes
  }

  dimension: number_of_correction_stock_taking_reduced_unaggregated {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.number_of_correction_stock_taking_reduced ;;

    hidden: yes
  }

  dimension: number_of_hours_oos_unaggregated {
    group_label: "OOS-Dimensions"
    type: number
    sql: ${TABLE}.number_of_hours_oos ;;

    hidden: yes
  }

  dimension: number_of_hours_open_unaggregated {
    group_label: "OOS-Dimensions"
    type: number
    sql: ${TABLE}.number_of_hours_open ;;

    hidden: yes
  }

  dimension: number_of_outbound_orders_unaggregated {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.number_of_outbound_orders ;;

    hidden: yes
  }

  dimension: number_of_outbound_others_unaggregated {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.number_of_outbound_others ;;

    hidden: yes
  }

  dimension: number_of_total_correction_unaggregated {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.number_of_total_correction ;;

    hidden: yes
  }

  dimension: number_of_total_inbound_unaggregated {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.number_of_total_inbound ;;

    hidden: yes
  }

  dimension: number_of_total_outbound_unaggregated {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.number_of_total_outbound ;;

    hidden: yes
  }

  dimension: number_of_unspecified_unaggregated {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.number_of_unspecified ;;

    hidden: yes
  }

  dimension: quantity_from_unaggregated {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.quantity_from ;;

    hidden: yes
  }

  dimension: quantity_to_unaggregated {
    group_label: "Inventory Change"
    type: number
    sql: ${TABLE}.quantity_to ;;

    hidden: yes
  }












  dimension: number_of_correction_product_damaged {
    group_label: "Inventory Change"
    type: number
    hidden: yes
    sql:

        {% if    products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_replenishment'
          or products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_customer'%}
        ${TABLE}.number_of_correction_product_damaged

        {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'replenishment' %}
        ${TABLE}.rsg_number_of_correction_product_damaged

        {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'customer' %}
        ${TABLE}.sg_number_of_correction_product_damaged

        {% endif %}
    ;;

    }

  dimension: number_of_correction_product_expired {
    group_label: "Inventory Change"
    type: number
    hidden: yes
    sql:

      {% if    products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_replenishment'
        or products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_customer' %}
      ${TABLE}.number_of_correction_product_expired


      {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'replenishment' %}
      ${TABLE}.rsg_number_of_correction_product_expired

      {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'customer' %}
      ${TABLE}.sg_number_of_correction_product_expired

      {% endif %}
  ;;

    }

  dimension: number_of_correction_stock_taking_increased {
    group_label: "Inventory Change"
    type: number
    hidden: yes
    sql:

    {% if    products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_replenishment'
      or products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_customer' %}
    ${TABLE}.number_of_correction_stock_taking_increased


    {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'replenishment' %}
    ${TABLE}.rsg_number_of_correction_stock_taking_increased

    {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'customer' %}
    ${TABLE}.sg_number_of_correction_stock_taking_increased

    {% endif %}
;;

    }

  dimension: number_of_correction_stock_taking_reduced {
    group_label: "Inventory Change"
    type: number
    hidden: yes
    sql:

            {% if    products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_replenishment'
              or products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_customer' %}
            ${TABLE}.number_of_correction_stock_taking_reduced


            {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'replenishment' %}
            ${TABLE}.rsg_number_of_correction_stock_taking_reduced

            {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'customer' %}
            ${TABLE}.sg_number_of_correction_stock_taking_reduced

            {% endif %}
        ;;

    }

  dimension: number_of_hours_oos {
    group_label: "OOS-Dimensions"
    type: number
    hidden: yes
    sql:

            {% if    products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_replenishment'
                      or products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_customer'
                     and in_stock_cutoff_hours._parameter_value == '0' %}
            ${TABLE}.number_of_hours_oos


            {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'replenishment'
                     and in_stock_cutoff_hours._parameter_value == '0' %}
            ${TABLE}.rsg_number_of_hours_oos

            {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'customer'
                     and in_stock_cutoff_hours._parameter_value == '0' %}
            ${TABLE}.sg_number_of_hours_oos

  --Added this as new logics to use this cutoff hours filter

            {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_replenishment'
                      or products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_customer'
                     and in_stock_cutoff_hours._parameter_value == '1' %}
            ${TABLE}.number_of_hours_oos_with_cutoff_hours


            {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'replenishment'
                     and in_stock_cutoff_hours._parameter_value == '1' %}
            ${TABLE}.rsg_number_of_hours_oos_with_cutoff_hours

            {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'customer'
                     and in_stock_cutoff_hours._parameter_value == '1' %}
            ${TABLE}.sg_number_of_hours_oos_with_cutoff_hours

            {% endif %}
        ;;

    }

  dimension: number_of_hours_open {
    group_label: "OOS-Dimensions"
    type: number
    hidden: yes
    sql:

            {% if    products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_replenishment'
                      or products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_customer'
                     and in_stock_cutoff_hours._parameter_value == '0' %}
            ${TABLE}.number_of_hours_open


            {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'replenishment'
                     and in_stock_cutoff_hours._parameter_value == '0'%}
            ${TABLE}.rsg_number_of_hours_open

            {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'customer'
                     and in_stock_cutoff_hours._parameter_value == '0'%}
            ${TABLE}.sg_number_of_hours_open

  --Added this as new logics to use this cutoff hours filter

            {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_replenishment'
                      or products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_customer'
                     and in_stock_cutoff_hours._parameter_value == '1' %}
            ${TABLE}.number_of_hours_open_with_cutoff_hours


            {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'replenishment'
                     and in_stock_cutoff_hours._parameter_value == '1'%}
            ${TABLE}.rsg_number_of_hours_open_with_cutoff_hours

            {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'customer'
                     and in_stock_cutoff_hours._parameter_value == '1'%}
            ${TABLE}.sg_number_of_hours_open_with_cutoff_hours

            {% endif %}
        ;;

  }

  dimension: availability_distribution {

    label:       "Availability"
    group_label: "OOS-Dimensions"

    type: number
    hidden: yes
    sql: 1 - (${number_of_hours_oos} / nullif(${number_of_hours_open},0) )  ;;

    value_format_name: percent_0


  }


  dimension: number_of_outbound_orders {
    group_label: "Inventory Change"
    type: number
    hidden: yes
    sql:

            {% if    products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_replenishment'
                  or products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_customer' %}
            ${TABLE}.number_of_outbound_orders

            {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'replenishment' %}
            ${TABLE}.rsg_number_of_outbound_orders

            {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'customer' %}
            ${TABLE}.sg_number_of_outbound_orders

            {% endif %}
        ;;

    }

  dimension: number_of_outbound_others {
    group_label: "Inventory Change"
    type: number
    hidden: yes
    sql:

            {% if    products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_replenishment'
              or products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_customer'%}
            ${TABLE}.number_of_outbound_others


            {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'replenishment' %}
            ${TABLE}.rsg_number_of_outbound_others

            {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'customer' %}
            ${TABLE}.sg_number_of_outbound_others

            {% endif %}
        ;;

    }

  dimension: number_of_total_correction {
    group_label: "Inventory Change"
    type: number
    hidden: yes
    sql:

            {% if    products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_replenishment'
              or products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_customer' %}
            ${TABLE}.number_of_total_correction


            {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'replenishment' %}
            ${TABLE}.rsg_number_of_total_correction

            {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'customer' %}
            ${TABLE}.sg_number_of_total_correction

            {% endif %}
        ;;

    }

  dimension: number_of_total_inbound {
    group_label: "Inventory Change"
    type: number
    hidden: yes
    sql:

            {% if    products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_replenishment'
              or products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_customer' %}
            ${TABLE}.number_of_total_inbound

            {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'replenishment' %}
            ${TABLE}.rsg_number_of_total_inbound

            {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'customer' %}
            ${TABLE}.sg_number_of_total_inbound

            {% endif %}
        ;;

    }

  dimension: number_of_total_outbound {
    group_label: "Inventory Change"
    type: number
    hidden: yes
    sql:

            {% if    products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_replenishment'
                  or products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_customer' %}
            ${TABLE}.number_of_total_outbound


            {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'replenishment' %}
            ${TABLE}.rsg_number_of_total_outbound

            {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'customer' %}
            ${TABLE}.sg_number_of_total_outbound

            {% endif %}
        ;;

    }

  dimension: number_of_unspecified {
    group_label: "Inventory Change"
    type: number
    hidden: yes
    sql:
            {% if    products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_replenishment'
              or products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_customer' %}
            ${TABLE}.number_of_unspecified

            {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'replenishment' %}
            ${TABLE}.rsg_number_of_unspecified

            {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'customer' %}
            ${TABLE}.sg_number_of_unspecified

            {% endif %}
        ;;

    }

  dimension: quantity_from {
    group_label: "Inventory Change"
    type: number
    hidden: yes
    sql:

            {% if    products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_replenishment'
              or products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_customer' %}
            ${TABLE}.quantity_from

            {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'replenishment' %}
            ${TABLE}.rsg_quantity_from

            {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'customer' %}
            ${TABLE}.sg_quantity_from

            {% endif %}
        ;;

    }

  dimension: quantity_to {
    group_label: "Inventory Change"
    type: number
    hidden: yes
    sql:

            {% if    products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_replenishment'
              or products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_customer' %}
            ${TABLE}.quantity_to

            {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'replenishment' %}
            ${TABLE}.rsg_quantity_to

            {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'customer' %}
            ${TABLE}.sg_quantity_to

            {% endif %}
        ;;

    }


  dimension: number_of_correction_product_delivery_damaged {
    group_label: "Inventory Change"
    type: number
    hidden: yes
    sql:

            {% if    products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_replenishment'
              or products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_customer' %}
            ${TABLE}.number_of_correction_product_delivery_damaged

      {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'replenishment' %}
      ${TABLE}.rsg_number_of_correction_product_delivery_damaged

      {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'customer' %}
      ${TABLE}.sg_number_of_correction_product_delivery_damaged

      {% endif %}
      ;;

  }

  dimension: number_of_correction_product_delivery_expired {
    group_label: "Inventory Change"
    type: number
    hidden: yes
    sql:

            {% if    products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_replenishment'
              or products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_customer' %}
            ${TABLE}.number_of_correction_product_delivery_expired

      {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'replenishment' %}
      ${TABLE}.rsg_number_of_correction_product_delivery_expired

      {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'customer' %}
      ${TABLE}.sg_number_of_correction_product_delivery_expired

      {% endif %}
      ;;

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

    {% if show_oos_formatting._parameter_value == '1' %}

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

      {% endif %}

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

    {% if show_oos_formatting._parameter_value == '1' %}

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

      {% endif %}

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

  measure: unique_inbounded_skus {

    label:       "# Unique Inbounded SKUs"
    description: "The number of unique products /SKUs, that have been inbounded"
    group_label: "Inventory Change"

    type: count_distinct
    sql: ${sku} ;;
    filters: [number_of_total_inbound: ">0"]

    value_format_name: decimal_0
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

  measure: sum_of_correction_product_delivery_damaged {

    label: "# Corrections - Product Delivery Damaged"
    description: "The sum of all inventory corrections due to damaged products at the point of inbounding"
    group_label: "Inventory Change"

    type: sum
    sql: ${number_of_correction_product_delivery_damaged} ;;

    value_format_name: decimal_0
  }

  measure: sum_of_correction_product_delivery_expired {

    label: "# Corrections - Product Delivery Expired"
    description: "The sum of all inventory corrections due to expired products at the point of inbounding"
    group_label: "Inventory Change"

    type: sum
    sql: ${number_of_correction_product_delivery_expired} ;;

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

#####################################################################################
#####################################################################################
######################### Demand Planning ###########################################
#####################################################################################
#####################################################################################

################ Hours Open t-

  measure: sum_of_hours_open_t_1 {

    label: "# Opening Hours t-1"
    description: "The number of hours, a hub was open (hours were customers could buy) t-1"
    group_label: "Demand Planning"

    type: sum
    sql: ${number_of_hours_open} ;;
    filters: [report_date: "yesterday"]
    value_format_name: decimal_1
    hidden: yes
  }

  measure: sum_of_hours_open_t_2 {

    label: "# Opening Hours t-2"
    description: "The number of hours, a hub was open (hours were customers could buy) t-2"
    group_label: "Demand Planning"

    type: sum
    sql: ${number_of_hours_open} ;;
    filters: [report_date: "2 days ago"]

    value_format_name: decimal_1
    hidden: yes
  }

  measure: sum_of_hours_open_t_3 {

    label: "# Opening Hours t-3"
    description: "The number of hours, a hub was open (hours were customers could buy) t-3"
    group_label: "Demand Planning"

    type: sum
    sql: ${number_of_hours_open} ;;
    filters: [report_date: "3 days ago"]

    value_format_name: decimal_1
    hidden: yes
  }

  measure: sum_of_hours_open_t_4 {

    label: "# Opening Hours t-4"
    description: "The number of hours, a hub was open (hours were customers could buy) t-4"
    group_label: "Demand Planning"

    type: sum
    sql: ${number_of_hours_open} ;;
    filters: [report_date: "4 days ago"]

    value_format_name: decimal_1
    hidden: yes
  }

  ################## Hours Open t-

  measure: sum_of_hours_oos_t_1 {

    label: "# Hours Out-Of-Stock t-1"
    description: "The number of business hours, a specific SKU was not available in a hub t-1"
    group_label: "Demand Planning"

    type: sum
    sql: ${number_of_hours_oos} ;;
    filters: [report_date: "yesterday"]
    value_format_name: decimal_1
    hidden: yes

  }

  measure: sum_of_hours_oos_t_2 {

    label: "# Hours Out-Of-Stock t-2"
    description: "The number of business hours, a specific SKU was not available in a hub t-2"
    group_label: "Demand Planning"

    type: sum
    sql: ${number_of_hours_oos} ;;
    filters: [report_date: "2 days ago"]

    value_format_name: decimal_1
    hidden: yes

  }

  measure: sum_of_hours_oos_t_3 {

    label: "# Hours Out-Of-Stock t-3"
    description: "The number of business hours, a specific SKU was not available in a hub t-3"
    group_label: "Demand Planning"

    type: sum
    sql: ${number_of_hours_oos} ;;
    filters: [report_date: "3 days ago"]

    value_format_name: decimal_1
    hidden: yes

  }

  measure: sum_of_hours_oos_t_4 {

    label: "# Hours Out-Of-Stock t-4"
    description: "The number of business hours, a specific SKU was not available in a hub t-4"
    group_label: "Demand Planning"

    type: sum
    sql: ${number_of_hours_oos} ;;
    filters: [report_date: "4 days ago"]

    value_format_name: decimal_1
    hidden: yes
  }

  measure: pct_in_stock_t_1 {

    label: "% In Stock t-1"
    description: "This rate gives the sum of all hours, an SKU was out of stock compared to all hours, the hub was open for orders t-1"
    group_label: "Demand Planning"

    type: number
    sql: 1 - (${sum_of_hours_oos_t_1} / nullif( ${sum_of_hours_open_t_1},0)) ;;
    value_format_name: percent_1
    hidden: yes
  }

  measure: pct_in_stock_t_2 {

    label: "% In Stock t-2"
    description: "This rate gives the sum of all hours, an SKU was out of stock compared to all hours, the hub was open for orders t-2"
    group_label: "Demand Planning"

    type: number
    sql: 1 - (${sum_of_hours_oos_t_2} / nullif( ${sum_of_hours_open_t_2},0)) ;;
    value_format_name: percent_1
    hidden: yes
  }

  measure: pct_in_stock_t_3 {

    label: "% In Stock t-3"
    description: "This rate gives the sum of all hours, an SKU was out of stock compared to all hours, the hub was open for orders t-3"
    group_label: "Demand Planning"

    type: number
    sql: 1 - (${sum_of_hours_oos_t_3} / nullif( ${sum_of_hours_open_t_3},0)) ;;
    value_format_name: percent_1
    hidden: yes
  }

  measure: pct_in_stock_t_4 {

    label: "% In Stock t-4"
    description: "This rate gives the sum of all hours, an SKU was out of stock compared to all hours, the hub was open for orders t-4"
    group_label: "Demand Planning"

    type: number
    sql: 1 - (${sum_of_hours_oos_t_4} / nullif( ${sum_of_hours_open_t_4},0)) ;;
    value_format_name: percent_1
    hidden: yes
  }


  ########################## Weekly

################## Hours Open w-

  measure: sum_of_hours_open_w_1 {

    label: "# Opening Hours w-1"
    description: "The number of hours, a hub was open (hours were customers could buy) w-1"
    group_label: "Demand Planning"

    type: sum
    sql: ${number_of_hours_open} ;;
    filters: [report_date: "1 week ago"]
    value_format_name: decimal_1
    hidden: yes
  }

  measure: sum_of_hours_open_w_2 {

    label: "# Opening Hours w-2"
    description: "The number of hours, a hub was open (hours were customers could buy) w-2"
    group_label: "Demand Planning"

    type: sum
    sql: ${number_of_hours_open} ;;
    filters: [report_date: "2 weeks ago"]

    value_format_name: decimal_1
    hidden: yes
  }

  measure: sum_of_hours_open_w_3 {

    label: "# Opening Hours w-3"
    description: "The number of hours, a hub was open (hours were customers could buy) w-3"
    group_label: "Demand Planning"

    type: sum
    sql: ${number_of_hours_open} ;;
    filters: [report_date: "3 weeks ago"]

    value_format_name: decimal_1
    hidden: yes
  }

  measure: sum_of_hours_open_w_4 {

    label: "# Opening Hours w-4"
    description: "The number of hours, a hub was open (hours were customers could buy) w-4"
    group_label: "Demand Planning"

    type: sum
    sql: ${number_of_hours_open} ;;
    filters: [report_date: "4 weeks ago"]

    value_format_name: decimal_1
    hidden: yes
  }

  ##################Hours Open w-

  measure: sum_of_hours_oos_w_1 {

    label: "# Hours Out-Of-Stock w-1"
    description: "The number of business hours, a specific SKU was not available in a hub w-1"
    group_label: "Demand Planning"

    type: sum
    sql: ${number_of_hours_oos} ;;
    filters: [report_date: "1 week ago"]
    value_format_name: decimal_1
    hidden: yes

  }

  measure: sum_of_hours_oos_w_2 {

    label: "# Hours Out-Of-Stock w-2"
    description: "The number of business hours, a specific SKU was not available in a hub w-2"
    group_label: "Demand Planning"

    type: sum
    sql: ${number_of_hours_oos} ;;
    filters: [report_date: "2 weeks ago"]

    value_format_name: decimal_1
    hidden: yes

  }

  measure: sum_of_hours_oos_w_3 {

    label: "# Hours Out-Of-Stock w-3"
    description: "The number of business hours, a specific SKU was not available in a hub w-3"
    group_label: "Demand Planning"

    type: sum
    sql: ${number_of_hours_oos} ;;
    filters: [report_date: "3 weeks ago"]

    value_format_name: decimal_1
    hidden: yes

  }

  measure: sum_of_hours_oos_w_4 {

    label: "# Hours Out-Of-Stock w-4"
    description: "The number of business hours, a specific SKU was not available in a hub w-4"
    group_label: "Demand Planning"

    type: sum
    sql: ${number_of_hours_oos} ;;
    filters: [report_date: "4 weeks ago"]

    value_format_name: decimal_1
    hidden: yes
  }

  ################## In stock w-

  measure: pct_in_stock_w_1 {

    label: "% In Stock w-1"
    description: "This rate gives the sum of all hours, an SKU was out of stock compared to all hours, the hub was open for orders w-1"
    group_label: "Demand Planning"

    type: number
    sql: 1 - (${sum_of_hours_oos_w_1} / nullif( ${sum_of_hours_open_w_1},0)) ;;
    value_format_name: percent_1
    hidden: yes
  }

  measure: pct_in_stock_w_2 {

    label: "% In Stock w-2"
    description: "This rate gives the sum of all hours, an SKU was out of stock compared to all hours, the hub was open for orders w-2"
    group_label: "Demand Planning"

    type: number
    sql: 1 - (${sum_of_hours_oos_w_2} / nullif( ${sum_of_hours_open_w_2},0)) ;;
    value_format_name: percent_1
    hidden: yes
  }

  measure: pct_in_stock_w_3 {

    label: "% In Stock w-3"
    description: "This rate gives the sum of all hours, an SKU was out of stock compared to all hours, the hub was open for orders w-3"
    group_label: "Demand Planning"

    type: number
    sql: 1 - (${sum_of_hours_oos_w_3} / nullif( ${sum_of_hours_open_w_3},0)) ;;
    value_format_name: percent_1
    hidden: yes
  }

  measure: pct_in_stock_w_4 {

    label: "% In Stock w-4"
    description: "This rate gives the sum of all hours, an SKU was out of stock compared to all hours, the hub was open for orders w-4"
    group_label: "Demand Planning"

    type: number
    sql: 1 - (${sum_of_hours_oos_w_4} / nullif( ${sum_of_hours_open_w_4},0)) ;;
    value_format_name: percent_1
    hidden: yes
  }

  measure: pct_in_stock_wow_w_1_vs_w_2 {
    label: "% In Stock WOW Growth (w-1 vs w-2) "
    group_label: "Demand Planning"

    type: number
    sql: (${pct_in_stock_w_1} - ${pct_in_stock_w_2})/nullif(${pct_in_stock_w_2},0)  ;;
    value_format_name: percent_1
    hidden: yes
  }




  #This is needed to calculate week to date
  dimension_group: current_date_t_1 {
    label: "Current Date - 1"
    type: time
    timeframes: [
      date,
      week,
      month,
      day_of_week_index,
      day_of_week
    ]
    convert_tz: no
    datatype: date
    sql: date_sub(current_date(), interval 1 day) ;;
    hidden: yes
  }

  dimension: until_today {
    type: yesno
    sql: ${report_day_of_week_index} <= ${current_date_t_1_day_of_week_index} AND
      ${report_day_of_week_index} >= 0 ;;
    hidden: yes
  }



################## w2t

  measure: sum_of_hours_open_wtd {

    label: "# Opening Hours WtD"
    description: "The number of hours, a hub was open (hours were customers could buy) WtD"
    group_label: "Demand Planning"

    type: sum
    sql: ${number_of_hours_open} ;;
    filters: [report_date: "this week"]
    value_format_name: decimal_1
    hidden: yes
  }

  measure: sum_of_hours_open_wtd_w_1 {

    label: "# Opening Hours WtD w-1"
    description: "The number of hours, a hub was open (hours were customers could buy) - Previous week WtD"
    group_label: "Demand Planning"

    type: sum
    sql: ${number_of_hours_open} ;;
    filters: [report_date: "1 week ago", until_today: "yes"]

    value_format_name: decimal_1
    hidden: yes
  }

  measure: sum_of_hours_oos_wtd {

    label: "# Hours Out-Of-Stock WtD"
    description: "The number of business hours, a specific SKU was not available in a hub - WtD"
    group_label: "Demand Planning"

    type: sum
    sql: ${number_of_hours_oos} ;;
    filters: [report_date: "this week"]
    value_format_name: decimal_1
    hidden: yes

  }

  measure: sum_of_hours_oos_wtd_w_1 {

    label: "# Hours Out-Of-Stock WtD w-1"
    description: "The number of business hours, a specific SKU was not available in a hub - Previous week WtD"
    group_label: "Demand Planning"

    type: sum
    sql: ${number_of_hours_oos} ;;
    filters: [report_date: "1 week ago", until_today: "yes"]

    value_format_name: decimal_1
    hidden: yes

  }


  measure: pct_in_stock_wtd {

    label: "% In Stock WtD"
    description: "This rate gives the sum of all hours, an SKU was out of stock compared to all hours, the hub was open for orders - WtD"
    group_label: "Demand Planning"

    type: number
    sql: 1 - (${sum_of_hours_oos_wtd} / nullif( ${sum_of_hours_open_wtd},0)) ;;
    value_format_name: percent_1
    hidden: yes
  }

  measure: pct_in_stock_wtd_w_1 {

    label: "% In Stock WtD w-1"
    description: "This rate gives the sum of all hours, an SKU was out of stock compared to all hours, the hub was open for orders - Previous week WtD"
    group_label: "Demand Planning"

    type: number
    sql: 1 - (${sum_of_hours_oos_wtd_w_1} / nullif( ${sum_of_hours_open_wtd_w_1},0)) ;;
    value_format_name: percent_1
    hidden: yes
  }


  measure: pct_in_stock_wow_wtd {
    label: "% In Stock WOW Growth - WtD"
    group_label: "Demand Planning"

    type: number
    sql: (${pct_in_stock_wtd} - ${pct_in_stock_wtd_w_1})/nullif(${pct_in_stock_wtd_w_1}, 0)  ;;
    value_format_name: percent_1
    hidden: yes
  }


#Current stock available

  measure: quantity_to_t_1 {

    label: "Quantity To - t-1"
    description: "The stock level t-1, at the end of the day per day and hub"
    group_label: "Demand Planning"
    type: sum
    sql:  ${inventory_daily.quantity_to} ;;
    filters: [report_date: "yesterday"]
    hidden: yes

    value_format_name: decimal_1
  }

  measure: quantity_to_t_2 {

    label: "Quantity To - t-2"
    description: "The stock level t-2, at the end of the day per day and hub"
    group_label: "Demand Planning"
    type: sum
    sql:  ${inventory_daily.quantity_to} ;;
    filters: [report_date: "2 days ago"]
    hidden: yes

    value_format_name: decimal_1
  }


  measure: quantity_to_adjusted {

    label: "# Current Stock"
    description: "The stock level t-1, at the end of the day per day and hub"
    group_label: "Demand Planning"
    type: number
    sql:  coalesce(${quantity_to_t_1}, ${quantity_to_t_2}) ;;
    hidden: no


    value_format_name: decimal_1
  }


  measure: days_coverage {

    label: "Days Coverage"
    description: "The stock level t-1, at the end of the day per day and hub"
    group_label: "Demand Planning"
    type: number
    sql:  (${quantity_to_adjusted} + ${replenishment_purchase_orders.sum_selling_unit_quantity_next_7_days}) / nullif(${orderline.avg_daily_item_quantity_last_14d}, 0) ;;
    hidden: no


    value_format_name: decimal_2
  }




}
