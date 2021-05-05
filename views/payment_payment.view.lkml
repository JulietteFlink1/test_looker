view: payment_payment {
  sql_table_name: `flink-backend.saleor_db_global.payment_payment`
    ;;
  drill_fields: [id]

  dimension: id {
    group_label: "* IDs *"
    primary_key: no
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: unique_id {
    group_label: "* IDs *"
    hidden: yes
    primary_key: yes
    type: number
    sql: concat(${country_iso}, ${id}) ;;
  }

  dimension_group: _sdc_batched {
    group_label: "* Dates and Timestamps *"
    hidden: yes
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
    group_label: "* Dates and Timestamps *"
    hidden: yes
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
    group_label: "* Dates and Timestamps *"
    hidden: yes
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
    group_label: "* IDs *"
    hidden: yes
    type: number
    sql: ${TABLE}._sdc_sequence ;;
  }

  dimension: _sdc_table_version {
    type: number
    hidden: yes
    sql: ${TABLE}._sdc_table_version ;;
  }

  dimension: billing_address_1 {
    hidden: yes
    group_label: "* User Dimensions *"
    type: string
    sql: ${TABLE}.billing_address_1 ;;
  }

  dimension: billing_address_2 {
    hidden: yes
    group_label: "* User Dimensions *"
    type: string
    sql: ${TABLE}.billing_address_2 ;;
  }

  dimension: billing_city {
    hidden: yes
    group_label: "* User Dimensions *"
    type: string
    sql: ${TABLE}.billing_city ;;
  }

  dimension: billing_city_area {
    hidden: yes
    group_label: "* User Dimensions *"
    type: string
    sql: ${TABLE}.billing_city_area ;;
  }

  dimension: billing_company_name {
    hidden: yes
    group_label: "* User Dimensions *"
    type: string
    sql: ${TABLE}.billing_company_name ;;
  }

  dimension: billing_country_area {
    hidden: yes
    group_label: "* User Dimensions *"
    type: string
    sql: ${TABLE}.billing_country_area ;;
  }

  dimension: billing_country_code {
    hidden: yes
    group_label: "* User Dimensions *"
    type: string
    sql: ${TABLE}.billing_country_code ;;
  }

  dimension: billing_email {
    hidden: yes
    group_label: "* User Dimensions *"
    type: string
    sql: ${TABLE}.billing_email ;;
  }

  dimension: billing_first_name {
    hidden: yes
    group_label: "* User Dimensions *"
    type: string
    sql: ${TABLE}.billing_first_name ;;
  }

  dimension: billing_last_name {
    hidden: yes
    group_label: "* User Dimensions *"
    type: string
    sql: ${TABLE}.billing_last_name ;;
  }

  dimension: billing_postal_code {
    hidden: yes
    group_label: "* User Dimensions *"
    type: string
    sql: ${TABLE}.billing_postal_code ;;
  }

  dimension: captured_amount {
    group_label: "* Monetary Values *"
    type: number
    sql: ${TABLE}.captured_amount ;;
  }

  dimension: cc_brand {
    hidden: yes
    type: string
    sql: ${TABLE}.cc_brand ;;
  }

  dimension: cc_exp_month {
    hidden: yes
    type: number
    sql: ${TABLE}.cc_exp_month ;;
  }

  dimension: cc_exp_year {
    hidden: yes
    type: number
    sql: ${TABLE}.cc_exp_year ;;
  }

  dimension: cc_first_digits {
    hidden: yes
    type: string
    sql: ${TABLE}.cc_first_digits ;;
  }

  dimension: cc_last_digits {
    hidden: yes
    type: string
    sql: ${TABLE}.cc_last_digits ;;
  }

  dimension: charge_status {
    group_label: "* Payment Status / Type *"
    type: string
    sql: ${TABLE}.charge_status ;;
  }

  dimension: country_iso {
    group_label: "* User Dimensions *"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension_group: created {
    group_label: "* Dates and Timestamps *"
    label: "Payment Created"
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
    hidden: yes
    type: string
    sql: ${TABLE}.currency ;;
  }

  dimension: customer_ip_address {
    hidden: yes
    type: string
    sql: ${TABLE}.customer_ip_address ;;
  }

  dimension: extra_data {
    hidden: yes
    type: string
    sql: ${TABLE}.extra_data ;;
  }

  dimension: gateway {
    hidden: yes
    type: string
    sql: ${TABLE}.gateway ;;
  }

  dimension: is_active {
    group_label: "* Payment Status / Type *"
    type: yesno
    sql: ${TABLE}.is_active ;;
  }

  dimension_group: modified {
    group_label: "* Dates and Timestamps *"
    hidden: yes
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
    hidden: yes
    group_label: "* IDs *"
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: payment_method_type {
    type: string
    sql: ${TABLE}.payment_method_type ;;
  }

  dimension: to_confirm {
    group_label: "* Payment Status / Type *"
    type: yesno
    sql: ${TABLE}.to_confirm ;;
  }

  dimension: token {
    label: "Payment Token"
    group_label: "* IDs *"
    type: string
    sql: ${TABLE}.token ;;
  }

  dimension: total {
    label: "Payment Total"
    group_label: "* Monetary Values *"
    type: number
    sql: ${TABLE}.total ;;
  }

  ####### Measures

  measure: count {
    label: "# Payments"
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    type: count
    drill_fields: [id, billing_last_name, billing_first_name, billing_company_name]
  }

  measure: sum_of_total {
    group_label: "* Monetary Values *"
    hidden: yes
    label: "Sum of Total Payment"
    type: sum
    sql: ${total} ;;
  }

  measure: sum_of_captured_amount {
    group_label: "* Monetary Values *"
    label: "Sum of Captured Amount"
    type: sum
    sql: ${captured_amount} ;;
  }
}
