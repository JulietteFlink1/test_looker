# Owner:  Brandon Beckett
# Created: 2022-05-20

# This view contains curated layer data from CommerceTools product discounts.


view: product_discounts {
  sql_table_name: `flink-data-prod.curated.product_discounts` ;;
  drill_fields: [product_discount_id]

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# ====================     __main__     ====================

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
  }

 dimension_group: last_modified {
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
    sql: ${TABLE}.last_modified_at ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: hub_name {
    type: string
    sql: ${TABLE}.hub_name ;;
  }

  dimension: product_sku {
    type: string
    sql: ${TABLE}.product_sku ;;
  }

  dimension: is_product_discount_active {
    type: yesno
    sql: ${TABLE}.is_product_discount_active ;;
  }

  dimension: product_discount_type {
    type: string
    sql: ${TABLE}.product_discount_type ;;
    description: "Product discounts can only be Relative (%) or Absolute (€0.00)"
  }

  dimension: amt_absolute_product_discount {
    type: number
    sql: ${TABLE}.amt_absolute_product_discount ;;
    description: "Absolute (€0.00) discount value. This amount is subtracted from the product price."
    value_format: "€0.00"
  }

  dimension: amt_relative_product_discount_percent {
    type: number
    sql: ${TABLE}.amt_relative_product_discount_percent ;;
    description: "Relative (%) discount value. This is the percent reduction applied to the product price"
    value_format: "0.00\%"
  }

  dimension: product_discount_name {
    type: string
    sql: ${TABLE}.product_discount_name ;;
  }

  dimension: product_discount_description {
    type: string
    sql: ${TABLE}.product_discount_description ;;
  }

  dimension: product_discount_sort_order {
    type: string
    sql: ${TABLE}.product_discount_sort_order ;;
    description: "The Sort order determines which product discount applies to your product. Discounts with a sort order value closer to 1 are considered first. Sort order values can only be a value between 0 and 1."
  }

  dimension_group: valid_from {
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
    sql: ${TABLE}.valid_from ;;
  }

  dimension_group: valid_until {
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
    sql: ${TABLE}.valid_until ;;
  }


# ====================      hidden      ====================



# ====================       IDs        ====================

  dimension: product_discount_uuid {
    type: string
    sql: ${TABLE}.product_discount_uuid ;;
    description: "Unique identifier for each product discount ID + SKU + hub combination"
    primary_key: yes
  }

  dimension: product_discount_id {
    type: string
    sql: ${TABLE}.product_discount_id ;;
    description: "Unique identifier for each product discount found in CommerceTools"
  }

  dimension: channel_id {
    type: string
    sql: ${TABLE}.channel_id ;;
    description: "Hub ID assigned by CommerceTools "
  }

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: count {
    type: count
    drill_fields: [product_discount_id, product_sku, hub_code]
  }

}
