## Author: Justine Grammatikas
## Created: 2022-09-12

## This view aggregates # Orders on PSP reference granularity. It creates a Boolean to flag PSP references
## associated with more than 1 order

view: ndt_psp_transactions__duplicated_psp_references {
    derived_table: {
      explore_source: psp_transactions {
        column: number_of_orders {}
        column: psp_reference {}
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
    }

    dimension: is_duplicated_psp_reference {
      description: "Flags if the PSP reference appears in more than one CT order"
      sql:
          case
              when
                  ${number_of_orders}>1
                  then
                      true
              else
                  false
          end ;;
    }
  }
