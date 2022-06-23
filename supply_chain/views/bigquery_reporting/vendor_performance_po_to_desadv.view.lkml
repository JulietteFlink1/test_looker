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
  dimension: is_item_on_desadv {
    label: "Is PO item on DESADV"
    type: yesno
    sql: ${TABLE}.is_item_on_desadv ;;
  }

  dimension: is_item_on_po {
    label: "Is DESADV item on PO"
    type: yesno
    sql: ${TABLE}.is_item_on_po ;;
  }





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

  dimension: number_of_items_on_desadv {
    type: number
    sql: ${TABLE}.number_of_items_on_desadv ;;
    hidden: yes
  }

  dimension: number_of_items_on_po {
    type: number
    sql: ${TABLE}.number_of_items_on_po ;;
    hidden: yes
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: sum_number_of_items_on_desadv_listed_on_po {

    label: "# Selling Units (DESADV - listed on PO)"

    type: sum
    filters: [is_item_on_po: "Yes"]
    sql: ${number_of_items_on_desadv} ;;
    value_format_name: decimal_0
  }

  measure: sum_number_of_items_listed_on_po {

    label: "# Selling Units (PO)"

    type: sum
    filters: [is_item_on_po: "Yes"]
    sql: ${number_of_items_on_desadv} ;;
    value_format_name: decimal_0
  }

  measure: pct_fill_rate_po_to_desadv {

    label: "% Fill Rate (PO >> DESADV)"

    type: number
    sql: safe_divide(${sum_number_of_items_on_desadv_listed_on_po}, ${sum_number_of_items_listed_on_po}) ;;
    value_format_name: percent_1
  }


}
