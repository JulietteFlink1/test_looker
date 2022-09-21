

view: sku_hub_day_level_orders {

  view_label: "* Order Lineitems Daily *"
  derived_table: {

    # datagroup_trigger: flink_daily_datagroup
    # partition_keys: ["created_date"]
    # cluster_keys: ["country_iso", "hub_code"]

    explore_source: order_orderline_cl {

      column: hub_code                       { field: hubs.hub_code }
      column: hub_name                       { field: hubs.hub_name }
      column: country_iso                    { field: hubs.country_iso }

      column: created_date                   { field: orderline.created_date }
      column: tax_rate_products              { field: products.tax_rate}
      column: tax_rate_orderline            { field: orderline.tax_rate }

      column: product_sku                    { field: products.product_sku }
      column: product_sku_name               { field: products.product_sku_name }
      column: category                       { field: products.category }
      column: product_name                   { field: products.product_name }
      column: subcategory                    { field: products.subcategory }
      column: substitute_group               { field: products.substitute_group }
      column: unit_price_gross_amount        { field: products.amt_product_price_gross }

      # measures
      column: sum_item_price_fulfilled_gross { field: orderline.sum_item_price_gross }
      column: sum_item_price_fulfilled_net   { field: orderline.sum_item_price_net }
      column: sum_item_quantity_fulfilled    { field: orderline.sum_item_quantity }


      filters: {
        field: orders_cl.is_successful_order
        value: "yes"
      }
      filters: {
        field: global_filters_and_parameters.datasource_filter
        # we only have the stock-change data since this date
        value: "after 2021-12-08"
      }
    }
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========


  # =========  hidden   =========


  # =========  IDs   =========
  dimension: primary_key {
    sql: concat(${TABLE}.product_sku, ${TABLE}.hub_code, ${TABLE}.created_date, ${TABLE}.tax_rate_orderline) ;;
    hidden: yes
    primary_key: yes
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  dimension: hub_code {
    label: "Hub Code"
    # group_label: "* Hubs *"
    hidden: yes
  }
  dimension: hub_name {
    label: "Hub Name"
    # group_label: "* Hubs *"
    hidden: yes
  }
  dimension: created_date {
    label: "Order Date"
    # group_label: "* Order Lineitems *"
    description: "Order Placement Date"
    type: date
    hidden: yes
  }

  dimension: tax_rate {
    type: number
    hidden: no
    # if there were no sales to derive the actual tax rate, take the default one from the products model
    sql: coalesce(${TABLE}.tax_rate_orderline, ${TABLE}.tax_rate_products) ;;
  }

  dimension: country_iso {
    type: string
    hidden: yes
  }
  dimension: product_sku {
    type: string
    label: "SKU"
    # group_label: "* Order Lineitems *"
    hidden: yes
  }
  dimension: product_sku_name {
    label: "SKU + Name"
    group_label: "* Product Data *"
    link: {
      label: "Check Waste per Hub Split"
      url: "https://goflink.cloud.looker.com/explore/flink_v3/inbound_outbound_kpi_report?qid=MU9F0GjuddR3WYLLVCS6Zk&origin_space=325&toggle=fil,vis&f[products.product_sku_name]={{ value | url_encode }}&f[inventory_changes_daily.inventory_change_date]={{ _filters['inventory_changes_daily.inventory_change_date'] | url_encode }}"
    }
    sql: ${products.product_sku_name} ;;
  }
  dimension: category {
    label: "Parent Category"
    group_label: "* Product Data *"
    sql: ${products.category}  ;;
  }
  dimension: product_name {
    label: "Product Name"
    group_label: "* Product Data *"
    sql: ${products.product_name}  ;;
  }
  dimension: subcategory {
    label: "Sub-Category"
    group_label: "* Product Data *"
    sql: ${products.subcategory}  ;;
  }
  dimension: substitute_group {
    label: "Substitute Group"
    group_label: "* Product Data *"
    sql: ${products.substitute_group}  ;;
  }

  dimension: exclude_fresh_categories {
    label: "Is Fresh Category"
    group_label: "* Product Data *"
    type: yesno
    sql: case when ${products.category} in (
      'Frisch & Fertig',
      'Obst & Gemüse',
      'Frisches Fleisch & Fisch',
      'Backwaren',
      'Eier & Milch',
      'Joghurt & Desserts',
      'Käse',
      'Wurst & Aufschnitt',
      'Veggie & Vegan',
      'Eis',
      'Tiefkühl'
    ) then true else false end ;;
  }


  measure: sum_item_quantity_fulfilled {
    label: "SUM Item Quantity fulfilled"
    group_label: "* Order Lineitems *"
    description: "Quantity of Order Line Items fulfilled"
    value_format_name: decimal_0
    type: sum
    sql: ${TABLE}.sum_item_quantity_fulfilled ;;
  }

  measure: sum_item_price_fulfilled_gross {
    label: "SUM GMV (gross)"
    group_label: "* Order Lineitems *"
    description: "Sum of fulfilled Item prices (incl. VAT)"
    value_format_name: eur
    type: sum
    sql: ${TABLE}.sum_item_price_fulfilled_gross ;;
  }

  measure: sum_item_price_fulfilled_net {
    label: "SUM GMV (net)"
    group_label: "* Order Lineitems *"
    description: "Sum of fulfilled Item prices (excl. VAT)"
    value_format_name: eur
    type: sum
    sql: ${TABLE}.sum_item_price_fulfilled_net ;;
  }

  measure: unit_price_gross_amount {
    label: "AVG Unit Price Gross"
    group_label: "* Order Lineitems *"
    type: average
    value_format_name: eur
  }

##########################################################################################################################
##########################################################################################################################
############################################# Demand Planning ############################################################
##########################################################################################################################
##########################################################################################################################

  #This is needed to calculate week to date

  dimension_group: report_date {
    label: "Order Date Timeframe"
    # group_label: "* Order Lineitems *"
    description: "Order Placement Date"
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      day_of_week,
      day_of_week_index
    ]
    hidden: yes
    datatype: date
    sql: ${created_date} ;;
  }

  dimension_group: current_date_t_1 {
    label: "Current Date - 1"
    type: time
    timeframes: [
      date,
      week,
      month,
      day_of_week_index,
      day_of_week
    ]
    convert_tz: no
    datatype: date
    sql: date_sub(current_date(), interval 1 day) ;;
    hidden: yes
  }

  dimension: until_today {
    type: yesno
    sql: ${report_date_day_of_week_index} <= ${current_date_t_1_day_of_week_index} AND
      ${report_date_day_of_week_index} >= 0 ;;
    hidden: yes
  }


 ## Quantity in Items

## Daily

  measure: sum_item_quantity_fulfilled_t_1 {
    label: "SUM Item Quantity fulfilled t-1"
    group_label: "Demand Planning"
    description: "Quantity of Order Line Items fulfilled t-1"
    value_format_name: decimal_0
    type: sum
    sql: ${TABLE}.sum_item_quantity_fulfilled ;;
    filters: [created_date: "yesterday"]
    hidden: yes
  }

  measure: sum_item_quantity_fulfilled_t_2 {
    label: "SUM Item Quantity fulfilled t-2"
    group_label: "Demand Planning"
    description: "Quantity of Order Line Items fulfilled t-2"
    value_format_name: decimal_0
    type: sum
    sql: ${TABLE}.sum_item_quantity_fulfilled ;;
    filters: [created_date: "2 days ago"]
    hidden: yes
  }

  measure: sum_item_quantity_fulfilled_t_3 {
    label: "SUM Item Quantity fulfilled t-3"
    group_label: "Demand Planning"
    description: "Quantity of Order Line Items fulfilled t-3"
    value_format_name: decimal_0
    type: sum
    sql: ${TABLE}.sum_item_quantity_fulfilled ;;
    filters: [created_date: "3 days ago"]
    hidden: yes
  }

  measure: sum_item_quantity_fulfilled_t_4 {
    label: "SUM Item Quantity fulfilled t-4"
    group_label: "Demand Planning"
    description: "Quantity of Order Line Items fulfilled t-4"
    value_format_name: decimal_0
    type: sum
    sql: ${TABLE}.sum_item_quantity_fulfilled ;;
    filters: [created_date: "4 days ago"]
    hidden: yes
  }

  ## weekly

  measure: sum_item_quantity_fulfilled_w_1 {
    label: "SUM Item Quantity fulfilled w-1"
    group_label: "Demand Planning"
    description: "Quantity of Order Line Items fulfilled w-1"
    value_format_name: decimal_0
    type: sum
    sql: ${TABLE}.sum_item_quantity_fulfilled ;;
    filters: [created_date: "1 week ago"]
    hidden: yes
  }

  measure: sum_item_quantity_fulfilled_w_2 {
    label: "SUM Item Quantity fulfilled w-2"
    group_label: "Demand Planning"
    description: "Quantity of Order Line Items fulfilled w-2"
    value_format_name: decimal_0
    type: sum
    sql: ${TABLE}.sum_item_quantity_fulfilled ;;
    filters: [created_date: "2 weeks ago"]
    hidden: yes
  }

  measure: sum_item_quantity_fulfilled_w_3 {
    label: "SUM Item Quantity fulfilled w-3"
    group_label: "Demand Planning"
    description: "Quantity of Order Line Items fulfilled w-3"
    value_format_name: decimal_0
    type: sum
    sql: ${TABLE}.sum_item_quantity_fulfilled ;;
    filters: [created_date: "3 weeks ago"]
    hidden: yes
  }

  measure: sum_item_quantity_fulfilled_w_4 {
    label: "SUM Item Quantity fulfilled w-4"
    group_label: "Demand Planning"
    description: "Quantity of Order Line Items fulfilled w-4"
    value_format_name: decimal_0
    type: sum
    sql: ${TABLE}.sum_item_quantity_fulfilled ;;
    filters: [created_date: "4 weeks ago"]
    hidden: yes
  }



  ## Quantity in Euro

  measure: sum_item_price_fulfilled_gross_t_1 {
    label: "SUM GMV (gross) t-1"
    group_label: "Demand Planning"
    description: "Sum of fulfilled Item prices (incl. VAT) t-1"
    value_format_name: eur
    type: sum
    sql: ${TABLE}.sum_item_price_fulfilled_gross ;;
    filters: [created_date: "yesterday"]
    hidden: yes
  }

  measure: sum_item_price_fulfilled_gross_t_2 {
    label: "SUM GMV (gross) t-2"
    group_label: "Demand Planning"
    description: "Sum of fulfilled Item prices (incl. VAT) t-2"
    value_format_name: eur
    type: sum
    sql: ${TABLE}.sum_item_price_fulfilled_gross ;;
    filters: [created_date: "2 days ago"]
    hidden: yes
  }

  measure: sum_item_price_fulfilled_gross_t_3 {
    label: "SUM GMV (gross) t-3"
    group_label: "Demand Planning"
    description: "Sum of fulfilled Item prices (incl. VAT) t-3"
    value_format_name: eur
    type: sum
    sql: ${TABLE}.sum_item_price_fulfilled_gross ;;
    filters: [created_date: "3 days ago"]
    hidden: yes
  }

  measure: sum_item_price_fulfilled_gross_t_4 {
    label: "SUM GMV (gross) t-4"
    group_label: "Demand Planning"
    description: "Sum of fulfilled Item prices (incl. VAT) t-4"
    value_format_name: eur
    type: sum
    sql: ${TABLE}.sum_item_price_fulfilled_gross ;;
    filters: [created_date: "4 days ago"]
    hidden: yes
  }

   ## weekly

  measure: sum_item_price_fulfilled_gross_w_1 {
    label: "SUM GMV (gross) w-1"
    group_label: "Demand Planning"
    description: "Sum of fulfilled Item prices (incl. VAT) w-1"
    value_format_name: eur
    type: sum
    sql: ${TABLE}.sum_item_price_fulfilled_gross ;;
    filters: [created_date: "1 week ago"]
    hidden: yes
  }

  measure: sum_item_price_fulfilled_gross_w_2 {
    label: "SUM GMV (gross) w-2"
    group_label: "Demand Planning"
    description: "Sum of fulfilled Item prices (incl. VAT) w-2"
    value_format_name: eur
    type: sum
    sql: ${TABLE}.sum_item_price_fulfilled_gross ;;
    filters: [created_date: "2 weeks ago"]
    hidden: yes
  }

  measure: sum_item_price_fulfilled_gross_w_3 {
    label: "SUM GMV (gross) w-3"
    group_label: "Demand Planning"
    description: "Sum of fulfilled Item prices (incl. VAT) w-3"
    value_format_name: eur
    type: sum
    sql: ${TABLE}.sum_item_price_fulfilled_gross ;;
    filters: [created_date: "3 weeks ago"]
    hidden: yes
  }

  measure: sum_item_price_fulfilled_gross_w_4 {
    label: "SUM GMV (gross) w-4"
    group_label: "Demand Planning"
    description: "Sum of fulfilled Item prices (incl. VAT) w-4"
    value_format_name: eur
    type: sum
    sql: ${TABLE}.sum_item_price_fulfilled_gross ;;
    filters: [created_date: "4 weeks ago"]
    hidden: yes
  }


  ### w2d

  #Items
  measure: sum_item_quantity_fulfilled_wtd {
    label: "SUM Item Quantity fulfilled WtD"
    group_label: "Demand Planning"
    description: "Quantity of Order Line Items fulfilled - WtD"
    value_format_name: decimal_0
    type: sum
    sql: ${TABLE}.sum_item_quantity_fulfilled ;;
    filters: [created_date: "this week", until_today: "yes"]
    hidden: yes
  }

  measure: sum_item_quantity_fulfilled_wtd_w_1 {
    label: "SUM Item Quantity fulfilled WtD w-1"
    group_label: "Demand Planning"
    description: "Quantity of Order Line Items fulfilled - Previous week WtD"
    value_format_name: decimal_0
    type: sum
    sql: ${TABLE}.sum_item_quantity_fulfilled ;;
    filters: [created_date: "1 week ago", until_today: "yes"]
    hidden: yes
  }

  #EURO

  measure: sum_item_price_fulfilled_gross_wtd {
    label: "SUM GMV (gross) WtD"
    group_label: "Demand Planning"
    description: "Sum of fulfilled Item prices (incl. VAT) - WtD"
    value_format_name: eur
    type: sum
    sql: ${TABLE}.sum_item_price_fulfilled_gross ;;
    filters: [created_date: "this week", until_today: "yes"]
    hidden: yes
  }

  measure: sum_item_price_fulfilled_gross_wtd_w_1 {
    label: "SUM GMV (gross) WtD w-1"
    group_label: "Demand Planning"
    description: "Sum of fulfilled Item prices (incl. VAT) - Previous week WtD"
    value_format_name: eur
    type: sum
    sql: ${TABLE}.sum_item_price_fulfilled_gross ;;
    filters: [created_date: "1 week ago", until_today: "yes"]
    hidden: yes
  }


}
