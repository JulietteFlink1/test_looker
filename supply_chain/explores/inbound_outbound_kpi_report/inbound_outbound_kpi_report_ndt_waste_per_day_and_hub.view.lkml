include: "inbound_outbound_kpi_report.explore.lkml"

view: inbound_outbound_kpi_report_ndt_waste_per_day_and_hub {
  derived_table: {

      # datagroup_trigger: flink_daily_datagroup
      # partition_keys: ["inventory_change_date"]
      # cluster_keys: ["hub_code"]

    explore_source: inbound_outbound_kpi_report {

      column: inventory_change_date                 { field: inventory_changes_daily.inventory_change_date }
      column: hub_code                              { field: inventory_changes_daily.hub_code }
      column: outbound_waste_per_buying_price_gross { field: inventory_changes_daily.sum_outbound_waste_per_buying_price_gross }
      column: outbound_waste_per_buying_price_net   { field: inventory_changes_daily.sum_outbound_waste_per_buying_price_net }

      filters: [
        global_filters_and_parameters.datasource_filter: "after 2022-01-01"
      ]

    }
  }


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Dimensions - HIDDEN
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: primary_key {
    primary_key: yes
    hidden: yes
    sql: concat(${TABLE}.inventory_change_date, ${TABLE}.hub_code) ;;
  }
  dimension: inventory_change_date {
    type: date
    hidden: yes
  }
  dimension: hub_code {
    type: string
    hidden: yes
  }
  dimension: outbound_waste_per_buying_price_gross {
    type: number
    hidden: yes
  }
  dimension: outbound_waste_per_buying_price_net {
    type: number
    hidden: yes
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Measures
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  measure: sum_waste_per_buying_price_net {
    type: sum
    sql:  ${outbound_waste_per_buying_price_net};;
    value_format_name: eur
    hidden: no
  }

  measure: sum_waste_per_buying_price_gross {
    type: sum
    sql:  ${outbound_waste_per_buying_price_net};;
    value_format_name: eur
    hidden: no
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Measures
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  measure: avg_waste_per_order_per_buying_price_net {

    type: number
    sql:  safe_divide(${sum_waste_per_buying_price_net}, ${orders_cl.cnt_orders}) ;;
    value_format_name: eur
  }

  measure: avg_waste_per_order_per_buying_price_gross {
    type: number
    sql: safe_divide(${sum_waste_per_buying_price_gross}, ${orders_cl.cnt_orders}) ;;
    value_format_name: eur

  }




}
