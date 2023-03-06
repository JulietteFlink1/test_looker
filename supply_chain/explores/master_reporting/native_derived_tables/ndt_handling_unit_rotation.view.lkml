# If necessary, uncomment the line below to include explore_source.
# include: "supply_chain_master.explore.lkml"

view: ndt_handling_unit_rotation {
  derived_table: {
    explore_source: supply_chain_master {
      column: report_date {}
      column: hub_code { field: hubs.hub_code }
      column: parent_sku {}
      column: purchase_unit {}
      column: max_shelf_life_days {}
      column: handling_unit_rotation_ratio {}
      column: sum_items_sold {}
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
    group_label: "Special Use Case"
    description: "Ratio that shows the quantity of units we need to sell before we discard the items. It's defined as the relation between Purchase Units and Max Shelf Life"
    hidden: yes
  }
  dimension: sum_items_sold {
    label: "# Items Sold"
    description: "Total number of units sold"
    value_format_name: decimal_1
    type: number
    hidden: yes
  }


################################################################################
############################## Measures ########################################
################################################################################


  measure: mes_handling_unit_rotation_ratio {
    label: "Handling Unit Rotation Ratio"
    group_label: "Special Use Cases"
    description: "Ratio that shows the quantity of units we need to sell before we discard the items. It's defined as the relation between Purchase Units and Max Shelf Life"
    type: average
    sql: ${handling_unit_rotation_ratio} ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: avg_number_of_items_sold {
    label: "AVG Items Sold"
    group_label: "Special Use Cases"
    description: "Average of the total units sold"
    type: average
    sql: ${sum_items_sold} ;;
    value_format_name: decimal_2
    hidden: no
  }

measure: handling_unit_rotation {
  label: "Handling Unit Rotation "
  group_label: "Special Use Cases"
  description: "Defined as how many HU we are able to sell within the self-life of the product. Helps to pot a product where its Purchasing Unit (= Handling Unit) is too high and waste is generated because of that."
  type: number
  sql: safe_divide(${avg_number_of_items_sold}, ${mes_handling_unit_rotation_ratio}) ;;
  value_format_name: decimal_2
  hidden: no
}


}
