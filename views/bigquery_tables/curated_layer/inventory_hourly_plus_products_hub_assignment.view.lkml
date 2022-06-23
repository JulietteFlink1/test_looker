include: "/**/inventory_hourly.view"

view: +inventory_hourly {

  # This refined view adds the metrics of inventory-hourly, but makes them being aggregated on either
  # - Replenishment Substitute Group (RSG) or
  # - Substitute Group from CT (SG)

  # based on the seletion in the parameter
  #    >> products_hub_assignment.select_calculation_granularity <<


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~       Sets.         ~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # see products_hub_assignment.view >> parameter: select_calculation_granularity

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  dimension: share_of_hours_oos {

    label: "Number of Hours OOS"
    description: "An indicator, to show, whether a SKU was out-of-stock at a given hour, with oos (1) partially oos (0.5) or in stock (0)"
    group_label: "OOS-Dimensions"

    type: number

    sql:
         {% if    products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_replenishment'
               or products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_customer'%}
               ${TABLE}.share_of_hours_oos

         {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'replenishment' %}
               ${TABLE}.rsg_share_of_hours_oos

         {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'customer' %}
              ${TABLE}.sg_share_of_hours_oos

         {% endif %}
    ;;
  }

  dimension: share_of_hours_open {

    label: "Number of Hours Open"
    description: "An indicator, to show, whether a hour was open (1) partially open (0.5) or closed (0)"
    group_label: "OOS-Dimensions"

    type: number

    sql:
        {% if    products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_replenishment'
          or products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_customer' %}
          ${TABLE}.share_of_hours_open

        {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'replenishment' %}
          ${TABLE}.rsg_share_of_hours_open

        {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'customer' %}
          ${TABLE}.sg_share_of_hours_open

        {% endif %}
    ;;

  }


  dimension: quantity_from {

    label: "AVG Quantity From"
    description: "The average inventory quantity at the start of every hour"
    group_label: "Inventory Change"

    type: number
    sql:
        {% if    products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_replenishment'
              or products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_customer'%}
        ${TABLE}.quantity_from

        {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'replenishment' %}
        ${TABLE}.rsg_quantity_from

        {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'customer' %}
        ${TABLE}.sg_quantity_from

        {% endif %}
    ;;


    value_format_name: decimal_1

    hidden: yes
  }

  dimension: quantity_to {

    label: "AVG Quantity To"
    description: "The average inventory quantity at the end of every hour"
    group_label: "Inventory Change"

    type: number
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


    value_format_name: decimal_1

    hidden: yes
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
    sql: ${share_of_hours_open} ;;

    value_format_name: decimal_1
  }

  measure: sum_of_hours_oos {

    label: "# Hours Out-Of-Stock"
    description: "The number of business hours, a specific SKU was not available in a hub"
    group_label: "OOS-Measures"

    type: sum
    sql: ${share_of_hours_oos} ;;

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


  measure: avg_quantity_from {

    label: "AVG Quantity From"
    description: "The average inventory quantity at the start of every hour"
    group_label: "Inventory Change"

    type: average
    sql: ${quantity_from} ;;

    value_format_name: decimal_1
  }

  measure: avg_quantity_to {

    label: "AVG Quantity To"
    description: "The average inventory quantity at the end of every hour"
    group_label: "Inventory Change"

    type: average
    sql: ${quantity_to} ;;

    value_format_name: decimal_1
  }

  measure: sum_of_total_correction {

    label: "# Corrections - Total"
    description: "The sum of all inventory corrections"
    group_label: "Inventory Change"

    type: sum
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


    value_format_name: decimal_0
  }

  measure: sum_of_total_inbound {

    label: "# Inbound - Total"
    description: "The sum of all inventory re-stockings"
    group_label: "Inventory Change"

    type: sum
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


    value_format_name: decimal_0
  }

  measure: sum_of_total_outbound {

    label: "# Outbound - Total"
    description: "The sum of all inventory outbounds"
    group_label: "Inventory Change"

    type: sum
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


    value_format_name: decimal_0
  }


  measure: sum_of_correction_product_damaged {

    label: "# Corrections - Product Damaged"
    description: "The sum of all inventory corrections due to damaged products"
    group_label: "Inventory Change"

    type: sum
    sql:

        {% if    products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_replenishment'
          or products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_customer' %}
        ${TABLE}.number_of_correction_product_damaged

        {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'replenishment' %}
        ${TABLE}.rsg_number_of_correction_product_damaged

        {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'customer' %}
        ${TABLE}.sg_number_of_correction_product_damaged

        {% endif %}
    ;;


    value_format_name: decimal_0
  }

  measure: sum_of_correction_product_expired {

    label: "# Corrections - Product Expired"
    description: "The sum of all inventory corrections due to expired products"
    group_label: "Inventory Change"

    type: sum
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


    value_format_name: decimal_0
  }

  measure: sum_of_correction_stock_taking_increased {

    label: "# Corrections - Stock Taging (Increased)"
    description: "The sum of all inventory corrections due to stock taking activities, that increased the inventory level"
    group_label: "Inventory Change"

    type: sum
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


    value_format_name: decimal_0
  }

  measure: sum_of_correction_stock_taking_reduced {

    label: "# Corrections - Stock Taging (Reduced)"
    description: "The sum of all inventory corrections due to stock taking activities, that reduced the inventory level"
    group_label: "Inventory Change"

    type: sum
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


    value_format_name: decimal_0
  }

  measure: sum_of_outbound_orders {

    label: "# Outbound - Orders"
    description: "The number of all inventory changes due to customer orders"
    group_label: "Inventory Change"

    type: sum
    sql:

        {% if    products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_replenishment'
          or products_hub_assignment.select_calculation_granularity._parameter_value == 'sku_customer'%}
        ${TABLE}.number_of_outbound_orders

        {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'replenishment' %}
        ${TABLE}.rsg_number_of_outbound_orders

        {% elsif products_hub_assignment.select_calculation_granularity._parameter_value == 'customer' %}
        ${TABLE}.sg_number_of_outbound_orders

        {% endif %}
    ;;


    value_format_name: decimal_0
  }

  measure: sum_of_outbound_others {

    # TODO: what do these entail?
    label: "# Outbound - Others"
    description: "The sum of outbounded items, that are NOT due to customer orders"
    group_label: "Inventory Change"

    type: sum
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


    value_format_name: decimal_0
  }



  measure: sum_of_unspecified {

    label: "# Unspecified Inventory Changes"
    description: "The sum of all inventory changes, that are not mapped to specific reasons"
    group_label: "Inventory Change"

    type: sum
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


    value_format_name: decimal_0
  }

  # ~~~~~~~~~~~~~    END: Inventory Change  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

}
