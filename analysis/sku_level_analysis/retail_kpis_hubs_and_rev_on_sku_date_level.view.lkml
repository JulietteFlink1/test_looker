# If necessary, uncomment the line below to include explore_source.
# include: "retail_kpis.explore.lkml"

view: retail_kpis_hubs_and_rev_on_sku_date_level {
  derived_table: {
    explore_source: retail_orders_explore {
      column: created_date                    { field: retail_orders_explore.created_date  }
      column: hub_code                        { field: hubs.hub_code }
      column: product_sku                     { field: order_orderline.product_sku }
      # column: sum_item_price_net              { field: order_orderline.sum_item_price_net }

      bind_all_filters: yes

    }

  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: primary_key {
    primary_key: yes
    sql: concat(${product_sku}, CAST(${created_date} as string ) ;;
    hidden: yes
  }

  dimension: created_date {
    sql: ${TABLE}.created_date ;;
    type: date
  }

  dimension: product_sku {
    label: "Product SKU"
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~  Dervied Dimensions     ~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  dimension: is_current_cohort {
    type: yesno
    sql: ${created_date} >= date_add(current_date(), interval -7 day) and ${created_date} < current_date() ;;
  }

  dimension: is_previous_cohort {
    type: yesno
    sql: ${created_date} >= date_add(current_date(), interval -14 day) and ${created_date} < date_add(current_date(), interval -7 day) ;;
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: cntd_hub_code {
    label: "# Hubs"

    sql: ${TABLE}.hub_code ;;
    type: count_distinct

    value_format_name: decimal_1
  }

  # measure: sum_item_price_net {
  #   label: "SKU-Date: Sum Item Price Net"
  #   sql: ${TABLE}.sum_item_price_net ;;
  #   value_format_name: eur
  #   type: sum
  # }

  set: export_fields {
    fields: [is_current_cohort, is_previous_cohort, cntd_hub_code,
      # sum_item_price_net
      ]
  }

}
