# Owner: Brandon Beckett
# Created: 2022-02-08
#
# This view contains SKUs that have been included in previous, current, and planned price tests
#
# Logs:
# 2022-02-08 - Initially created view for explore related to Jira Ticket: DATA-1856


view: price_test_tracking {
  sql_table_name: `flink-data-prod.google_sheets.price_test_tracking` ;;


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# ====================     __main__     ====================

  dimension: control_price {

    label: "Control Price"
    description: "Control unit price gross amount before the test start date"

    type: number
    sql: ${TABLE}.control_price ;;
  }

  dimension: country_iso {

    label: "Country ISO"
    description: "Country where the price test occurred"

    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: end_date {

    label: "Price Test End Date"
    description: "Date when the test ended"

    type: date
    convert_tz: no
    sql: ${TABLE}.end_date ;;
  }

  dimension: product_sku {

    label: "SKU"
    description: "Flink's product SKU"

    type: string
    sql: CAST(${TABLE}.sku AS string);;
  }

  dimension: start_date {

    label: "Price Test Start Date"
    description: "Date when the price test began"

    type: date
    convert_tz: no
    sql: ${TABLE}.start_date ;;
  }

  dimension: test_name {

    label: "Price Test Name"
    description: "Test name used by Pricing team"

    type: string
    sql: ${TABLE}.test_name ;;
  }

  dimension: variation_price {

    label: "Variation Price"
    description: "New unit price gross amount that is tested"

    type: number
    sql: ${TABLE}.variation_price ;;
  }


# ====================      hidden      ====================

  dimension_group: fivetran_synced {
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
    sql: ${TABLE}._fivetran_synced ;;
    hidden: yes
  }

  dimension: _row {
    type: number
    sql: ${TABLE}._row ;;
    hidden:  yes
  }

# ====================       IDs        ====================

  dimension: test_sku_uuid {

    label: "Test SKU UUID"
    description: "Unique ID containing the SKU & test ID"

    type: string
    sql: ${TABLE}.test_sku_uuid ;;
  }

  dimension: test_id {

    label: "Test ID"
    description: "Test ID containing the country ISO, start date year & month, & test name"

    type: string
    sql: ${TABLE}.test_id ;;
  }

}
