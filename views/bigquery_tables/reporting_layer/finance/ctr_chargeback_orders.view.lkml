view: ctr_chargeback_orders {
  sql_table_name: `flink-data-dev.reporting.ctr_chargeback_orders`
    ;;

  dimension_group: booking_month_ {
    type: time
    timeframes: [month]
    datatype: date
    hidden:  yes
    sql: ${TABLE}.booking_month ;;
  }

  dimension: booking_month {
    type: string
    sql:${TABLE}.booking_month;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: ctr_month_payment_method_uuid {
    type: string
    hidden: yes
    sql: ${TABLE}.ctr_month_payment_method_uuid ;;
  }

  dimension: merchant_account {
    type: string
    sql: ${TABLE}.merchant_account ;;
  }

  dimension: payment_method_grouped {
    type: string
    sql: ${TABLE}.payment_method_grouped ;;
    primary_key: yes
  }

  measure: total_chargebacks_transactions {
    type: sum
    sql: ${TABLE}.total_chargebacks_transactions ;;
    value_format_name: decimal_0
  }

  measure: total_main_amount_chargeback {
    type: sum
    hidden: yes
    sql: ${TABLE}.total_main_amount_chargeback ;;
    value_format_name: eur
  }

  measure: total_main_amount_settled {
    type: sum
    hidden: yes
    sql: ${TABLE}.total_main_amount_settled ;;
    value_format_name:  eur
  }

  measure: total_settled_transactions {
    type: sum
    hidden: yes
    sql: ${TABLE}.total_settled_transactions ;;
    value_format_name: decimal_0
  }

  measure: total_main_amount_authorised {
    type: sum
    hidden: yes
    sql: ${TABLE}.total_main_amount_authorised ;;
    value_format_name: eur
  }

  measure: total_authorised_transactions {
    type: sum
    hidden: yes
    sql: ${TABLE}.total_authorised_transactions ;;
    value_format_name: decimal_0
  }

  measure: total_main_amount_chargeback_previous_month {
    type: sum
    hidden: yes
    sql: ${TABLE}.total_main_amount_chargeback_previous_month ;;
    value_format_name: eur
  }

  measure: total_main_amount_settled_previous_month {
    type: sum
    hidden: yes
    sql: ${TABLE}.total_main_amount_settled_previous_month ;;
    value_format_name: eur
  }

  measure: total_chargebacks_transactions_previous_month {
    type: sum
    hidden: yes
    sql: ${TABLE}.total_chargebacks_transactions_previous_month ;;
    value_format_name: decimal_0
  }

  measure: total_settled_transactions_previous_month {
    type: sum
    hidden: yes
    sql: ${TABLE}.total_settled_transactions_previous_month ;;
    value_format_name: decimal_0
  }

  measure: total_main_amount_chargeback_previous2_month {
    type: sum
    hidden: yes
    sql: ${TABLE}.total_main_amount_chargeback_previous2_month ;;
    value_format_name: eur
  }

  measure: total_main_amount_authorised_previous2_month {
    type: sum
    hidden: yes
    sql: ${TABLE}.total_main_amount_authorised_previous2_month ;;
    value_format_name: eur
  }

  measure: total_chargebacks_transactions_previous2_month {
    type: sum
    hidden: yes
    sql: ${TABLE}.total_chargebacks_transactions_previous2_month ;;
    value_format_name: decimal_0
  }

  measure: total_authorised_transactions_previous2_month {
    type: sum
    hidden: yes
    sql: ${TABLE}.total_authorised_transactions_previous2_month ;;
    value_format_name: decimal_0
  }

  ### we need to do the following pre-calculations so that we can display all CTRs in one graph without having to filter for payment methods (which would ruin the CTR metric)


  ### pre-calculations Mastercard

  measure: total_chargebacks_transactions_mc {
    group_label: "* MasterCard *"
    type: sum
    sql: ${TABLE}.total_chargebacks_transactions ;;
    value_format_name: decimal_0
    filters: [payment_method_grouped: "mc"]
  }

  measure: total_settled_transactions_previous_month_mc {
    group_label: "* MasterCard *"
    type: sum
    hidden: yes
    sql: ${TABLE}.total_settled_transactions_previous_month ;;
    value_format_name: decimal_0
    filters: [payment_method_grouped: "mc"]
  }

  measure: total_main_amount_chargeback_mc {
    group_label: "* MasterCard *"
    type: sum
    sql: ${TABLE}.total_main_amount_chargeback ;;
    value_format_name: eur
    filters: [payment_method_grouped: "mc"]
  }

  measure: total_main_amount_settled_previous_month_mc {
    group_label: "* MasterCard *"
    type: sum
    hidden: yes
    sql: ${TABLE}.total_main_amount_settled_previous_month ;;
    value_format_name: eur
    filters: [payment_method_grouped: "mc"]
  }

  measure: total_settled_transactions_mc {
    group_label: "* MasterCard *"
    type: sum
    sql: ${TABLE}.total_settled_transactions ;;
    value_format_name: decimal_0
    filters: [payment_method_grouped: "mc"]
  }

  measure: total_main_amount_settled_mc {
    group_label: "* MasterCard *"
    type: sum
    sql: ${TABLE}.total_main_amount_settled ;;
    value_format_name:  eur
    filters: [payment_method_grouped: "mc"]
  }


  ### pre-calculations Visa

  measure: total_chargebacks_transactions_visa {
    group_label: "* Visa *"
    type: sum
    sql: ${TABLE}.total_chargebacks_transactions ;;
    value_format_name: decimal_0
    filters: [payment_method_grouped: "visa"]
  }

  measure: total_settled_transactions_visa {
    group_label: "* Visa *"
    type: sum
    sql: ${TABLE}.total_settled_transactions ;;
    value_format_name: decimal_0
    filters: [payment_method_grouped: "visa"]
  }

  measure: total_main_amount_chargeback_visa {
    group_label: "* Visa *"
    type: sum
    sql: ${TABLE}.total_main_amount_chargeback ;;
    value_format_name: eur
    filters: [payment_method_grouped: "visa"]
  }

  measure: total_main_amount_settled_visa {
    group_label: "* Visa *"
    type: sum
    sql: ${TABLE}.total_main_amount_settled ;;
    value_format_name:  eur
    filters: [payment_method_grouped: "visa"]
  }


  ### pre-calculations CTR CBC

  measure: total_main_amount_chargeback_previous2_month_cbc {
    group_label: "* Cartebancaire *"
    type: sum
    hidden: yes
    sql: ${TABLE}.total_main_amount_chargeback_previous2_month ;;
    value_format_name: eur
    filters: [payment_method_grouped: "cartebancaire"]
  }

  measure: total_main_amount_authorised_previous2_month_cbc {
    group_label: "* Cartebancaire *"
    type: sum
    hidden:  yes
    sql: ${TABLE}.total_main_amount_authorised_previous2_month ;;
    value_format_name: eur
    filters: [payment_method_grouped: "cartebancaire"]
  }

  measure: total_chargebacks_transactions_previous2_month_cbc {
    group_label: "* Cartebancaire *"
    type: sum
    hidden:  yes
    sql: ${TABLE}.total_chargebacks_transactions_previous2_month ;;
    value_format_name: decimal_0
    filters: [payment_method_grouped: "cartebancaire"]
  }

  measure: total_authorised_transactions_previous2_month_cbc {
    group_label: "* Cartebancaire *"
    type: sum
    hidden: yes
    sql: ${TABLE}.total_authorised_transactions_previous2_month ;;
    value_format_name: decimal_0
    filters: [payment_method_grouped: "cartebancaire"]
  }

  measure: total_chargebacks_transactions_cbc {
    group_label: "* Cartebancaire *"
    type: sum
    sql: ${TABLE}.total_chargebacks_transactions ;;
    value_format_name: decimal_0
    filters: [payment_method_grouped: "cartebancaire"]
  }

  measure: total_authorised_transactions_cbc {
    group_label: "* Cartebancaire *"
    type: sum
    sql: ${TABLE}.total_authorised_transactions ;;
    value_format_name: decimal_0
    filters: [payment_method_grouped: "cartebancaire"]
  }

  measure: total_main_amount_chargeback_cbc {
    group_label: "* Cartebancaire *"
    type: sum
    sql: ${TABLE}.total_main_amount_chargeback ;;
    value_format_name: eur
    filters: [payment_method_grouped: "cartebancaire"]
  }

  measure: total_main_amount_authorised_cbc {
    group_label: "* Cartebancaire *"
    type: sum
    sql: ${TABLE}.total_main_amount_authorised ;;
    value_format_name:  eur
    filters: [payment_method_grouped: "cartebancaire"]
  }


  ### MasterCard CTR calculations

  measure: percentage_ctr_mc_trx {
    group_label: "* MasterCard *"
    type: number
    sql: NULLIF(${total_chargebacks_transactions_mc},0) / NULLIF(${total_settled_transactions_previous_month_mc},0) ;;
    value_format_name: percent_2
  }

  measure: percentage_ctr_mc_amount {
    group_label: "* MasterCard *"
    type: number
    sql: NULLIF(${total_main_amount_chargeback_mc},0) / NULLIF(${total_main_amount_settled_previous_month_mc},0) ;;
    value_format_name: percent_2
  }

  ### Visa CTR calculatons

  measure: percentage_ctr_visa_trx {
    group_label: "* Visa *"
    type: number
    sql: ${total_chargebacks_transactions_visa} / ${total_settled_transactions_visa} ;;
    value_format_name: percent_2
  }

  measure: percentage_ctr_visa_amount {
    group_label: "* Visa *"
    type: number
    sql: ${total_main_amount_chargeback_visa} / ${total_main_amount_settled_visa} ;;
    value_format_name: percent_2
  }

  ### CBC CTR calculations

  measure: percentage_ctr_cbc_trx {
    group_label: "* Cartebancaire *"
    type: number
    sql: NULLIF(${total_chargebacks_transactions_previous2_month_cbc},0) / NULLIF(${total_authorised_transactions_previous2_month_cbc},0) ;;
    value_format_name: percent_2
  }

  measure: percentage_ctr_cbc_amount {
    group_label: "* Cartebancaire *"
    type: number
    sql: NULLIF(${total_main_amount_chargeback_previous2_month_cbc},0) / NULLIF(${total_main_amount_authorised_previous2_month_cbc},0) ;;
    value_format_name: percent_2
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
