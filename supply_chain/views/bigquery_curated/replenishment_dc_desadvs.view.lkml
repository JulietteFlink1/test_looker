view: replenishment_dc_desadvs {
  sql_table_name: `flink-data-prod.curated.replenishment_dc_desadvs`
    ;;


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~   Date Dimensions   ~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  dimension_group: delivery_date {
    group_label: "> Date Dimensions"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: case when ${TABLE}.delivery_date is null then ${TABLE}.despatch_advice_date else ${TABLE}.delivery_date end   ;;
  }

  dimension_group: despatch_advice {
    group_label: "> Date Dimensions"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.despatch_advice_date ;;
  }

  dimension_group: requested_delivery {
    group_label: "> Date Dimensions"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.requested_delivery_date ;;
  }




# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~ Dimensions   ~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: article_description {
    label: "SKU Description"
    type: string
    sql: ${TABLE}.article_description ;;
  }

  dimension: article_gtin_hu {
    label: "EAN Hu"
    type: string
    sql: ${TABLE}.article_gtin_hu ;;
  }

  dimension: delivered_to {
    label: "Delivered to"
    type: string
    sql: ${TABLE}.delivered_to ;;
  }

  dimension: delivered_to_gln {
    label: "Delivered to GLN"
    type: string
    sql: ${TABLE}.delivered_to_gln ;;
  }

  dimension: delivery_amount_hu {
    label: "Delivery Amount Hu"
    type: number
    sql: ${TABLE}.delivery_amount_hu ;;
  }


  dimension: despatch_advice_number {
    label: "Despatch Advice Number"
    type: string
    sql: ${TABLE}.despatch_advice_number ;;
  }

  dimension: edi {
    label: "EDI"
    type: string
    sql: ${TABLE}.edi ;;
  }

  dimension: line_number {
    label: "Line Number"
    hidden: yes
    type: number
    sql: ${TABLE}.line_number ;;
  }

  dimension: manufacturer_gln {
    label: "Manufacturer GLN"
    type: string
    sql: ${TABLE}.manufacturer_gln ;;
  }

  dimension: reference {
    label: "Reference"
    type: string
    sql: ${TABLE}.reference ;;
  }

  dimension: ship_from_party_gln {
    label: "Ship from Party GLN"
    type: string
    sql: ${TABLE}.ship_from_party_gln ;;
  }

  dimension: sku {
    label: "SKU"
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: source {
    label: "Source"
    hidden: yes
    type: string
    sql: ${TABLE}.source ;;
  }

  dimension: sscc {
    label: "SSCC Code"
    type: string
    sql: ${TABLE}.sscc ;;
  }

  dimension: table_uuid {
    hidden: yes
    type: string
    sql: ${TABLE}.table_uuid ;;
    primary_key: yes
  }

  dimension: temperature_zone {
    label: "Temperature Zone"
    type: string
    sql: ${TABLE}.temperature_zone ;;
  }

  dimension: transaction_id {
    label: "Transaction ID"
    hidden: yes
    type: string
    sql: ${TABLE}.transaction_id ;;
  }


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~ Supplier Dimensions   ~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  dimension: supplier {
    label: "Supplier Name"
    group_label: "> Supplier Dimensions"
    type: string
    sql: ${TABLE}.supplier ;;
  }

  dimension: supplier_address {
    label: "Supplier Address"
    group_label: "> Supplier Dimensions"
    type: string
    sql: ${TABLE}.supplier_address ;;
  }

  dimension: supplier_city {
    label: "Supplier City"
    group_label: "> Supplier Dimensions"
    type: string
    sql: ${TABLE}.supplier_city ;;
  }

  dimension: supplier_country {
    label: "Supplier Country"
    group_label: "> Supplier Dimensions"
    type: string
    sql: ${TABLE}.supplier_country ;;
  }

  dimension: supplier_gln {
    label: "Supplier GLN"
    group_label: "> Supplier Dimensions"
    type: string
    sql: ${TABLE}.supplier_gln ;;
  }

  dimension: supplier_zip {
    label: "Supplier ZIP"
    group_label: "> Supplier Dimensions"
    type: string
    sql: ${TABLE}.supplier_zip ;;
  }

  dimension: supplier_id {
    label: "Supplier ID"
    group_label: "> Supplier Dimensions"
    type: string
    sql: ${TABLE}.supplier_id ;;
  }


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~  Measures   ~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: count {
    hidden: yes
    type: count
    drill_fields: []
  }
}
