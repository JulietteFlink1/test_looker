### Author: Justine Grammatikas
### Created: 2022-09-14

### This NDT aggregates psp transaction data on payment level in order to flag full refund payments
### Full Refund payments have an equal Debit (Refunded, RefundedExternally or Chargeback transactions)
### and Credit (Authorised) amounts. This will help excluding these payments when checking the total
### Authorised amount for one order.

view: ndt_psp_transactions__payment_id_aggregated {
    derived_table: {
    #  datagroup_trigger: flink_default_datagroup
      explore_source: psp_transactions {
        column: payment_id { field: psp_transactions.payment_id}
        column: sum_gross_credit_gc { field: psp_settlement_details.sum_gross_credit_gc }
        column: sum_gross_debit_gc { field: psp_settlement_details.sum_gross_debit_gc }
        column: order_uuid { field: orders.order_uuid }
        column: order_date { field: orders.created_date }
        column: psp_transactions_booking_date { field: psp_transactions.booking_date }
        column: psp_settlement_booking_date { field: psp_settlement_details.booking_date }

        filters: {
          field: psp_transactions.record_type
          value: "Authorised,Refunded,RefundedExternally,Chargeback"
        }
        filters: {
          field: psp_settlement_details.booking_date
          value: "last 3 years"
        }
        filters: {
          field: psp_transactions.booking_date
          value: "last 3 years"
        }
        filters: {
          field: orders.created_date
          value: "last 3 years"
        }
        bind_filters: {
          to_field: global_filters_and_parameters.datasource_filter
          from_field: ndt_psp_transactions__duplicated_psp_references.order_date
        }
        bind_filters: {
          to_field: global_filters_and_parameters.datasource_filter
          from_field: ndt_psp_transactions__duplicated_psp_references.psp_transactions_booking_date
        }
        bind_filters: {
          to_field: global_filters_and_parameters.datasource_filter
          from_field: ndt_psp_transactions__duplicated_psp_references.psp_settlement_booking_date
        }
      }
    }

    dimension: payment_id {
      label: "PSP Transactions Payment ID"
      description: "CT Payment ID"
      primary_key: yes
      hidden: yes
    }

    dimension: sum_gross_credit_gc {
      label: "PSP Settlement SUM Gross Credit (GC)"
      hidden: yes
      description: "Amount submitted in the transaction request."
      type: number
    }

    dimension: sum_gross_debit_gc {
      label: "PSP Settlement SUM Gross Debit (GC)"
      description: "Amount submitted in the transaction request."
      hidden: yes
      type: number
    }

    dimension: psp_transactions_booking_date {
      hidden: yes
      type: date
    }

    dimension: psp_settlement_booking_date {
      hidden: yes
      type: date
    }

    dimension: order_date {
      hidden: yes
      type: date
    }

    dimension: order_uuid {
      label: "Orders Order UUID"
      description: "country iso concatenated with CT order id"
      hidden: yes
    }

    dimension: is_full_refund_payment {
      type: yesno
      sql: ${sum_gross_credit_gc} = ${sum_gross_debit_gc} ;;
      group_label: "> Transaction Properties"
      description: "Flags if the payment ID is a full refund payment. Checks if the Authorised amount is equal to the Refunded Amount for the payment."
    }
  }
