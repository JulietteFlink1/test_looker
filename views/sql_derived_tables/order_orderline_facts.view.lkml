view: order_orderline_facts {
  derived_table: {
    datagroup_trigger: flink_default_datagroup
    sql:
          SELECT
                  order_order.country_iso,
                  order_order.id,
                  order_order.metadata,
                  order_order.created,
                  order_order.user_email,
                  order_order.status,
                  order_orderline.id AS orderline_id,
                  order_orderline.product_sku,
                  order_orderline.quantity,
                  order_orderline.unit_price_gross_amount,
                  order_orderline.unit_price_net_amount

                  FROM `flink-backend.saleor_db_global.order_order`
                     AS order_order
                LEFT JOIN `flink-backend.saleor_db_global.order_orderline`
                     AS order_orderline ON order_orderline.country_iso = order_order.country_iso AND order_orderline.order_id = order_order.id
              WHERE order_orderline.id IS NOT NULL      --exclude strange draft orders

       ;;
  }

  dimension_group: created {
    label: "Order"
    group_label: "* Dates and Timestamps *"
    description: "Order Placement Date/Time"
    type: time
    timeframes: [
      raw,
      hour_of_day,
      time,
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created ;;
    datatype: timestamp
  }

  dimension: unique_id {
    hidden: yes
    primary_key: yes
    type: string
    sql: concat(${country_iso}, ${TABLE}.id, ${TABLE}.orderline_id) ;;
  }

  dimension: country_iso {
    type: string
    hidden: yes
    sql: ${TABLE}.country_iso ;;
  }

  dimension: quantity {
    type: number
    sql: ${TABLE}.quantity ;;
  }

  dimension: unit_price_gross_amount {
    group_label: "* Monetary Values *"
    type: number
    sql: ${TABLE}.unit_price_gross_amount ;;
  }

  dimension: unit_price_net_amount {
    group_label: "* Monetary Values *"
    type: number
    sql: ${TABLE}.unit_price_net_amount ;;
  }

  dimension: metadata {
    type: string
    hidden: yes
    sql: ${TABLE}.metadata ;;
  }

  dimension: warehouse_name {
    type: string
    hidden: yes
    sql:  CASE WHEN JSON_EXTRACT_SCALAR(${metadata}, '$.warehouse') IN ('hamburg-oellkersallee', 'hamburg-oelkersallee') THEN 'de_ham_alto'
    WHEN JSON_EXTRACT_SCALAR(${metadata}, '$.warehouse') = 'münchen-leopoldstraße' THEN 'de_muc_schw'
    ELSE JSON_EXTRACT_SCALAR(${metadata}, '$.warehouse')
    END ;;
  }

  dimension: product_sku {
    group_label: "* IDs *"
    type: string
    sql: CASE WHEN LENGTH(${TABLE}.product_sku)=7 THEN CONCAT('1', ${TABLE}.product_sku) ELSE ${TABLE}.product_sku END;;
  }


  #dimension: product_sku {
  #  type: string
  #  sql: ${TABLE}.product_sku ;;
  #}

  dimension: user_email {
    group_label: "* User Dimensions *"
    type: string
    sql: ${TABLE}.user_email ;;
  }

  dimension: status {
    group_label: "* Order Dimensions *"
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: is_internal_order {
    group_label: "* Order Dimensions *"
    type: yesno
    sql: ${user_email} LIKE '%goflink%' OR ${user_email} LIKE '%pickery%' ;;
  }

  dimension: is_successful_order {
    group_label: "* Order Dimensions *"
    type: yesno
    sql: ${status} IN('fulfilled', 'partially fulfilled');;
  }


  measure: sum_item_quantity {
    group_label: "* Sold Quantities *"
    label: "SUM Item Quantity sold"
    description: "Quantity of Order Line Items sold"
    hidden:  no
    type: sum
    sql: ${quantity};;
    value_format: "0"
  }

  measure: avg_daily_item_quantity_today {
    group_label: "* Sold Quantities *"
    label: "# Total Sales (today)"
    description: "Average Daily Quantity of Products sold considering only the current day"
    hidden:  no
    type: sum
    sql: ${quantity};;
    filters: [created_date: "today"]
    value_format: "0"
  }

  measure: avg_daily_item_quantity_last_1d {
    group_label: "* Sold Quantities *"
    label: "# Total Sales (prev day)"
    description: "Average Daily Quantity of Products sold considering only the previous day"
    hidden:  no
    type: sum
    sql: ${quantity};;
    filters: [created_date: "1 day ago"]
    value_format: "0"
  }

  measure: sum_item_quantity_last_3d {
    group_label: "* Sold Quantities *"
    label: "# Total Sales (last 3d)"
    description: "Quantity of Order Line Items sold in the previous 3 days"
    hidden:  yes
    type: sum
    sql: ${quantity};;
    filters: [created_date: "3 days ago for 3 days"]
    value_format: "0"
  }

  measure: sum_item_quantity_last_30d {
    group_label: "* Sold Quantities *"
    label: "# Total Sales (last 30d)"
    description: "Quantity of Order Line Items sold in the previous 30 days"
    hidden:  yes
    type: sum
    sql: ${quantity};;
    filters: [created_date: "30 days ago for 30 days"]
    value_format: "0"
  }

  measure: avg_daily_item_quantity_last_3d {
    group_label: "* Sold Quantities *"
    label: "# AVG daily sales (last 3d)"
    description: "Average Daily Quantity of Products sold considering the previous 3 days"
    hidden:  no
    type: number
    sql: ${sum_item_quantity_last_3d} / 3;;
    value_format: "0.00"
  }

  measure: sum_item_quantity_last_7d {
    group_label: "* Sold Quantities *"
    label: "# Total Sales (last 7d)"
    description: "Quantity of Order Line Items sold in the previous 7 days"
    hidden:  no
    type: sum
    sql: ${quantity};;
    filters: [created_date: "7 days ago for 7 days"]
    value_format: "0.0"
  }

  measure: avg_daily_item_quantity_last_7d {
    group_label: "* Sold Quantities *"
    label: "# AVG daily sales (last 7d)"
    description: "Average Daily Quantity of Products sold considering the previous 7 days"
    hidden:  no
    type: number
    sql: ${sum_item_quantity_last_7d} / 7;;
    value_format: "0.0"
  }

  measure: pct_stock_range_1d {
    group_label: "* Operations / Logistics *"
    label: "Stock Range [days, based on 1d avg.]"
    description: "Current stock divided by 1d AVG Daily Sales"
    hidden:  no
    type: number
    sql: ${warehouse_stock.sum_stock_quantity} / NULLIF(${avg_daily_item_quantity_last_1d}, 0);;
    value_format: "0.0"
  }

  measure: pct_stock_range_3d {
    group_label: "* Operations / Logistics *"
    label: "Stock Range [days, based on 3d avg.]"
    description: "Current stock divided by 3d AVG Daily Sales"
    hidden:  no
    type: number
    sql: ${warehouse_stock.sum_stock_quantity} / NULLIF(${avg_daily_item_quantity_last_3d}, 0);;
    value_format: "0.0"
  }

  measure: pct_stock_range_7d {
    group_label: "* Operations / Logistics *"
    label: "Stock Range [days, based on 7d avg.]"
    description: "Current stock divided by 7d AVG Daily Sales"
    hidden:  no
    type: number
    sql: ${warehouse_stock.sum_stock_quantity} / NULLIF(${avg_daily_item_quantity_last_7d}, 0);;
    value_format: "0.0"
  }

  measure: sum_item_price_gross {
    group_label: "* Monetary Values *"
    label: "SUM Item Prices sold (gross)"
    description: "Sum of sold Item prices (incl. VAT)"
    hidden:  no
    type: sum
    sql: ${quantity} * ${unit_price_gross_amount};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_item_price_net {
    group_label: "* Monetary Values *"
    label: "SUM Item Prices sold (net)"
    description: "Sum of sold Item prices (excl. VAT)"
    hidden:  no
    type: sum
    sql: ${quantity} * ${unit_price_net_amount};;
    value_format_name: euro_accounting_2_precision
  }


}
