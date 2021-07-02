# If necessary, uncomment the line below to include explore_source.
# include: "retail_kpis.explore.lkml"
# If necessary, uncomment the line below to include explore_source.
# include: "retail_kpis.explore.lkml"

view: retail_kpis_equalized_revenue {
  derived_table: {
    explore_source: retail_orders_explore {
      column: created_date       { field: retail_kpis_hubs_and_rev_on_sku_date_level.created_date }
      column: is_current_cohort  { field: retail_kpis_hubs_and_rev_on_sku_date_level.is_current_cohort }
      column: is_previous_cohort { field: retail_kpis_hubs_and_rev_on_sku_date_level.is_previous_cohort }
      column: product_sku        { field: retail_kpis_hubs_and_rev_on_sku_date_level.product_sku }

      column: cntd_hub_code      { field: retail_kpis_hubs_and_rev_on_sku_date_level.cntd_hub_code }
      column: sum_item_price_net { field: order_orderline.sum_item_price_net }


      bind_all_filters: yes
    }
  }


  dimension: primary_key {
    primary_key: yes
    sql: concat( ${product_sku}, CAST(${created_date} as string) ) ;;
    hidden: yes
  }


  dimension: created_date {
    type: date
    sql: ${TABLE}.created_date ;;
  }

  dimension: product_sku {}




  dimension: is_current_cohort {
    label: "Retail Kpis Aggregated Ndt Is Current Cohort (Yes / No)"
    type: yesno
    hidden: yes
  }
  dimension: is_previous_cohort {
    label: "Retail Kpis Aggregated Ndt Is Previous Cohort (Yes / No)"
    type: yesno
    hidden: yes
  }



  dimension: cntd_hub_code {
    label: "Retail Kpis Aggregated Ndt # Hubs"
    value_format: "#,##0.0"
    type: number
    hidden: yes
  }

  dimension: sum_item_price_net {
    label: "Retail Kpis Aggregated Ndt SUM Item Prices sold (net)"
    description: "Sum of sold Item prices (excl. VAT)"
    value_format_name: eur
    type: number
    sql: ${TABLE}.sum_item_price_net ;;
    hidden: yes
  }


  # measure: sum_item_price_net_current {
  #   type: sum
  #   sql: ( if(${is_current_cohort}, ${sum_item_price_net}, null) );;
  #   value_format_name: eur
  #   hidden: yes
  # }
  # measure: sum_item_price_net_previous {
  #   type: sum
  #   sql: ( if(${is_previous_cohort}, ${sum_item_price_net}, null) );;
  #   value_format_name: eur
  #   hidden: yes
  # }

  measure: equalized_revenue {
    type: sum
    sql: (${sum_item_price_net} / nullif(${cntd_hub_code}, 0) );;
    value_format_name: eur
  }

  measure: equalized_revenue_current {
    type: sum
    sql: ( if(${is_current_cohort}, ${sum_item_price_net} / nullif(${cntd_hub_code}, 0), null) );;
    value_format_name: eur
  }

  measure: equalized_revenue_previous {
    type: sum
    sql: ( if(${is_previous_cohort}, ${sum_item_price_net} / nullif(${cntd_hub_code}, 0), null) ) ;;
    value_format_name: eur
  }

  set: _measures {
    fields: [
      # sum_item_price_net, sum_item_price_net_current, sum_item_price_net_previous,
      equalized_revenue, equalized_revenue_current, equalized_revenue_previous
      ]
  }

}
