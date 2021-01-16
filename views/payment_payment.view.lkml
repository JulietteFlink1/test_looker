view: payment_payment {
  sql_table_name: `heroku_backend.payment_payment`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: _sdc_batched {
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
    sql: ${TABLE}._sdc_batched_at ;;
  }

  dimension_group: _sdc_extracted {
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
    sql: ${TABLE}._sdc_extracted_at ;;
  }

  dimension_group: _sdc_received {
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
    sql: ${TABLE}._sdc_received_at ;;
  }

  dimension: _sdc_sequence {
    type: number
    sql: ${TABLE}._sdc_sequence ;;
  }

  dimension: _sdc_table_version {
    type: number
    sql: ${TABLE}._sdc_table_version ;;
  }

  dimension: billing_address_1 {
    type: string
    sql: ${TABLE}.billing_address_1 ;;
  }

  dimension: billing_address_2 {
    type: string
    sql: ${TABLE}.billing_address_2 ;;
  }

  dimension: billing_city {
    type: string
    sql: ${TABLE}.billing_city ;;
  }

  dimension: billing_city_area {
    type: string
    sql: ${TABLE}.billing_city_area ;;
  }

  dimension: billing_company_name {
    type: string
    sql: ${TABLE}.billing_company_name ;;
  }

  dimension: billing_country_area {
    type: string
    sql: ${TABLE}.billing_country_area ;;
  }

  dimension: billing_country_code {
    type: string
    sql: ${TABLE}.billing_country_code ;;
  }

  dimension: billing_email {
    type: string
    sql: ${TABLE}.billing_email ;;
  }

  dimension: billing_first_name {
    type: string
    sql: ${TABLE}.billing_first_name ;;
  }

  dimension: billing_last_name {
    type: string
    sql: ${TABLE}.billing_last_name ;;
  }

  dimension: billing_postal_code {
    type: string
    sql: ${TABLE}.billing_postal_code ;;
  }

  dimension: captured_amount {
    type: number
    sql: ${TABLE}.captured_amount ;;
  }

  dimension: cc_brand {
    type: string
    sql: ${TABLE}.cc_brand ;;
  }

  dimension: cc_first_digits {
    type: string
    sql: ${TABLE}.cc_first_digits ;;
  }

  dimension: cc_last_digits {
    type: string
    sql: ${TABLE}.cc_last_digits ;;
  }

  dimension: charge_status {
    type: string
    sql: ${TABLE}.charge_status ;;
  }

  dimension: checkout_id {
    type: string
    sql: ${TABLE}.checkout_id ;;
  }

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
    sql: ${TABLE}.created ;;
  }

  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
  }

  dimension: customer_ip_address {
    type: string
    sql: ${TABLE}.customer_ip_address ;;
  }

  dimension: extra_data {
    type: string
    sql: ${TABLE}.extra_data ;;
  }

  dimension: gateway {
    type: string
    sql: ${TABLE}.gateway ;;
  }

  dimension: is_active {
    type: yesno
    sql: ${TABLE}.is_active ;;
  }

  dimension_group: modified {
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
    sql: ${TABLE}.modified ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: to_confirm {
    type: yesno
    sql: ${TABLE}.to_confirm ;;
  }

  dimension: token {
    type: string
    sql: ${TABLE}.token ;;
  }

  dimension: total {
    type: number
    sql: ${TABLE}.total ;;
  }

  measure: count {
    type: count
    drill_fields: [id, billing_last_name, billing_first_name, billing_company_name]
  }
}
