include: "/models/flink_v3.model.lkml"

view: product_attribute_fact_ranking_hlp {
  derived_table: {
    explore_source: order_order {
      # dimensions
      column: substitute_group         { field: product_attribute_facts.substitute_group }
      column: product_name             { field: order_orderline.product_name }
      # metrics
      column: sum_item_price_gross     { field: order_orderline.sum_item_price_gross }
      column: sum_item_quantity        { field: order_orderline.sum_item_quantity }
      # filter
      filters: {
        field: order_order.is_internal_order
        value: "no"
      }
      filters: {
        field: order_order.is_successful_order
        value: "yes"
      }
      # filter explore fields based on my defined filter fields
      bind_filters: {
        to_field: hubs.city
        from_field: product_attribute_fact_ranking_hlp.filter_of_hub_city
      }
      bind_filters: {
        to_field: hubs.hub_name
        from_field: product_attribute_fact_ranking_hlp.filter_of_hub_code
      }
      bind_filters: {
        to_field: hubs.country
        from_field: product_attribute_fact_ranking_hlp.filter_of_hub_country
      }
      bind_filters: {
        to_field: order_order.created_date
        from_field: product_attribute_fact_ranking_hlp.filter_created_at
      }


      # goal: ranking metrics, that are filterable
      derived_column: rank_per_quantity {
        sql: RANK() OVER (partition by substitute_group ORDER BY sum_item_quantity DESC) ;;
      }
      derived_column: rank_per_price {
        sql: RANK() OVER (partition by substitute_group ORDER BY sum_item_price_gross DESC) ;;
      }
    }
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Primary Key
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  dimension: unique_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: concat(${product_name}, ${substitute_group} ;;
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Dimensions
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  dimension: substitute_group {
    label: "Substitue Group"
    description: "A group of products, thatr are perfect substitues"
    type: string
  }
  dimension: rank_per_quantity {
    label: "Rank per Item Quantity Sold"
    description: "The rank of a product within his Substitue Group based on the number of items sold"
    type: number
    value_format_name: decimal_0
  }
  dimension: rank_per_price {
    label: "Rank per Item Price Sold (Gross)"
    description: "The rank of a product within his Substitue Group based on the sum of item prices (gross)"
    type: number
    value_format_name: decimal_0
  }
  dimension: product_name {
    label: "Product Name"
    description: "The name of a specific product | order item"
    type: string
  }

  dimension: product_name_with_rank {
    label: "Product Name with Rank"
    description: "The combination of the products rank and its name"
    type: string
    sql: concat(${ranking_dimension},".) ",${product_name})  ;;
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Hidden Fields
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  dimension: sum_item_price_gross {
    label: "* Order Line Items * SUM Item Prices sold (gross)"
    description: "Sum of sold Item prices (incl. VAT)"
    value_format_name: eur
    type: number
    hidden: yes
  }

  dimension: sum_item_quantity {
    label: "* Order Line Items * SUM Item Quantity sold"
    description: "Quantity of Order Line Items sold"
    value_format_name: decimal_0
    type: number
    hidden: yes
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Measures
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: total_item_quantity {
    label: "SUM Item Quantity sold"
    description: "Quantity of Order Line Items sold"
    type: sum
    value_format_name: decimal_0
    sql: ${sum_item_quantity} ;;
  }

  measure: total_item_price_gross {
    label: "SUM Item Prices sold (gross)"
    description: "Sum of sold Item prices (incl. VAT)"
    type: sum
    value_format_name: eur
    sql: ${sum_item_price_gross} ;;
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Parameters
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter: select_ranking_metric {
    label: "Select Ranking Metric"
    group_label: "Filters | Parameters"
    type: unquoted
    allowed_value: { value: "num"      label: "per SUM Item Quantity sold"}
    allowed_value: { value: "eur"      label: "per SUM Item Prices sold (gross)"}
    default_value: "num"
  }

  measure: ranking_metric {
    label: "Ranking Metric (dynamic)"
    description: "The metric, on which basis the Product Rank per Substitue Group is calculated - either per SUM Item Prices sold (gross) or per SUM Item Quantity sold"
    type: number
    label_from_parameter: select_ranking_metric
    sql:
    {% if select_ranking_metric._parameter_value == 'num' %}
      ${total_item_quantity}
    {% elsif select_ranking_metric._parameter_value == 'eur' %}
      ${total_item_price_gross}
    {% endif %}
    ;;
  }

  dimension: ranking_dimension {
    label: "Rank (dynamic)"
    description: "The rank of a product within its Substitute Group based on the Select Ranking Metric parameter"
    type: number
    label_from_parameter: select_ranking_metric
    sql:
    {% if select_ranking_metric._parameter_value == 'num' %}
      ${rank_per_quantity}
    {% elsif select_ranking_metric._parameter_value == 'eur' %}
      ${rank_per_price}
    {% endif %}
    ;;
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Template Filter
  # --> these filters will not be set directly, but only indirectly through the inputs in the Top Selling Products dashbaord: https://goflink.cloud.looker.com/dashboards-next/33?Country=&Order+Date=yesterday&City=&Hub+Name=&Substitute+Group=&Select+Ranking+Metric=num&Ranking+Dimension=%5B0%2C2%5D
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  filter: filter_of_hub_city {
    group_label: "Filters | Parameters"
    type: string
  }

  filter: filter_of_hub_code {
    group_label: "Filters | Parameters"
    type: string
  }

  filter: filter_of_hub_country {
    group_label: "Filters | Parameters"
    type: string
  }

  filter: filter_created_at {
    group_label: "Filters | Parameters"
    type: date
    default_value: "2021-05-01"
  }


}
