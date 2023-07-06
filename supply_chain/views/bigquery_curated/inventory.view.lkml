view: inventory {
  view_label: "* Inventory Data *"
  sql_table_name: `flink-data-prod.curated.inventory_ct_current_status`
    ;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========
  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: is_most_recent_record {
    description: "Indicates, that the inventory shown is either the most recent data (Yes) or shows historical inventory information (No)"
    type: yesno
    sql: True ;;
    hidden: yes
  }

  dimension: is_oos {
    label: "Is Out-Of-Stock"
    group_label: "> Product Attributes"
    type: yesno
    sql: ${TABLE}.is_oos ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
    group_label: "> Geographic Data"
  }

  dimension_group: last_modified {
    type: time
    timeframes: [
      raw,
      time,
      time_of_day,
      minute,
      hour,
      day_of_week,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.last_modified_at ;;
    label: "Inventory Update"
    group_label: "> Dates & Timestamps"
    hidden: yes
  }

  dimension: shelf_number {
    type: string
    sql: ${TABLE}.shelf_number ;;
    group_label: "> Product Attributes"
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: quantity {
    label: "Stock quantity"
    type: number
    sql: ${TABLE}.quantity_available ;;
    hidden: yes
  }


  # =========  hidden   =========
  dimension: flag_out_of_stock {
    label: "Out of Stock Flag"
    description: "Takes the value of 1 if the sku is out of stock"
    hidden: yes
    type: number
    sql: case when ${is_oos} then 1 else 0 end ;;
  }

  dimension: flag_less_than_five_units_in_stock {
    label: "Less Than Five Units In Stock Flag"
    description: "Takes the value of 1 if the sku has less than 5 units in stock"
    hidden: yes
    type: number
    sql: case when ${quantity} <= 5 then 1 else 0 end ;;
  }

  # =========  IDs   =========
  dimension: inventory_uuid {
    sql: ${TABLE}.inventory_uuid ;;
    primary_key: yes
    group_label: "> IDs"
  }

  dimension: hub_id {
    type: string
    sql: ${TABLE}.hub_id ;;
    group_label: "> IDs"
  }

  dimension: inventory_id {
    type: string
    sql: ${TABLE}.inventory_id ;;
    group_label: "> IDs"
  }

  # =========  Admin Data   =========
  dimension_group: created {
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
    sql: ${TABLE}.created_at ;;
    group_label: "> Dates & Timestamps"
    hidden: yes
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: avg_quantity_available {
    type: average
    sql: ${TABLE}.quantity_available ;;
    label: "Inventory Quantity Available"
    description: "The current available stock level in a hub (quantity on stock reduced by reserved items) (as of now - this is not historical data)"
    value_format_name: decimal_1
    group_label: "> Absolute Metrics"
  }

  measure: avg_quantity_on_stock {
    type: average
    sql: ${TABLE}.quantity_on_stock ;;
    label: "Inventory Quantity on Stock"
    description: "The current stock level in a hub incl. reserved items (as of now - this is not historical data)"
    value_format_name: decimal_1
    group_label: "> Absolute Metrics"
  }

  measure: avg_quantity_reserved {
    type: average
    sql: ${TABLE}.quantity_reserved ;;
    label: "Inventory Quantity Reserved"
    description: "The number of reserved items (as of now - this is not historical data)"
    value_format_name: decimal_1
    group_label: "> Absolute Metrics"
  }

  measure: sum_stock_quantity {
    type: sum
    sql: ${TABLE}.quantity_available ;;
    label: "Sum Current Quantity Available"
    description: "The sum of Inventory Quantity Available"
    #filters: [is_most_recent_record: "Yes"]
    value_format_name: decimal_1
    group_label: "> Absolute Metrics"
  }


  measure: sum_out_of_stock {
    label: "SUM Stockouts"
    description: "The sum of skus, that are out-of-stock"
    group_label: "> Absolute Metrics"
    hidden: no
    type: sum
    sql: ${flag_out_of_stock} ;;
    value_format_name: decimal_0
  }


  # ~~~~~~~~  from realtime model:
  # ~~~~~~~~  https://goflink.cloud.looker.com/projects/flink_realtime/files/views/warehouse_stock_facts.view.lkml
  measure: pct_out_of_stock {
    label: "% Out Of Stock"
    description: "Only as of now: This rate gives the sum of all hours, an SKU was out of stock compared to all hours, the hub was open for orders. This rate does NOT provide historical oos data"
    group_label: "> Percentages"
    hidden: no
    type: average
    sql: ${flag_out_of_stock} ;;
    value_format_name: percent_0
    html:
      {% if value > 0.3 %}
      <p style="color: white; background-color: red;font-size: 100%; text-align:center">{{ rendered_value }}</p>
      {% elsif value > 0.2 %}
      <p style="color: white; background-color: #F39C12; font-size:100%; text-align:center">{{ rendered_value }}</p>
      {% elsif value > 0.1 %}
      <p style="color: #D4AC0D; background-color: #FCF3CF; font-size:100%; text-align:center">{{ rendered_value }}</p>
      {% else %}
      <p style="color: black; font-size:100%; text-align:center">{{ rendered_value }}</p>
      {% endif %};;
  }

  measure: pct_with_less_than_five_units_in_stock {
    label: "% Products With Less Than 5 Units in Stock"
    group_label: "> Percentages"
    hidden: no
    description: "Percentage of products with less than 5 units in stock"
    type: number
    sql: AVG(${flag_less_than_five_units_in_stock}) ;;
    value_format_name: percent_0
    html:
      {% if value > 0.5 %}
      <p style="color: white; background-color: red;font-size: 100%; text-align:center">{{ rendered_value }}</p>
      {% elsif value > 0.3 %}
      <p style="color: white;background-color: orange; font-size:100%; text-align:center">{{ rendered_value }}</p>
      {% else %}
      <p style="color: black; font-size:100%; text-align:center">{{ rendered_value }}</p>
      {% endif %};;
  }

}
