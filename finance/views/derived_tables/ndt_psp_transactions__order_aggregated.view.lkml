### Author: Justine Grammatikas
### Created: 2022-09-14

### This NDT aggregates psp transaction data on order level in order to flag orders
### that have a different GPV (Gross Payment Value, what the customer should have paid in CT)
### and Adyen paid amount (based on the Settled Credit amount found in Adyen Settlement Report.)
### In some cases customer actually pays more than what he.she should have, in other cases less.

view: ndt_psp_transactions__order_aggregated {
    derived_table: {
      explore_source: psp_transactions {
        column: order_uuid { field: orders.order_uuid }
        column: sum_gpv_gross { field: orders.sum_gpv_gross }
        column: sum_gross_credit_gc { field: psp_settlement_details.sum_gross_credit_gc }
        filters: {
          field: ndt_psp_transactions__payment_id_aggregated.is_full_refund_payment
          value: "No"
        }
        filters: {
          field: psp_settlement_details.type
          value: "Settled"
        }
      }
    }
    dimension: order_uuid {
      label: "Orders Order UUID"
      description: ""
      hidden: yes
    }
    dimension: sum_gpv_gross {
      label: "Orders SUM GPV (Gross)"
      description: "Actual amount paid by the customer in CT. Sum of Delivery & Storage Fees, Items Price, Tips, Deposit. Excl. Donations. After Deduction of Cart and Product Discounts. Incl. VAT"
      hidden: yes
      type: number
    }
    dimension: sum_gross_credit_gc {
      label: "PSP Settlement SUM Gross Credit (GC)"
      description: "Amount submitted in the transaction request."
      hidden: yes
      type: number
    }
    dimension: is_CT_above_adyen_amount {
      type: yesno
      group_label: "> Transaction Properties"
      description: "Flags if the GPV visible in CT is higher than the Settled amount paid via Adyen. We exclude full refund payments here."
      sql:
          case
              when ${sum_gross_credit_gc} < ${sum_gpv_gross}
                  then
                      true
              else
                  false
          end
      ;;
    }
    dimension: is_adyen_above_CT_amount {
      group_label: "> Transaction Properties"
      description: "Flags if the Adyen Settled amount is higher than the GPV in CT. We exclude full refund payments here."
      type: yesno
      sql:
            case
                when ${sum_gross_credit_gc} > ${sum_gpv_gross}
                    then
                        true
                else
                    false
            end
        ;;
        }
    dimension: is_adyen_different_CT_amount {
      group_label: "> Transaction Properties"
      label: "Is CT <> Adyen"
      description: "Flags if the Adyen Settled amount is different from the GPV in CT. We exclude full refund payments here."
      type: yesno
      sql:
            case
                when ${sum_gross_credit_gc} <> ${sum_gpv_gross}
                    then
                        true
                else
                    false
            end
        ;;
    }
  }
