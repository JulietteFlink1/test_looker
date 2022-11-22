view: psp_transactions {
  sql_table_name: `flink-data-prod.curated.psp_transactions`
    ;;

  dimension: authorised_pc {
    type: number
    hidden: yes
    sql: ${TABLE}.authorised_pc ;;
  }

  dimension: psp_transaction_uuid {
    type: string
    hidden: yes
    sql:${TABLE}.psp_transaction_uuid ;;
    primary_key: yes
  }

  dimension: country_iso {
    group_label: "> Geographic Dimensions"
    type: string
    sql:${TABLE}.country_iso ;;
  }

  dimension_group: booking_date {
    type: time
    hidden: yes
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.booking_date ;;
  }

  dimension_group: booking {
    group_label: "> Dates & Timestamps"
    alias: [booking_timestamp]
    type: time
    timeframes: [
      raw,
      date,
      week,
      month
    ]
    sql: ${TABLE}.booking_timestamp ;;
  }

  dimension: captured_pc {
    type: number
    hidden:  yes
    sql: ${TABLE}.captured_pc ;;
  }

  dimension: commission_sc {
    type: number
    hidden: yes
    sql: ${TABLE}.commission_sc ;;
  }

  dimension: interchange_sc {
    type: number
    hidden: yes
    sql: ${TABLE}.interchange_sc ;;
  }

  dimension: main_amount {
    type: number
    hidden: yes
    sql: ${TABLE}.main_amount ;;
  }

  dimension: main_currency {
    group_label: "> Transaction Properties"
    type: string
    sql: ${TABLE}.main_currency ;;
  }

  dimension: markup_sc {
    type: number
    hidden: yes
    sql: ${TABLE}.markup_sc ;;
  }

  dimension: merchant_account {
    group_label: "> Geographic Dimensions"
    type: string
    sql: ${TABLE}.merchant_account ;;
  }

  dimension: modification_merchant_reference {
    group_label: "> IDs and References"
    type: string
    sql: ${TABLE}.modification_merchant_reference ;;
  }

  dimension: order_uuid {
    group_label: "> IDs and References"
    type: string
    sql: ${TABLE}.order_uuid ;;
  }

  dimension: payable_sc {
    type: number
    hidden: yes
    sql: ${TABLE}.payable_sc ;;
  }

  dimension: payment_currency {
    group_label: "> Payment Methods"
    type: string
    sql: ${TABLE}.payment_currency ;;
  }

  dimension: payment_id {
    group_label: "> IDs and References"
    type: string
    sql: ${TABLE}.payment_id ;;
  }

  dimension: payment_method {
    group_label: "> Payment Methods"
    type: string
    sql: ${TABLE}.payment_method ;;
  }

  dimension: payment_method_grouped_product {
    group_label: "> Payment Methods"
    type: string
    sql:case when ${payment_method} like '%applepay' then 'ApplePay'
             when ${payment_method} like 'mc%' then 'MC'
             when ${payment_method} like 'directEbank%' then 'Sofort'
             when ${payment_method} like 'carteban%' then 'CarteBanCaire'
             when ${payment_method} like 'paypa%' then 'PayPal'
             when ${payment_method} like 'visa%' OR ${payment_method} like 'electro%' then 'Visa'
             when ${payment_method} like 'ideal%' then 'Ideal'
             when ${payment_method} like 'cup%' then 'Cup'
        else 'other'
        end ;;
  }

  dimension: payment_method_grouped_fraud {
    group_label: "> Payment Methods"
    type: string
    sql:case when ${payment_method} like 'amex%' then 'amex'
             when ${payment_method} like 'mc%' then 'mc'
             when ${payment_method} like 'visa%' OR ${payment_method} like 'electro%' then 'visa'
             when ${payment_method} like 'maestr%' then 'maestro'
             when ${payment_method} like 'ideal%' then 'ideal'
             when ${payment_method} like 'cup%' then 'cup'
             when ${payment_method} like 'jcb%' then 'jcb'
        else ${payment_method}
        end ;;
  }

  dimension: processing_fee_fc {
    type: number
    hidden: yes
    sql: ${TABLE}.processing_fee_fc ;;
  }

  dimension: psp_reference {
    group_label: "> IDs and References"
    type: string
    sql: ${TABLE}.psp_reference ;;
    link: {
      label: "See Payment in Adyen"
      url: "https://ca-live.adyen.com/ca/ca/accounts/showTx.shtml?pspReference={{ psp_reference._value | url_encode }}&txType=Payment"
    }
  }

  dimension: received_pc {
    type: number
    hidden: yes
    sql: ${TABLE}.received_pc ;;
  }

  dimension: record_type {
    group_label: "> Transaction Properties"
    label: "Transaction Type"
    description: "Record Type in Ayen. e.g. Authorised, Refunded, Chargeback"
    type: string
    sql: ${TABLE}.record_type ;;
  }

  dimension: scheme_fees_sc {
    type: number
    hidden: yes
    sql: ${TABLE}.scheme_fees_sc ;;
  }

  dimension: timezone {
    hidden: yes
    type: string
    sql: ${TABLE}.timezone ;;
  }

  dimension: user_name {
    group_label: "> Transaction Properties"
    required_access_grants: [can_view_customer_data]
    type: string
    sql: ${TABLE}.user_name ;;
  }

  dimension: is_duplicated_psp_reference {
    group_label: "> Transaction Properties"
    type: yesno
    description: "Flags if the PSP reference appears in more than one CT order"
    sql: ${TABLE}.is_duplicated_psp_reference ;;
  }

  dimension: is_orphaned_double_payment_transaction {
    group_label: "> Transaction Properties"
    type: yesno
    description: "Orphaned Double Payments Transactions are PSP references that were not recorded in CT because of a product bug. They were match to their corresponding CT order using Adyen’s merchant reference that contains CT cart id."
    sql: ${TABLE}.is_orphaned_double_payment_transaction ;;
  }

  dimension: is_orphaned_transaction {
    group_label: "> Transaction Properties"
    type: yesno
    description: "Flags if the Transaction is an Orphaned Double Payment Transaction or if the Transaction is an Empty Order Transaction."
    sql: ${TABLE}.is_orphaned_transaction ;;
  }

  dimension: is_empty_order_transaction {
    group_label: "> Transaction Properties"
    type: yesno
    description: "Flags if the Transaction is not linked to any Order in CT."
    sql: ${order_uuid} is null ;;
  }

  dimension: is_test_order_transaction {
    group_label: "> Transaction Properties"
    type: yesno
    description: "Flags if the Transaction is linked to a test Order in CT. In this case the Order UUID coming from the Orders view is null because test orders are excluded from the Orders view. The Order UUID coming from the PSP transactions view is populated"
    sql: ${TABLE}.is_test_order_transaction ;;
  }

  dimension: a_3d_authentication_response {
    group_label: "> Received Payments"
    label: "3D Authentication Response"
    type: string
    description: "For payments processed with 3D Secure (Secure Code/Verified by Visa), and directory response Y, this holds the authentication response.
    Values: Y, N, U, A E"
    sql: ${TABLE}.a_3d_authentication_response ;;
  }

  dimension: acquirer_response {
    group_label: "> Received Payments"
    type: string
    description: "Normalized response from the acquirer. Not necessarily the final status of the payment."
    sql: ${TABLE}.acquirer_response ;;
  }

  dimension: bin_funding_source {
    group_label: "> Received Payments"
    type: string
    description: "Card funding source.
    Example values: CHARGE, CREDIT, DEBIT,PREPAID"
    sql: ${TABLE}.bin_funding_source ;;
  }

  dimension: browser {
    group_label: "> Received Payments"
    type: string
    description: "Browser used by the customer."
    sql: ${TABLE}.browser ;;
  }

  dimension: cart_id {
    group_label: "> Received Payments"
    type: string
    description: "Unique ID of the cart, generated by CT. Not available for Saleor."
    sql: ${TABLE}.cart_id ;;
  }

  dimension: device {
    group_label: "> Received Payments"
    type: string
    description: "Device used by the customer."
    sql: ${TABLE}.device ;;
  }

  dimension: issuer_country {
    label: "Issuing Bank Country"
    group_label: "> Received Payments"
    type: string
    description: "ISO country code of the issuer."
    sql: ${TABLE}.issuer_country ;;
  }

  dimension: issuer_name {
    group_label: "> Received Payments"
    label: "Issuing Bank"
    type: string
    description: "Name of the issuing bank, if available."
    sql: ${TABLE}.issuer_name ;;
  }

  dimension: raw_acquirer_response {
    group_label: "> Received Payments"
    type: string
    description: "Raw response we receive from the acquirer, if available."
    sql: ${TABLE}.raw_acquirer_response ;;
  }

  dimension: amt_risk_scoring {
    group_label: "> Received Payments"
    type: number
    description: "Total risk scoring value of the payment."
    sql: ${TABLE}.amt_risk_scoring ;;
  }

  dimension: shopper_country {
    group_label: "> Received Payments"
    type: string
    description: "ISO country code of the shopper, if available. If not available, this is computed based on the shopper's IP address."
    sql: ${TABLE}.shopper_country ;;
  }

  dimension: shopper_id {
    group_label: "> Received Payments"
    type: string
    description: "IP address (IPV4 or IPV6) of the shopper as provided during the original transaction, if available."
    sql: ${TABLE}.shopper_id ;;
  }

  dimension: shopper_interaction {
    group_label: "> Received Payments"
    type: string
    description: "Transaction type.
    Possible values: Ecommerce, ContAuth, POS, MOTO."
    sql: ${TABLE}.shopper_interaction ;;
  }

  dimension: shopper_name {
    group_label: "> Received Payments"
    required_access_grants: [can_view_customer_data]
    type: string
    description: "Name of the cardholder, as provided with the transaction, if available."
    sql: ${TABLE}.shopper_name ;;
  }

#### Referral List dimensions

  dimension: referral_active_user_name {
    group_label: "> Referral List"
    label: "Referral Active User Name"
    type: string
    description: "Name of the Adyen user that created the referral. Null if it was automatically created."
    sql: ${TABLE}.referral_active_user_name ;;
  }

  dimension: is_blocked_referral {
    group_label: "> Referral List"
    label: "Is Blocked (Referral)"
    type: yesno
    description: "Yes if the referral was blocked. No if the referral was unblocked."
    sql: ${TABLE}.is_blocked_referral ;;
  }

  dimension_group: referral_created_at {
    group_label: "> Dates & Timestamps"
    type: time
    timeframes: [
      date,
      week,
      month,
      year
    ]
    sql: ${TABLE}.referral_created_at_timestamp ;;
    description: "Timestamp of when the PSP reference / email / domain was added to the referral list."
  }

  dimension_group: referral_ended_at {
    group_label: "> Dates & Timestamps"
    type: time
    timeframes: [
      date,
      week,
      month,
      year
    ]
    sql: ${TABLE}.referral_ended_at_timestamp ;;
    description: "Timestamp of when the PSP reference / email / domain was removed from the referral list."
  }

  dimension: referral_reason_raw {
    group_label: "> Referral List"
    label: "Referral Reason Raw"
    description: "Reason for the referral as entered in Adyen. Contains the PSP Reference when available."
    type: string
    sql: ${TABLE}.referral_reason_raw ;;
  }

  dimension: referral_reason {
    group_label: "> Referral List"
    label: "Referral Reason"
    type: string
    description: "Clean referral reason based on mapping provided by Finance team. (e.g.: Scam, Known High-Risk Country)."
    sql: ${TABLE}.referral_reason ;;
  }

  dimension: referral_type {
    group_label: "> Referral List"
    label: "Referral Type"
    description: "Type of the referral. (e.g.: shopperEmail, phoneNumber)"
    type: string
    sql: ${TABLE}.referral_type ;;
  }

  dimension: referral_raw {
    group_label: "> Referral List"
    label: "Referral Raw Value"
    type: string
    description: "Raw value for the referral. It can be a name, a phone number, an email, a domain etc."
    sql: ${TABLE}.referral_raw ;;
  }


##################    MEASURES  ###################

  measure: sum_main_amount {
    group_label: "> Amounts Captured"
    type: sum
    sql: ${main_amount} ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_main_amount_chargebacks {
    group_label: "> Amounts Captured"
    type: sum
    sql: ${main_amount} ;;
    value_format_name: euro_accounting_2_precision
    filters: [record_type: "Chargeback"]
  }

  measure: sum_main_amount_refunded {
    group_label: "> Amounts Captured"
    type: sum
    sql: ${main_amount} ;;
    value_format_name: euro_accounting_2_precision
    filters: [record_type: "Refunded, RefundedExternally"]
  }

  measure: sum_captured_pc_refunded {
    group_label: "> Amounts Captured"
    description: "Sum Main Amount for Refunded/RefundedExternally Record Type"
    type: sum
    sql: ${captured_pc} ;;
    value_format_name: euro_accounting_2_precision
    filters: [record_type: "Refunded, RefundedExternally"]
  }

  measure: sum_main_amount_settled {
    group_label: "> Amounts Captured"
    type: sum
    description: "Sum Main Amount for Settled Record Type"
    sql: ${main_amount} ;;
    value_format_name: euro_accounting_2_precision
    filters: [record_type: "Settled"]
  }

  measure: sum_main_amount_sent_for_settle {
    group_label: "> Amounts Captured"
    type: sum
    description: "Sum Main Amount for Sent for Settle Record Type"
    sql: ${main_amount} ;;
    value_format_name: euro_accounting_2_precision
    filters: [record_type: "SentForSettle"]
  }

  measure: sum_main_amount_sent_for_refund {
    group_label: "> Amounts Captured"
    type: sum
    description: "Sum Main Amount for Sent for Refund Record Type"
    sql: ${main_amount} ;;
    value_format_name: euro_accounting_2_precision
    filters: [record_type: "SentForRefund"]
  }

  measure: sum_main_amount_authorised {
    group_label: "> Amounts Captured"
    type: sum
    description: "Sum Main Amount for Authorised Record Type"
    sql: ${main_amount} ;;
    value_format_name: euro_accounting_2_precision
    filters: [record_type: "Authorised"]
  }

  measure: percentage_amount_refunded_settled {
    group_label: "> Refunds & Fraud Metrics"
    label: "%  Total Amount Refunded (Settled)"
    type: number
    sql: NULLIF(${sum_main_amount_refunded},0)/NULLIF(${sum_main_amount_settled},0);;
    value_format_name: percent_2
  }

  measure: percentage_amount_refunded_authorised {
    group_label: "> Refunds & Fraud Metrics"
    label: "%  Total Amount Refunded (Authorised)"
    type: number
    sql: NULLIF(${sum_main_amount_refunded},0)/NULLIF(${sum_main_amount_authorised},0);;
    value_format_name: percent_2
  }

  measure: percentage_amount_chargeback_settled {
    group_label: "> Refunds & Fraud Metrics"
    label: "%  Total Amount Refunded (Settled)"
    type: number
    sql: NULLIF(${sum_main_amount_chargebacks},0)/NULLIF(${sum_main_amount_settled},0);;
    value_format_name: percent_2
  }

  measure: percentage_amount_chargeback_authorised {
    group_label: "> Refunds & Fraud Metrics"
    label: "%  Total Amount Refunded (Authorised)"
    type: number
    sql: NULLIF(${sum_main_amount_chargebacks},0)/NULLIF(${sum_main_amount_authorised},0);;
    value_format_name: percent_2
  }

  measure: sum_authorised_pc {
    group_label: "> Amounts Captured"
    type: sum
    sql: ${authorised_pc} ;;
    value_format_name: euro_accounting_2_precision  }

  measure: sum_scheme_fees_sc {
    group_label: "> Fee Amounts"
    type: sum
    sql: ${scheme_fees_sc} ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_markup_sc {
    group_label: "> Fee Amounts"
    type: sum
    sql: ${markup_sc} ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_processing_fee_fc {
    group_label: "> Fee Amounts"
    type: sum
    sql: ${processing_fee_fc} ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_received_pc {
    group_label: "> Fee Amounts"
    type: sum
    sql: ${received_pc} ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_interchange_sc {
    group_label: "> Fee Amounts"
    type: sum
    sql: ${interchange_sc} ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_commission_sc {
    group_label: "> Fee Amounts"
    type: sum
    sql: ${commission_sc} ;;
    value_format_name: euro_accounting_2_precision
    }

  measure: sum_payable_sc {
    group_label: "> Amounts Captured"
    type: sum
    sql: ${payable_sc} ;;
    value_format_name: euro_accounting_2_precision
    }

  measure: sum_captured_pc {
    group_label: "> Amounts Captured"
    type: sum
    sql: ${captured_pc} ;;
    value_format_name: euro_accounting_2_precision
    }

  measure: sum_total_chargeback_fixed_fees {
    group_label: "> Fee Amounts"
    type: sum
    sql: ${markup_sc} + ${scheme_fees_sc};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_total_trx_fees {
    group_label: "> Fee Amounts"
    type: number
    sql: SUM(${commission_sc}) + SUM(${interchange_sc}) + SUM(${markup_sc}) + SUM(${processing_fee_fc}) + SUM(${scheme_fees_sc});;
    value_format_name: euro_accounting_2_precision
  }

  measure: total_trx_fees_percentage_of_gmv {
    group_label: "> Fee Amounts"
    type: number
    sql: NULLIF(${sum_total_trx_fees},0) / NULLIF(${orders.sum_gmv_gross},0);;
    value_format_name: percent_2
    description: "payments processing fees as % of GMV (gross)"
  }

  measure: diff_adyen_ct_filter {
    group_label: "PSP <> CT Comparison"
    type: sum
    hidden: yes
    sql:  (${orders.gmv_gross}-${orders.discount_amount}) - ${main_amount}  ;;
    value_format_name: euro_accounting_2_precision
    description: "CT <> Adyen Filter"
  }

  measure: diff_adyen_ct {
    group_label: "PSP <> CT Comparison"
    type: sum
    hidden: yes
    sql:  ${orders.gmv_gross} - ${main_amount}  ;;
    value_format_name: euro_accounting_2_precision
    description: "CT Orders GMV Gross - Adyen Main Amount"
  }

  measure: cnt_chargebacks_transactions {
    group_label: "> Transaction Totals"
    label: "# Chargebacks"
    type: count_distinct
    sql: ${psp_transaction_uuid} ;;
    filters: [record_type: "Chargeback"]
  }

  measure: cnt_received_transactions {
    group_label: "> Transaction Totals"
    label: "# Received"
    type: count_distinct
    sql: ${psp_transaction_uuid} ;;
    filters: [record_type: "Received"]
  }

  measure: cnt_refused_transactions {
    group_label: "> Transaction Totals"
    label: "# Refused"
    type: count_distinct
    sql: ${psp_transaction_uuid} ;;
    filters: [record_type: "Refused"]
  }

  measure: cnt_cancelled_transactions {
    group_label: "> Transaction Totals"
    label: "# Cancelled"
    type: count_distinct
    sql: ${psp_transaction_uuid} ;;
    filters: [record_type: "Cancelled"]
  }

  measure: cnt_error_transactions {
    group_label: "> Transaction Totals"
    label: "# Error"
    type: count_distinct
    sql: ${psp_transaction_uuid} ;;
    filters: [record_type: "Error"]
  }

  measure: payment_auth_rate {
    group_label: "> Payment Metrics"
    label: "Auth Rate"
    type: number
    sql: nullif(${cnt_authorised_transactions},0) / nullif(${cnt_received_transactions},0) ;;
    value_format_name: percent_2
  }

  measure: payment_settled_auth_rate {
    group_label: "> Payment Metrics"
    label: "Settled-Auth Rate"
    type: number
    sql: nullif(${cnt_settled_transactions},0) / nullif(${cnt_authorised_transactions},0) ;;
    value_format_name: percent_2
  }

  measure: payment_settled_rate {
    group_label: "> Payment Metrics"
    label: "Settled-Received Rate"
    type: number
    sql: nullif(${cnt_settled_transactions},0) / nullif(${cnt_received_transactions},0) ;;
    value_format_name: percent_2
  }

  measure: payment_failure_rate {
    group_label: "> Payment Metrics"
    label: "Failure Rate"
    type: number
    sql: nullif(${cnt_refused_transactions},0) / nullif(${cnt_received_transactions},0) ;;
    value_format_name: percent_2
  }

  measure: payment_cancelled_rate {
    group_label: "> Payment Metrics"
    label: "Cancelled Rate"
    type: number
    sql: nullif(${cnt_cancelled_transactions},0) / nullif(${cnt_received_transactions},0) ;;
    value_format_name: percent_2
  }

  measure: cnt_authorised_transactions {
    group_label: "> Transaction Totals"
    label: "# Authorised"
    type: count_distinct
    sql: ${psp_transaction_uuid} ;;
    filters: [record_type: "Authorised"]
  }

  measure: cnt_distinct_orders {
    group_label: "> Transaction Totals"
    label: "# Orders"
    type: count_distinct
    sql: ${order_uuid} ;;
  }

  measure: order_completion_rate {
    group_label: "> Payment Metrics"
    label: "Order Completion Rate"
    type: number
    sql: ${cnt_distinct_orders}/${cnt_authorised_transactions} ;;
    value_format_name: percent_2
  }

  measure: cnt_refund_transactions {
    group_label: "> Transaction Totals"
    label: "# Refunded"
    description: "# Transaction with Record Type = Refunded or RefundedExternally"
    type: count_distinct
    sql: ${psp_transaction_uuid} ;;
    filters: [record_type: "Refunded,RefundedExternally"]
  }

  measure: cnt_settled_transactions {
    group_label: "> Transaction Totals"
    label: "# Settled"
    type: count_distinct
    sql: ${psp_transaction_uuid} ;;
    filters: [record_type: "Settled"]
  }


  ########### Orphaned Payments
  ####### An orphaned transaction is characterized by:
  ####### 1. either order uuid is missing (we simply couldn't find an order with this PSP reference in CT)
  ####### 2. either we used the cart ID visible in the merchant reference in Adyen to link to the order ID. this is still an orphaned transaction
  ####### as since doesn't appear anywhere in CT.

  measure: sum_empty_order_uuid_settled {
    group_label: "> Orphaned Payments - Empty Orders"
    label: "# Empty Order Transactions - Settled"
    type: sum
    sql:
      case
        when ${is_empty_order_transaction}
          then 1
        else 0
      end;;
    filters: [record_type: "Settled"]
  }

  measure: sum_empty_order_uuid_authorised {
    group_label: "> Orphaned Payments - Empty Orders"
    label: "# Empty Order Transactions - Authorised"
    type: sum
    sql:
      case
        when ${is_empty_order_transaction}
          then 1
        else 0
      end;;
    filters: [record_type: "Authorised"]
  }

  measure: sum_empty_order_uuid_refunded {
    group_label: "> Orphaned Payments - Empty Orders"
    label: "# Empty Order Transactions - Refunded"
    type: sum
    sql:
      case
        when ${is_empty_order_transaction}
          then 1
        else 0
      end;;
    filters: [record_type: "Refunded, RefundedExternally"]
  }

  measure: sum_empty_order_uuid_chargeback {
    group_label: "> Orphaned Payments - Empty Orders"
    label: "# Empty Order Transactions - Chargeback"
    type: sum
    sql:
      case
        when ${is_empty_order_transaction}
          then 1
        else 0
      end;;
    filters: [record_type: "Chargeback"]
  }

  measure: sum_empty_order_trx_fees_refunds {
    group_label: "> Orphaned Payments - Empty Orders"
    label: "€ Total Costs Empty Order Transactions - Refunded"
    description: "Total fees associated with orphaned transactions of type Refunded or RefundedExternally. Considering processing fees for paypal and sum of commision and processing fees for other payment methods. Orphaned Transactions are PSP references that are not linked to any CT order."
    type: sum
    sql:
      case
        when (${is_empty_order_transaction}) and ${payment_method} LIKE 'payp%'
          then ${processing_fee_fc}
        when  ${is_empty_order_transaction}
          then (coalesce(${commission_sc},0) + coalesce(${processing_fee_fc},0)) end ;;
    filters: [record_type: "Refunded, RefundedExternally"]
    value_format_name: eur
  }

  measure: sum_empty_order_trx_fees_chargebacks {
    group_label: "> Orphaned Payments - Empty Orders"
    label: "€ Total Costs Empty Order Transactions - Chargeback"
    description: "Total fees associated with orphaned transactions of type Chargeback or ChargebackReversed. Considering processing fees for paypal and sum of commision and processing fees for other payment methods. Orphaned Transactions are PSP references that are not linked to any CT order."
    type: sum
    sql:
      case
        when ${is_empty_order_transaction} and ${payment_method} LIKE 'payp%'
          then ${processing_fee_fc}
        when  ${is_empty_order_transaction}
          then (coalesce(${commission_sc},0) + coalesce(${processing_fee_fc},0)) end ;;
    filters: [record_type: "Chargeback, ChargebackReversed"]
    value_format_name: eur
  }

  measure: sum_empty_order_amount_authorised {
    group_label: "> Orphaned Payments - Empty Orders"
    label: "€ Total Amount Empty Order Transactions - Authorised"
    description: "Sum of the main amount coming from orphaned transactions of type Authorised. Orphaned Transactions are PSP references that are not linked to any CT order."
    type: sum
    sql:
      case
        when ${is_empty_order_transaction}
          then ${main_amount}
        else 0
      end;;
    filters: [record_type: "Authorised"]
    value_format_name: eur
  }

  measure: sum_empty_order_amount_settled {
    group_label: "> Orphaned Payments - Empty Orders"
    label: "€ Total Amount Empty Order Transactions - Settled"
    description: "Sum of the main amount coming from orphaned transactions of type Settled. Orphaned Transactions are PSP references that are not linked to any CT order."
    type: sum
    sql:
      case
        when ${is_empty_order_transaction}
          then ${main_amount}
        else 0
      end;;
    filters: [record_type: "Settled"]
    value_format_name: eur
  }

  measure: sum_empty_order_amount_refunded {
    group_label: "> Orphaned Payments - Empty Orders"
    label: "€ Total Amount Empty Order Transactions - Refunded"
    description: "Sum of the main amount coming from orphaned transactions of type Refunded or Refunded Externally. Orphaned Transactions are PSP references that are not linked to any CT order."
    type: sum
    sql:
      case
        when ${is_empty_order_transaction}
          then ${main_amount}
        else 0
      end;;
    filters: [record_type: "Refunded, RefundedExternally"]
    value_format_name: eur
  }

  measure: sum_empty_order_amount_chargeback {
    group_label: "> Orphaned Payments - Empty Orders"
    label: "€ Total Amount Empty Order Transactions - Chargeback"
    description: "Sum of the main amount coming from orphaned transactions of type Chargeback or ChargebackReversed . Orphaned Transactions are PSP references that don't appear in any CT order."
    type: sum
    sql:
      case
        when ${is_empty_order_transaction}
          then ${main_amount}
        else 0
      end;;
    filters: [record_type: "Chargeback, ChargebackReversed"]
    value_format_name: eur
  }

  measure: percentage_trx_without_orders_authorised {
    group_label: "> Orphaned Payments - Empty Orders"
    label: "% Empty Order Transactions - Authorised"
    type: number
    sql: NULLIF(${sum_empty_order_uuid_authorised},0)/NULLIF(${cnt_authorised_transactions},0);;
    value_format_name: percent_3
  }

  measure: percentage_trx_without_orders_settled {
    group_label: "> Orphaned Payments - Empty Orders"
    label: "% Empty Order Transactions - Settled"
    type: number
    sql: NULLIF(${sum_empty_order_uuid_settled},0)/NULLIF(${cnt_settled_transactions},0);;
    value_format_name: percent_3
  }

  measure: percentage_trx_without_orders_refunded {
    group_label: "> Orphaned Payments - Empty Orders"
    label: "% Empty Order Transactions - Refunded"
    type: number
    sql: NULLIF(${sum_empty_order_uuid_refunded},0)/NULLIF(${cnt_refund_transactions},0);;
    value_format_name: percent_2
  }

  measure: percentage_trx_without_orders_chargeback {
    group_label: "> Orphaned Payments - Empty Orders"
    label: "% Empty Order Transactions - Chargeback"
    type: number
    sql: NULLIF(${sum_empty_order_uuid_chargeback},0)/NULLIF(${cnt_chargebacks_transactions},0);;
    value_format_name: percent_2
  }

  ############## Orphaned Double Payments

  measure: sum_orphaned_double_payment_settled {
    group_label: "> Orphaned Payments - Double Payments"
    label: "# Orphaned Double Payments - Settled"
    description: "Number of transactions of type Settled associated with an order in CT but which were not recorded in CT. They were match to their corresponding CT order using Adyen’s merchant reference that contains CT cart id."
    type: sum
    sql:
      case
        when ${is_orphaned_double_payment_transaction}
          then 1
        else 0
      end;;
    filters: [record_type: "Settled"]
  }

  measure: sum_orphaned_double_payment_authorised {
    group_label: "> Orphaned Payments - Double Payments"
    label: "# Orphaned Double Payments - Authorised"
    description: "Number of transactions of type Authorised associated with an order in CT but which were not recorded in CT. They were match to their corresponding CT order using Adyen’s merchant reference that contains CT cart id."
    type: sum
    sql:
      case
        when ${is_orphaned_double_payment_transaction}
          then 1
        else 0
      end;;
    filters: [record_type: "Authorised"]
  }

  measure: sum_orphaned_double_payment_refunded {
    group_label: "> Orphaned Payments - Double Payments"
    label: "# Orphaned Double Payments - Refunded"
    description: "Number of transactions of type Refunded or Refunded Externally associated with an order in CT but which were not recorded in CT. They were match to their corresponding CT order using Adyen’s merchant reference that contains CT cart id."
    type: sum
    sql:
      case
        when ${is_orphaned_double_payment_transaction}
          then 1
        else 0
      end;;
    filters: [record_type: "Refunded, RefundedExternally"]
  }

  measure: sum_orphaned_double_payment_chargeback {
    group_label: "> Orphaned Payments - Double Payments"
    label: "# Orphaned Double Payments - Chargeback"
    description: "Number of transactions of type Chargeback or ChargebackReversed associated with an order in CT but which were not recorded in CT. They were match to their corresponding CT order using Adyen’s merchant reference that contains CT cart id."
    type: sum
    sql:
      case
        when ${is_orphaned_double_payment_transaction}
          then 1
        else 0
      end;;
    filters: [record_type: "Chargeback"]
  }

  measure: sum_orphaned_double_payment_trx_fees_refunds {
    group_label: "> Orphaned Payments - Double Payments"
    label: "€ Total Costs Orphaned Double Payments - Refunded"
    description: "Total fees associated with Orphaned Double Payment Transactions of type Refunded or RefundedExternally. Considering processing fees for paypal and sum of commision and processing fees for other payment methods. Orphaned Double Payments Transactions are PSP references that were not recorded in CT. They were match to their corresponding CT order using Adyen’s merchant reference that contains CT cart id."
    type: sum
    sql:
      case
        when (${is_orphaned_double_payment_transaction}) and ${payment_method} LIKE 'payp%'
          then ${processing_fee_fc}
        when  ${is_orphaned_double_payment_transaction}
          then (coalesce(${commission_sc},0) + coalesce(${processing_fee_fc},0)) end ;;
    filters: [record_type: "Refunded, RefundedExternally"]
    value_format_name: eur
  }

  measure: sum_orphaned_double_payment_trx_fees_chargebacks {
    group_label: "> Orphaned Payments - Double Payments"
    label: "€ Total Costs Orphaned Double Payments - Chargeback"
    description: "Total fees associated with Orphaned Double Payment Transactions of type Chargeback or ChargebackReversed. Considering processing fees for paypal and sum of commision and processing fees for other payment methods. Orphaned Double Payments Transactions are PSP references that were not recorded in CT. They were match to their corresponding CT order using Adyen’s merchant reference that contains CT cart id."
    type: sum
    sql:
      case
        when ${is_orphaned_double_payment_transaction} and ${payment_method} LIKE 'payp%'
          then ${processing_fee_fc}
        when  ${is_orphaned_double_payment_transaction}
          then (coalesce(${commission_sc},0) + coalesce(${processing_fee_fc},0)) end ;;
    filters: [record_type: "Chargeback, ChargebackReversed"]
    value_format_name: eur
  }

  measure: sum_orphaned_double_payment_amount_authorised {
    group_label: "> Orphaned Payments - Double Payments"
    label: "€ Total Amount Orphaned Double Payments - Authorised"
    description: "Sum of the main amount coming from Orphaned Double Payment Transactions of type Authorised. Orphaned Double Payments Transactions are PSP references that were not recorded in CT. They were match to their corresponding CT order using Adyen’s merchant reference that contains CT cart id."
    type: sum
    sql:
      case
        when ${is_orphaned_double_payment_transaction}
          then ${main_amount}
        else 0
      end;;
    filters: [record_type: "Authorised"]
    value_format_name: eur
  }

  measure: sum_orphaned_double_payment_amount_settled {
    group_label: "> Orphaned Payments - Double Payments"
    label: "€ Total Amount Orphaned Double Payments - Settled"
    description: "Sum of the main amount coming from Orphaned Double Payment Transactions of type Settled. Orphaned Double Payments Transactions are PSP references that were not recorded in CT. They were match to their corresponding CT order using Adyen’s merchant reference that contains CT cart id."
    type: sum
    sql:
      case
        when ${is_orphaned_double_payment_transaction}
          then ${main_amount}
        else 0
      end;;
    filters: [record_type: "Settled"]
    value_format_name: eur
  }

  measure: sum_orphaned_double_payment_amount_refunded {
    group_label: "> Orphaned Payments - Double Payments"
    label: "€ Total Amount Orphaned Double Payments - Refunded"
    description: "Sum of the main amount coming from Orphaned Double Payment Transactions of type Refunded or Refunded Externally. Orphaned Double Payments Transactions are PSP references that were not recorded in CT. They were match to their corresponding CT order using Adyen’s merchant reference that contains CT cart id."
    type: sum
    sql:
      case
        when ${is_orphaned_double_payment_transaction}
          then ${main_amount}
        else 0
      end;;
    filters: [record_type: "Refunded, RefundedExternally"]
    value_format_name: eur
  }

  measure: sum_orphaned_double_payment_amount_chargeback {
    group_label: "> Orphaned Payments - Double Payments"
    label: "€ Total Amount Orphaned Double Payments - Chargeback"
    description: "Sum of the main amount coming from orphaned transactions of type Chargeback or ChargebackReversed .Orphaned Double Payments Transactions are PSP references that were not recorded in CT. They were match to their corresponding CT order using Adyen’s merchant reference that contains CT cart id."
    type: sum
    sql:
      case
        when ${is_orphaned_double_payment_transaction}
          then ${main_amount}
        else 0
      end;;
    filters: [record_type: "Chargeback, ChargebackReversed"]
    value_format_name: eur
  }

  measure: percentage_trx_orphaned_double_payments_authorised {
    group_label: "> Orphaned Payments - Double Payments"
    label: "% Orphaned Double Payments - Authorised"
    description: "Number of Orphaned Double Payment Transactions of type Authorised divided by all transactions of type Authorised"
    type: number
    sql: NULLIF(${sum_orphaned_double_payment_authorised},0)/NULLIF(${cnt_authorised_transactions},0);;
    value_format_name: percent_3
  }

  measure: percentage_trx_orphaned_double_payment_settled {
    group_label: "> Orphaned Payments - Double Payments"
    label: "% Orphaned Double Payments - Settled"
    description: "Number of Orphaned Double Payment Transactions of type Settled divided by all transactions of type Settled"
    type: number
    sql: NULLIF(${sum_orphaned_double_payment_settled},0)/NULLIF(${cnt_settled_transactions},0);;
    value_format_name: percent_3
    }

    measure: percentage_trx_orphaned_double_payment_refunded {
    group_label: "> Orphaned Payments - Double Payments"
    label: "% Orphaned Double Payments - Refunded"
    description: "Number of Orphaned Double Payment Transactions of type Refunded or RefundedExternally divided by all transactions of type Refunded or RefundedExternally"
    type: number
    sql: NULLIF(${sum_orphaned_double_payment_refunded},0)/NULLIF(${cnt_refund_transactions},0);;
    value_format_name: percent_2
    }

    measure: percentage_trx_orphaned_double_payment_chargeback {
    group_label: "> Orphaned Payments - Double Payments"
    label: "% Orphaned Double Payments - Chargeback"
    description: "Number of Orphaned Double Payment Transactions of type Chargeback or ChargebackReversed divided by all transactions of type Chargeback or ChargebackReversed"
    type: number
    sql: NULLIF(${sum_orphaned_double_payment_chargeback},0)/NULLIF(${cnt_chargebacks_transactions},0);;
    value_format_name: percent_2
  }


  ############## ALL Orphaned Payments

  measure: sum_all_orphaned_payment_settled {
    group_label: "> Orphaned Payments - All"
    label: "# Total Orphaned Payments - Settled"
    description: "Number of Orphaned transactions of type Settled. Include both Empty Order Orphaned Transactions and Double Payment Orphaned Transactions."
    type: sum
    sql:
      case
        when ${is_orphaned_transaction}
          then 1
        else 0
      end;;
    filters: [record_type: "Settled"]
  }

  measure: sum_all_orphaned_payment_authorised {
    group_label: "> Orphaned Payments - All"
    label: "# Total Orphaned Payments - Authorised"
    description: "Number of Orphaned transactions of type Authorised. Include both Empty Order Orphaned Transactions and Double Payment Orphaned Transactions."
    type: sum
    sql:
      case
        when ${is_orphaned_transaction}
          then 1
        else 0
      end;;
    filters: [record_type: "Authorised"]
  }

  measure: sum_all_orphaned_payment_refunded {
    group_label: "> Orphaned Payments - All"
    label: "# Total Orphaned Payments - Refunded"
    description: "Number of Orphaned transactions of type Refunded or Refunded Externally. Include both Empty Order Orphaned Transactions and Double Payment Orphaned Transactions."
    type: sum
    sql:
      case
        when ${is_orphaned_transaction}
          then 1
        else 0
      end;;
    filters: [record_type: "Refunded, RefundedExternally"]
  }

  measure: sum_all_orphaned_payment_chargeback {
    group_label: "> Orphaned Payments - All"
    label: "# Total Orphaned Payments - Chargeback"
    description: "Number of Orphaned transactions of type Chargeback or ChargebackReversed. Include both Empty Order Orphaned Transactions and Double Payment Orphaned Transactions."
    type: sum
    sql:
      case
        when ${is_orphaned_transaction}
          then 1
        else 0
      end;;
    filters: [record_type: "Chargeback"]
  }

  measure: sum_all_orphaned_payment_trx_fees_refunds {
    group_label: "> Orphaned Payments - All"
    label: "€ Total Costs Orphaned Payments - Refunded"
    description: "Total fees associated with Total Orphaned Transactions of type Refunded or RefundedExternally. Considering processing fees for paypal and sum of commission and processing fees for other payment methods.Include both Empty Order Orphaned Transactions and Double Payment Orphaned Transactions."
    type: sum
    sql:
      case
        when (${is_orphaned_transaction}) and ${payment_method} LIKE 'payp%'
          then ${processing_fee_fc}
        when  ${is_orphaned_transaction}
          then (coalesce(${commission_sc},0) + coalesce(${processing_fee_fc},0)) end ;;
    filters: [record_type: "Refunded, RefundedExternally"]
    value_format_name: eur
  }

  measure: sum_all_orphaned_payment_trx_fees_chargebacks {
    group_label: "> Orphaned Payments - All"
    label: "€ Total Costs Orphaned Payments - Chargeback"
    description: "Total fees associated with Total Orphaned Transactions of type Chargeback or ChargebackReversed. Considering processing fees for paypal and sum of commision and processing fees for other payment methods. Include both Empty Order Orphaned Transactions and Double Payment Orphaned Transactions."
    type: sum
    sql:
      case
        when ${is_orphaned_transaction} and ${payment_method} LIKE 'payp%'
          then ${processing_fee_fc}
        when  ${is_orphaned_transaction}
          then (coalesce(${commission_sc},0) + coalesce(${processing_fee_fc},0)) end ;;
    filters: [record_type: "Chargeback, ChargebackReversed"]
    value_format_name: eur
  }

  measure: sum_all_orphaned_payment_amount_authorised {
    group_label: "> Orphaned Payments - All"
    label: "€ Total Amount Orphaned Payments - Authorised"
    description: "Sum of the main amount coming from Total Orphaned Transactions of type Authorised. Include both Empty Order Orphaned Transactions and Double Payment Orphaned Transactions."
    type: sum
    sql:
      case
        when ${is_orphaned_transaction}
          then ${main_amount}
        else 0
      end;;
    filters: [record_type: "Authorised"]
    value_format_name: eur
  }

  measure: sum_all_orphaned_payment_amount_settled {
    group_label: "> Orphaned Payments - All"
    label: "€ Total Amount Orphaned Payments - Settled"
    description: "Sum of the main amount coming from Total Orphaned Transactions of type Settled. Include both Empty Order Orphaned Transactions and Double Payment Orphaned Transactions."
    type: sum
    sql:
      case
        when ${is_orphaned_transaction}
          then ${main_amount}
        else 0
      end;;
    filters: [record_type: "Settled"]
    value_format_name: eur
  }

  measure: sum_all_orphaned_payment_amount_refunded {
    group_label: "> Orphaned Payments - All"
    label: "€ Total Amount Orphaned Payments - Refunded"
    description: "Sum of the main amount coming from Total Orphaned Transactions of type Refunded or Refunded Externally. Include both Empty Order Orphaned Transactions and Double Payment Orphaned Transactions."
    type: sum
    sql:
      case
        when ${is_orphaned_transaction}
          then ${main_amount}
        else 0
      end;;
    filters: [record_type: "Refunded, RefundedExternally"]
    value_format_name: eur
  }

  measure: sum_all_orphaned_payment_amount_chargeback {
    group_label: "> Orphaned Payments - All"
    label: "€ Total Amount Orphaned Payments - Chargeback"
    description: "Sum of the main amount coming from Total Orphaned Transactions of type Chargeback or ChargebackReversed. Include both Empty Order Orphaned Transactions and Double Payment Orphaned Transactions."
    type: sum
    sql:
      case
        when ${is_orphaned_transaction}
          then ${main_amount}
        else 0
      end;;
    filters: [record_type: "Chargeback, ChargebackReversed"]
    value_format_name: eur
  }

  measure: percentage_trx_all_orphaned_payment_authorised {
    group_label: "> Orphaned Payments - All"
    label: "% Total Orphaned Payments - Authorised"
    description: "Number of Total Orphaned Payment Transactions of type Authorised divided by all Transactions of type Authorised. Include both Empty Order Orphaned Transactions and Double Payment Orphaned Transactions."
    type: number
    sql: NULLIF(${sum_all_orphaned_payment_authorised},0)/NULLIF(${cnt_authorised_transactions},0);;
    value_format_name: percent_3
  }

  measure: percentage_trx_all_orphaned_payment_settled {
    group_label: "> Orphaned Payments - All"
    label: "% Total Orphaned Payments - Settled"
    description: "Number of Total Orphaned Payment Transactions of type Settled divided by all Transactions of type Settled. Include both Empty Order Orphaned Transactions and Double Payment Orphaned Transactions."
    type: number
    sql: NULLIF(${sum_all_orphaned_payment_settled},0)/NULLIF(${cnt_settled_transactions},0);;
    value_format_name: percent_3
  }

  measure: percentage_trx_all_orphaned_payment_refunded {
    group_label: "> Orphaned Payments - All"
    label: "% Total Orphaned Payments - Refunded"
    description: "Number of Total Orphaned Payment Transactions of type Refunded or RefundedExternally divided by all Transactions of type Refunded or RefundedExternally. Include both Empty Order Orphaned Transactions and Double Payment Orphaned Transactions."
    type: number
    sql: NULLIF(${sum_all_orphaned_payment_refunded},0)/NULLIF(${cnt_refund_transactions},0);;
    value_format_name: percent_2
  }

  measure: percentage_trx_all_orphaned_payment_chargeback {
    group_label: "> Orphaned Payments - All"
    label: "% Total Orphaned Payments - Chargeback"
    description: "Number of Orphaned Double Payment Transactions of type Chargeback or ChargebackReversed divided by all transactions of type Chargeback or ChargebackReversed. Include both Empty Order Orphaned Transactions and Double Payment Orphaned Transactions."
    type: number
    sql: NULLIF(${sum_all_orphaned_payment_chargeback},0)/NULLIF(${cnt_chargebacks_transactions},0);;
    value_format_name: percent_2
  }


  ############### Refunds & Fraud

  measure: percentage_transactions_refunded_auth {
    group_label: "> Refunds & Fraud Metrics"
    label: "% Orders Refunded (Authorised)"
    type: number
    sql: NULLIF(${cnt_refund_transactions},0)/NULLIF(${cnt_authorised_transactions},0);;
    value_format_name: percent_2
  }

  measure: percentage_transactions_refunded_set {
    group_label: "> Refunds & Fraud Metrics"
    label: "% Orders Refunded (Settled)"
    type: number
    sql: NULLIF(${cnt_refund_transactions},0)/NULLIF(${cnt_settled_transactions},0);;
    value_format_name: percent_2
  }

  measure: percentage_transactions_chargeback_auth {
    group_label: "> Refunds & Fraud Metrics"
    label: "% Orders Chargeback (Authorised)"
    type: number
    sql: NULLIF(${cnt_chargebacks_transactions},0)/NULLIF(${cnt_authorised_transactions},0);;
    value_format_name: percent_2
  }

  measure: percentage_transactions_chargeback_set {
    group_label: "> Refunds & Fraud Metrics"
    label: "% Orders Chargeback (Settled)"
    type: number
    sql: NULLIF(${cnt_chargebacks_transactions},0)/NULLIF(${cnt_settled_transactions},0);;
    value_format_name: percent_2
  }

  measure: count {
    group_label: "> Transaction Totals"
    type: count
    drill_fields: [user_name]
  }

  dimension: captured_refunded_pc {
    label: "Refunded Transactions Amount"
    hidden: yes
    sql: case when record_type in ("Refunded","RefundedExternally") then ${captured_pc} end ;;
    value_format_name: euro_accounting_2_precision
  }

  dimension: authorised_authorised_pc {
    label:  "Authorised Transactions Amount"
    hidden: yes
    sql: case when record_type in ("Authorised") then ${authorised_pc} end ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: diff_authorised_refunded {
    group_label: "> Refunds & Fraud Metrics"
    type: sum
    sql: ${authorised_authorised_pc} - ${captured_refunded_pc}  ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: avg_amt_risk_scoring {
    group_label: "> Fraud"
    label: "AVG Risk Scoring"
    type: average
    description: "AVG total risk scoring value of the payment."
    sql: ${amt_risk_scoring} ;;
    value_format_name: decimal_2
  }

  measure: number_of_transactions_with_fraud_risk {
    group_label: "> Fraud"
    label: "# Transactions with Fraud Risk"
    type: count_distinct
    sql: ${psp_reference} ;;
    filters: [amt_risk_scoring: ">0"]
  }
}
