view: psp_settlement_details {
  sql_table_name: `flink-data-prod.curated.psp_settlement_details`
    ;;

  dimension_group: authorised_date {
    type: time
    group_label: "> Dates & Timestamps "
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    hidden: yes
    convert_tz: no
    datatype: date
    sql: ${TABLE}.authorised_date ;;
  }

  dimension_group: authorised {
    group_label: "> Dates & Timestamps "
    type: time
    timeframes: [
      time,
      date,
      week,
      month,
      year
    ]
    sql: ${TABLE}.authorised_timestamp ;;
  }

  dimension: batch_number {
    group_label: "> IDs & Reference"
    description: "Sequence number of the settlement."
    type: number
    sql: ${TABLE}.batch_number ;;
  }

  dimension_group: booking_date {
    group_label: "> Dates & Timestamps "
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    hidden: yes
    convert_tz: no
    datatype: date
    sql: ${TABLE}.booking_date ;;
  }

  dimension_group: booking {
    group_label: "> Dates & Timestamps "
    description: "Timestamp indicating when the transaction was booked into the payable balance."
    type: time
    timeframes: [
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.booking_timestamp ;;
  }

  dimension: commission_nc {
    hidden: yes

    type: number
    sql: ${TABLE}.commission_nc ;;
  }

  dimension: company_account {
    group_label: "> Geography"
    type: string
    sql: ${TABLE}.company_account ;;
  }

  dimension: country_iso {
    group_label: "> Geography"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension_group: creation_date {
    group_label: "> Dates & Timestamps "
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    hidden: yes
    convert_tz: no
    datatype: date
    sql: ${TABLE}.creation_date ;;
  }

  dimension_group: creation {
    group_label: "> Dates & Timestamps "
    description: " Time field Time stamp indicating when the capture was received by Adyen."
    type: time
    timeframes: [
      time,
      date,
      week,
      month,
      year
    ]
    sql: ${TABLE}.creation_timestamp ;;
  }

  dimension: exchange_rate {
    group_label: "> Currency"
    description: "Exchange rate used for converting the gross amount into the net amount.
                  This will be 1 if you process and settle in the same currency."
    type: number
    sql: ${TABLE}.exchange_rate ;;
  }

  dimension: gross_credit_gc {
    hidden: yes
    type: number
    sql: ${TABLE}.gross_credit_gc ;;
  }

  dimension: gross_currency {
    label: "Currency"
    group_label: "> Currency"
    description: "Three character ISO code for the currency which was used for processing the payment (transaction currency)."
    type: string
    sql: ${TABLE}.gross_currency ;;
  }

  dimension: gross_debit_gc {
    hidden: yes
    type: number
    sql: ${TABLE}.gross_debit_gc ;;
  }

  dimension: interchange_nc {
    hidden: yes
    type: number
    sql: ${TABLE}.interchange_nc ;;
  }

  dimension: markup_nc {
    type: number
    hidden: yes
    sql: ${TABLE}.markup_nc ;;
  }

  dimension: merchant_account {
    group_label: "> Geography"
    type: string
    sql: ${TABLE}.merchant_account ;;
  }

  dimension: merchant_reference {
    group_label:"> IDs & Reference"
    type: string
    sql: ${TABLE}.merchant_reference ;;
  }

  dimension: modification_merchant_reference {
    group_label:"> IDs & Reference"
    description: "Reference number provided when initiating the modification request."
    type: string
    sql: ${TABLE}.modification_merchant_reference ;;
  }

  dimension: modification_reference {
    group_label:"> IDs & Reference"
    description: "For entries of Type Settled, Refunded, Chargebacks, this is the modification PSP reference, a unique ID that identifies the modification request.
    For records of Type MerchantPayout, this is a text description containing Account code, batch number and the unique payout reference (TX...XT), which can also be found on the bank statement."
    type: string
    sql: ${TABLE}.modification_reference ;;
  }

  dimension: net_credit_nc {
    description: "Amount submitted in the transaction request minus transaction costs and fees."
    type: number
    hidden: yes
    sql: ${TABLE}.net_credit_nc ;;
  }

  dimension: net_currency {
    type: string
    hidden: yes
    sql: ${TABLE}.net_currency ;;
  }

  dimension: net_debit_nc {
    description: "Net amount debited from the Payable. For example, for a Refunded booking, this is the amount sent as part of the refund request plus any additional costs withheld."
    type: number
    hidden: yes
    sql: ${TABLE}.net_debit_nc ;;
  }

  dimension: order_uuid {
    group_label:"> IDs & Reference"
    type: string
    sql: ${TABLE}.order_uuid ;;
  }

  dimension: payment_method {
    group_label:"> Payment Methods"
    description: "Payment method type of the payment which was processed."
    type: string
    sql: ${TABLE}.payment_method ;;
  }

  dimension: payment_method_variant {
    group_label:"> Payment Methods"
    description: "Sub-brand of the payment method (if applicable).
                  For example: visaclassic, visadebit, mccorporate."
    type: string
    sql: ${TABLE}.payment_method_variant ;;
  }

  dimension: psp_reference {
    group_label:"> IDs & Reference"
    description: "Adyen's 16-character unique reference associated with the transaction. This is the pspReference from the response to the original payment request."
    type: string
    sql: ${TABLE}.psp_reference ;;
  }

  dimension: psp_settlement_detail_uuid {
    hidden: yes
    primary_key: yes
    type: string
    sql: ${TABLE}.psp_settlement_detail_uuid ;;
  }

  dimension: scheme_fees_nc {
    type: number
    hidden: yes
    sql: ${TABLE}.scheme_fees_nc ;;
  }

  dimension: timezone {
    type: string
    hidden: yes
    sql: ${TABLE}.timezone ;;
  }

  dimension: type {
    group_label:"> Transaction Type"
    description: "The Journal type of the entry."
    type: string
    sql: ${TABLE}.type ;;
  }

  ######### Measures

  measure: sum_gross_credit_gc {
    type: sum
    group_label: "> Amounts"
    label: "SUM Gross Credit (GC)"
    description: "Amount submitted in the transaction request."
    sql: ${gross_credit_gc} ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_gross_debit_gc {
    type: sum
    label: "SUM Gross Debit (GC)"
    group_label: "> Amounts"
    description: "Amount submitted in the transaction request."
    sql: ${gross_debit_gc} ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_commission_nc {
    label: "SUM Commission (NC)"
    type: sum
    group_label: "> Amounts"
    description: "  The commission fee that was withheld by the acquirer. This should be the difference between the gross and net amounts.
                    If the Acquirer provides the transaction information at interchange level Adyen, splits the commission into:
                    - Markup
                    - Scheme Fees
                    - Interchange."
    sql: ${commission_nc} ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_net_credit_nc {
    label: "SUM Net Credit (NC)"
    type: sum
    group_label: "> Amounts"
    description: "Amount submitted in the transaction request minus transaction costs and fees."
    sql: ${net_credit_nc} ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_net_debit_nc {
    label: "SUM Net Debit (NC)"
    type: sum
    group_label: "> Amounts"
    description: "Net amount debited from the Payable. For example, for a Refunded booking, this is the amount sent as part of the refund request plus any additional costs withheld."
    sql: ${net_debit_nc} ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_markup_nc {
    label: "SUM Markup (NC)"
    type: sum
    group_label: "> Fees"
    description: "Fee charged by the Acquiring bank. If the Acquirer does not provide the transaction information at the interchange level, this field is empty."
    sql: ${markup_nc} ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_scheme_fees_nc {
    label: "SUM Scheme Fees (NC)"
    type: sum
    group_label: "> Fees"
    description: "Fee which is charged by Visa / MC. If the Acquirer does not provide the transaction information at the interchange level, this field is empty."
    sql: ${scheme_fees_nc} ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_interchange_nc {
    label: "SUM Interchange (NC)"
    type: sum
    group_label: "> Fees"
    description: "Fee charged by the Issuing bank. If the Acquirer does not provide the transaction information at the interchange level, this field is empty."
    sql: ${interchange_nc} ;;
    value_format_name: euro_accounting_2_precision
  }


  measure: count {
    type: count
    drill_fields: []
  }
}
