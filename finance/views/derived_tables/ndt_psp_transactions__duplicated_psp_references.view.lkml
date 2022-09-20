## Author: Justine Grammatikas
## Created: 2022-09-12

## This view aggregates # Orders on PSP reference granularity. It creates a Boolean to flag PSP references
## associated with more than 1 order

view: ndt_psp_transactions__duplicated_psp_references {
    derived_table: {
     # datagroup_trigger: flink_default_datagroup
      explore_source: psp_transactions {
        column: number_of_orders {field:psp_transactions.cnt_distinct_orders}
        column: psp_settlement_booking_date {field: psp_settlement_details.booking_date}
        column: psp_transactions_booking_date {field: psp_transactions.booking_date}
        column: order_date {field:orders.created_date}
        column: psp_reference {}
        filters: {
          field: global_filters_and_parameters.datasource_filter
          value: "last 3 years"
        }
      }
    }

    dimension: number_of_orders {
      label: "PSP Transactions # Orders"
      description: "Number of Orders (successful or unsuccessful)"
      type: number
      hidden: yes
    }

    dimension: psp_reference {
      label: "PSP Transactions Psp Reference"
      description: ""
      hidden: yes
      primary_key: yes
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

    dimension: is_duplicated_psp_reference {
      group_label: "> Transaction Properties"
      type: yesno
      description: "Flags if the PSP reference appears in more than one CT order"
      sql: ${number_of_orders}>1 ;;
    }
  }
