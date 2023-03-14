# If necessary, uncomment the line below to include explore_source.
# include: "supply_chain_master.explore.lkml"

view: ndt_handling_unit_rotation {
  derived_table: {
    explore_source: supply_chain_master {
      column: report_date {}
      column: hub_code { field: hubs.hub_code }
      column: parent_sku {}
      column: handling_unit_rotation_ratio {}
      column: sum_items_sold {}
      column: pct_in_stock_with_cutoff {}
      bind_all_filters: yes
    }
  }
  dimension: table_uuid {
    sql: concat(${parent_sku}, ${hub_code}, ${report_date} ) ;;
    primary_key: yes
    hidden: yes
  }

  dimension: report_date {
    description: ""
    type: date
    hidden: yes
  }
  dimension: hub_code {
    label: "Hub Code"
    group_label: ""
    description: "Code of a hub identical to back-end source tables."
    hidden: yes
  }
  dimension: parent_sku {
    label: "Parent SKU"
    group_label: ""
    description: "The Parent SKU of a product. This groups several child SKUs that belongs to the same replenishment substitute group."
    hidden: yes
  }
  dimension: handling_unit_rotation_ratio {
    label: "Supply Chain Master Handling unit rotation ratio"
    group_label: "Handling Unit Rotation metrics"
    description: "Ratio that shows the quantity of units we need to sell before we discard the items. It's defined as the relation between Purchase Units and Max Shelf Life"
    hidden: yes
  }
  dimension: sum_items_sold {
    label: "# Items Sold"
    group_label: "Handling Unit Rotation metrics"
    description: "Total number of units sold"
    value_format_name: decimal_1
    type: number
    hidden: yes
  }

  dimension: pct_in_stock_with_cutoff {
    label: "In Stock (Cutoff Hours)"
    group_label: "Handling Unit Rotation metrics"
    description: "Percentage of an SKU available during the day calculated as (1 - % Out of Stock) - With Cutoff Hours"
    type: number
    value_format_name: percent_1
    hidden: yes
  }

  dimension: is_in_stock_with_cutoff {
    label: "Is in Stock (Cutoff Hours)"
    group_label: "Handling Unit Rotation metrics"
    description: "Boolean that shows if an SKU is available during the day calculated as (1 - % Out of Stock) - With Cutoff Hours"
    type: yesno
    sql: case
          when ${pct_in_stock_with_cutoff} > 0 then true
          else false
         end  ;;
    hidden: yes
  }


################################################################################
############################## Measures ########################################
################################################################################


  measure: avg_handling_unit_rotation_ratio {
    label: "Handling Unit Rotation Ratio"
    group_label: "Handling Unit Rotation metrics"
    description: "Ratio that shows the quantity of units we need to sell before we discard the items. It's defined as the relation between Purchase Units and Max Shelf Life"
    type: average
    sql: ${handling_unit_rotation_ratio} ;;
    value_format_name: decimal_1
    filters: [is_in_stock_with_cutoff: "yes"]
    hidden: yes
  }

  measure: avg_number_of_items_sold {
    label: "AVG Items Sold"
    group_label: "Handling Unit Rotation metrics"
    description: "Average of the total units sold"
    type: average
    sql: ${sum_items_sold} ;;
    value_format_name: decimal_2
    filters: [is_in_stock_with_cutoff: "yes"]
    hidden: no
  }

measure: handling_unit_rotation_index {
  label: "Handling Unit Rotation Index"
  group_label: "Handling Unit Rotation metrics"
  description: "Defined as how many HU we are able to sell within the self-life of the product. Helps to pot a product where its Purchasing Unit (= Handling Unit) is too high and waste is generated because of that."
  type: number
  sql: safe_divide(${avg_number_of_items_sold}, ${avg_handling_unit_rotation_ratio}) ;;
  value_format_name: decimal_2
  hidden: no
}


}
