

view: sku_hub_day_level_orders {

  view_label: "* Order Lineitems Daily *"
  derived_table: {
    explore_source: order_orderline_cl {

      column: hub_code                       { field: hubs.hub_code }
      column: hub_name                       { field: hubs.hub_name }
      column: country_iso                    { field: hubs.country_iso }

      column: created_date                   { field: orderline.created_date }

      column: product_sku                    { field: products.product_sku }
      column: product_sku_name               { field: products.product_sku_name }
      column: category                       { field: products.category }
      column: product_name                   { field: products.product_name }
      column: subcategory                    { field: products.subcategory }
      column: substitute_group               { field: products.substitute_group }
      column: unit_price_gross_amount        { field: products.amt_product_price_gross }

      # measures
      column: sum_item_price_fulfilled_gross { field: orderline.sum_item_price_fulfilled_gross }
      column: sum_item_price_fulfilled_net   { field: orderline.sum_item_price_fulfilled_net }
      column: sum_item_quantity_fulfilled    { field: orderline.sum_item_quantity_fulfilled }


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
    sql: concat(${TABLE}.product_sku, ${TABLE}.hub_code, ${TABLE}.created_date) ;;
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
}
