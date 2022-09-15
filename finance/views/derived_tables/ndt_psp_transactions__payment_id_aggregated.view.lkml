### Author: Justine Grammatikas
### Created: 2022-09-14

### This NDT aggregates psp transaction data on payment level in order to flag full refund payments
### Full Refund payments have an equal Debit (Refunded, RefundedExternally or Chargeback transactions)
### and Credit (Authorised) amounts. This will help excluding these payments when checking the total
### Authorised amount for one order.

view: ndt_psp_transactions__payment_id_aggregated {
    derived_table: {
      explore_source: psp_transactions {
        column: payment_id {}
        column: sum_gross_credit_gc { field: psp_settlement_details.sum_gross_credit_gc }
        column: sum_gross_debit_gc { field: psp_settlement_details.sum_gross_debit_gc }
        column: order_uuid { field: orders.order_uuid }
        filters: {
          field: psp_transactions.record_type
          value: "Authorised,Refunded,RefundedExternally,Chargeback"
        }
      }
    }
    dimension: payment_id {
      label: "PSP Transactions Payment ID"
      description: ""
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
    dimension: order_uuid {
      label: "Orders Order UUID"
      description: ""
      hidden: yes
    }
    dimension: is_full_refund_payment {
      type: yesno
      sql:
          case
              when ${sum_gross_credit_gc} = ${sum_gross_debit_gc}
                  then
                      true
              else
                  false
          end
      ;;
      group_label: "> Transaction Properties"
      description: "Flags if the payment ID is a full refund payment. Checks if the Authorised amount is equal to the Refunded Amount for the payment."
    }
  }
