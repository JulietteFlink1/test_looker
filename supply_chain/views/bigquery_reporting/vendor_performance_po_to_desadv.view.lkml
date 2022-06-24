view: vendor_performance_po_to_desadv {
  sql_table_name: `flink-data-dev.reporting.vendor_performance_po_to_desadv`
    ;;


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~       Sets.         ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========


  # =========  IDs   =========
  dimension: order_number {
    type: string
    sql: ${TABLE}.order_number ;;
    hidden: yes
  }

  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
    primary_key: yes
  }

  # =========  hidden   =========
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

  dimension: number_selling_units_desadv {
    type: number
    sql: ${TABLE}.number_selling_units_desadv ;;
    hidden: yes
  }

  dimension: number_selling_units_po {
    type: number
    sql: ${TABLE}.number_selling_units_po ;;
    hidden: yes
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: sum_number_selling_units_desadv {

    label: "# Selling Units (DESADV - listed on PO)"

    type: sum
    sql: ${number_selling_units_desadv} ;;
    value_format_name: decimal_0
  }

  measure: sum_number_selling_units_po {

    label: "# Selling Units (PO)"

    type: sum
    sql: ${number_selling_units_po} ;;
    value_format_name: decimal_0
    hidden: yes
  }

  measure: pct_fill_rate_po_to_desadv {

    label: "% Fill Rate (PO >> DESADV)"

    type: number
    sql: safe_divide(${sum_number_selling_units_desadv}, ${sum_number_selling_units_po}) ;;
    value_format_name: percent_1
  }


}
