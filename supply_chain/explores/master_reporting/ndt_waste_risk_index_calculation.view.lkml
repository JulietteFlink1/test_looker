# If necessary, uncomment the line below to include explore_source.
# include: "supply_chain_master.explore.lkml"

view: ndt_waste_risk_index_calculation {
  derived_table: {
    explore_source: supply_chain_master {
      column: parent_sku {}
      column: hub_code {}
      column: report_day_of_week {}
      column: report_date {}
      column: sum_amt_total_gmv_selling_price_gross {}
      bind_all_filters: yes
    }
  }

############################################################################
######################## Hidden Dimensions #################################
############################################################################

  dimension: table_uuid {
    sql: concat(${parent_sku}, ${hub_code}, ${report_date}) ;;
    primary_key: yes
    hidden: yes
  }

  dimension: parent_sku {
    description: "The Parent SKU of a product. This groups several child SKUs that belongs to the same replenishment substitute group."
    hidden: yes
  }
  dimension: hub_code {
    description: "Code of a hub identical to back-end source tables."
    hidden: yes
  }
  dimension: report_day_of_week {
    description: ""
    type: date_day_of_week
    hidden: yes
  }
  dimension: report_date {
    description: ""
    type: date
    hidden: yes
  }
  dimension: sum_amt_total_gmv_selling_price_gross {
    label: "€ GMV (Selling Price Gross Valuation)"
    group_label: "Waste Risk Metrics"
    description: "Total GMV Gross translated as the total amount Sold in Euro per Hub and Parent SKU (Valuated on Selling Price Gross)"
    hidden: yes
    type: number
    value_format_name: eur
  }

############################################################################
###################### Costumized Measures #################################
############################################################################

  measure: mean_gmv_price_gross {
    label: "AVG GMV (Selling Price Gross Valuation)"
    group_label: "Waste Risk Metrics"
    description: "Average (Mean) calculated over GMV Gross translated as the total amount Sold in Euro per Hub and Parent SKU (Valuated on Selling Price Gross)"
    type: average
    sql: ${sum_amt_total_gmv_selling_price_gross} ;;
  }


  measure: std_gmv_price_gross {
    label: "StD GMV (Selling Price Gross Valuation)"
    group_label: "Waste Risk Metrics"
    description: "Standar Deviation calculated over GMV Gross translated as the total amount Sold in Euro per Hub and Parent SKU (Valuated on Selling Price Gross)"
    type: number
    # sql_distinct_key: ${created_date} ;;
    sql: coalesce(round(stddev(${sum_amt_total_gmv_selling_price_gross}), 2),0) ;;
  }


  measure: key_index {
    label: "Waste Risk Index"
    group_label: "Waste Risk Metrics"
    description: "Shows the risk index of SKU-Location calculated as the divition between Mean Sales and Standard Deviation. The higher the value, the better. The lower, the riskier/volatile the SKU becomes."
    type: number
    sql: coalesce(round(${mean_gmv_price_gross} / nullif(${std_gmv_price_gross}, 0), 2),0) ;;
  }




}
