view: replenishment_dc_desadvs {
  sql_table_name: `flink-data-prod.curated.replenishment_dc_desadvs`
    ;;

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~   Date Dimensions   ~~~~~~~~~~~~~~~~~~~~~~~~
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
    sql: ${TABLE}.delivery_date ;;
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
# ~~~~~~~~~~~~~~~~~~~~   Dimensions   ~~~~~~~~~~~~~~~~~~~~~~~~
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
    label: "Edi"
    type: string
    sql: ${TABLE}.edi ;;
  }

  dimension: line_number {
    description: "This comes from Transus and in the case of Internal Tool we created a fake one by partioning on despatch_advice_date and despatch_advice_number.
                    It is necessary for uniqueness"
    label: "Line Number"
    hidden: no
    type: number
    sql: ${TABLE}.line_number ;;
  }

  dimension: manufacturer_gln {
    label: "Manufacturer gln"
    type: string
    sql: ${TABLE}.manufacturer_gln ;;
  }

  dimension: reference {
    label: "Reference"
    type: string
    sql: ${TABLE}.reference ;;
  }


  dimension: ship_from_party_gln {
    label: "Ship from Party gln"
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
    type: string
    sql: ${TABLE}.source ;;
    hidden: yes
  }

  dimension: sscc {
    label: "SSCC Code"
    type: string
    sql: ${TABLE}.sscc ;;
  }

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
    label: "Supplier gln"
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

  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    primary_key: yes
    hidden: yes
  }

  dimension: transaction_id {
    description: "This comes from Transus and in the case of Internal Tool we created a fake one with the combination of Despatch Advice Number + IT.
                    It is necessary for uniqueness"
    label: "Transaction ID"
    type: string
    sql: ${TABLE}.transaction_id ;;
    hidden: no
  }

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~   Measures   ~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  measure: count {
    hidden: yes
    type: count
    drill_fields: []
  }
}
