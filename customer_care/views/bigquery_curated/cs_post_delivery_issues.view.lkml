view: cs_post_delivery_issues {
  sql_table_name: `flink-data-prod.curated.cs_post_delivery_issues`
    ;;

  dimension: comment {
    label: "Issue Comment"
    type: string
    sql: ${TABLE}.comment ;;
  }

  dimension: post_delivery_issues_id {
    type: number
    primary_key:  yes
    sql: ${TABLE}.post_delivery_issues_uuid ;;
    group_label: "> IDs"
  }

  dimension: conversation_id {
    type: string
    sql: ${TABLE}.conversation_id ;;
    group_label: "> IDs"
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
    group_label: "> Geographic Data"
  }

  dimension: delivered_product {
    label: "Alternatively Delivered Product"
    type: string
    sql: ${TABLE}.delivered_product ;;
  }

  dimension: hub {
    label: "Hub Code"
    type: string
    sql: lower(${TABLE}.hub) ;;
  }

  dimension: ticket_date {
    type: date
    datatype: date
    sql: date(${TABLE}.issue_date) ;;
    group_label: "> Dates & Timestamps"
  }

  dimension: order_nr_ {
    type: string
    sql: ${TABLE}.order_nr_ ;;
    group_label: "> IDs"
  }

  dimension: ordered_product {
    type: string
    sql: ${TABLE}.ordered_product ;;
  }

  dimension: post_delivery_issues_uuid {
    type: number
    value_format_name: id
    sql: ${TABLE}.post_delivery_issues_uuid ;;
    group_label: "> IDs"
  }

  dimension: problem_group {
    type: string
    sql: ${TABLE}.problem_group ;;
  }

  measure: cnt_issues {
    label: "# Post Delivery Issues"
    type: count
    drill_fields: []
    group_label: "> Absolute Metrics - Order-Item Level"
  }

  measure: cnt_issues_wrong_product {
    label: "# Post Delivery Issues (Wrong Product)"
    type: count
    filters: [problem_group: "Wrong Product"]
    group_label: "> Absolute Metrics - Order-Item Level"
  }

  measure: cnt_issues_missing_product {
    label: "# Post Delivery Issues (Missing Product)"
    type: count
    filters: [problem_group: "Missing Product"]
    group_label: "> Absolute Metrics - Order-Item Level"
  }

  measure: cnt_issues_perished_product {
    label: "# Post Delivery Issues (Perished Product)"
    type: count
    filters: [problem_group: "Perished Product"]
    group_label: "> Absolute Metrics - Order-Item Level"
  }

  measure: cnt_issues_wrong_order {
    label: "# Post Delivery Issues (Wrong Order)"
    type: count
    filters: [problem_group: "Wrong Order"]
    group_label: "> Absolute Metrics - Order-Item Level"
  }

  measure: cnt_issues_damaged {
    label: "# Post Delivery Issues (Damaged)"
    type: count
    filters: [problem_group: "Damaged"]
    group_label: "> Absolute Metrics - Order-Item Level"
  }

  measure: cnt_unique_orders {
    label: "# Unique Orders with Post-Delivery Issue"
    description: "Count of Unique Orders which had a Contact"
    hidden:  no
    type: count_distinct
    sql: ${order_nr_};;
    value_format: "0"
    group_label: "> Absolute Metrics - Order Level"
  }

  measure: cnt_unique_orders_damaged {
    label: "# Unique Orders with Damaged Issue"
    description: "Count of Unique Orders which had a Contact for Damaged Product"
    hidden:  no
    type: count_distinct
    sql: ${order_nr_};;
    value_format: "0"
    filters: [problem_group: "Damaged"]
    group_label: "> Absolute Metrics - Order Level"
  }

  measure: cnt_unique_orders_wrong_product{
    label: "# Unique Orders with Wrong Product Issue"
    description: "Count of Unique Orders which had a Contact for Wrong Product"
    hidden:  no
    type: count_distinct
    sql: ${order_nr_};;
    value_format: "0"
    filters: [problem_group: "Wrong Product"]
    group_label: "> Absolute Metrics - Order Level"
  }

  measure: cnt_unique_orders_wrong_order{
    label: "# Unique Orders with Wrong Order Issue"
    description: "Count of Unique Orders which had a Contact for Wrong Order"
    hidden:  no
    type: count_distinct
    sql: ${order_nr_};;
    value_format: "0"
    filters: [problem_group: "Wrong Order"]
    group_label: "> Absolute Metrics - Order Level"
  }

  measure: cnt_unique_orders_missing_product{
    label: "# Unique Orders with Missing Product Issue"
    description: "Count of Unique Orders which had a Contact for Missing Product"
    hidden:  no
    type: count_distinct
    sql: ${order_nr_};;
    value_format: "0"
    filters: [problem_group: "Missing Product"]
    group_label: "> Absolute Metrics - Order Level"
  }

  measure: cnt_unique_orders_perished_product{
    label: "# Unique Orders with Perished Product Issue"
    description: "Count of Unique Orders which had a Contact for Perished Product"
    hidden:  no
    type: count_distinct
    sql: ${order_nr_};;
    value_format: "0"
    filters: [problem_group: "Perished Product"]
    group_label: "> Absolute Metrics - Order Level"
  }



  measure: pct_contact_rate {
    label: "% Contact Rate"
    group_label: "> Percentages"
    description: "# Post Delivery Issues divided by # Total Orders"
    hidden:  no
    type: number
    sql: ${cnt_issues} / NULLIF(${orders_cl.cnt_orders}, 0);;
    value_format: "0.0%"
  }

  measure: pct_unique_contact_rate {
    label: "% Contact Rate Unique Order"
    group_label: "> Percentages"
    description: "# Orders with Post Delivery Issues divided by # Total Orders"
    hidden:  no
    type: number
    sql: ${cnt_unique_orders} / NULLIF(${orders_cl.cnt_orders}, 0);;
    value_format: "0.0%"
  }

  parameter: problem_group_parameter {
    group_label: "* Parameter *"
    label: "Post-Delivery Issue"
    type: unquoted
    allowed_value: { value: "wrong_order" label: "Wrong Order"}
    allowed_value: { value: "wrong_product" label: "Wrong Product" }
    allowed_value: { value: "perished_product" label: "Perished Product" }
    allowed_value: { value: "missing_product" label: "Missing Product"}
    allowed_value: { value: "damaged" label: "Damaged"}
    allowed_value: { value: "all" label: "All"}
  }

  measure: total_issues_from_parameter {
    label: "# Total Issues (Selected Problem Group)"
    group_label: "> Absolute Metrics - Order-Item Level"
   # label_from_parameter: problem_group_parameter
   # value_format: "#,##0.00"
    type: number
    sql:
    {% if problem_group_parameter._parameter_value == 'wrong_order' %}
      ${cnt_issues_wrong_order}
    {% elsif problem_group_parameter._parameter_value == 'wrong_product' %}
      ${cnt_issues_wrong_product}
    {% elsif problem_group_parameter._parameter_value == 'perished_product' %}
      ${cnt_issues_perished_product}
    {% elsif problem_group_parameter._parameter_value == 'missing_product' %}
      ${cnt_issues_missing_product}
    {% elsif problem_group_parameter._parameter_value == 'damaged' %}
      ${cnt_issues_damaged}
    {% elsif problem_group_parameter._parameter_value == 'all' %}
      ${cnt_issues}
    {% endif %} ;;

  }

  measure: pct_total_issues_from_parameter {
    label: "% Orders with Issues (Selected Problem Group)"
    group_label: "> Percentages"
   # label_from_parameter: problem_group_parameter
    value_format: "0.0%"
    type: number
    sql:
    {% if problem_group_parameter._parameter_value == 'wrong_order' %}
      ${cnt_unique_orders_wrong_order}/NULLIF(${orders_cl.cnt_orders}, 0)
    {% elsif problem_group_parameter._parameter_value == 'wrong_product' %}
      ${cnt_unique_orders_wrong_product}/NULLIF(${orders_cl.cnt_orders}, 0)
    {% elsif problem_group_parameter._parameter_value == 'perished_product' %}
      ${cnt_unique_orders_perished_product}/NULLIF(${orders_cl.cnt_orders}, 0)
    {% elsif problem_group_parameter._parameter_value == 'missing_product' %}
      ${cnt_unique_orders_missing_product}/NULLIF(${orders_cl.cnt_orders}, 0)
    {% elsif problem_group_parameter._parameter_value == 'damaged' %}
      ${cnt_unique_orders_damaged}/NULLIF(${orders_cl.cnt_orders}, 0)
    {% elsif problem_group_parameter._parameter_value == 'all' %}
      ${cnt_unique_orders}/NULLIF(${orders_cl.cnt_orders}, 0)
    {% endif %} ;;

    }

  measure: unique_orders_wih_issue_from_parameter {
    label: "# Unique Orders with Issues (Selected Problem Group)"
    group_label: "> Percentages"
    # label_from_parameter: problem_group_parameter
    type: number
    sql:
    {% if problem_group_parameter._parameter_value == 'wrong_order' %}
      ${cnt_unique_orders_wrong_order}
    {% elsif problem_group_parameter._parameter_value == 'wrong_product' %}
      ${cnt_unique_orders_wrong_product}
    {% elsif problem_group_parameter._parameter_value == 'perished_product' %}
      ${cnt_unique_orders_perished_product}
    {% elsif problem_group_parameter._parameter_value == 'missing_product' %}
      ${cnt_unique_orders_missing_product}
    {% elsif problem_group_parameter._parameter_value == 'damaged' %}
      ${cnt_unique_orders_damaged}
    {% elsif problem_group_parameter._parameter_value == 'all' %}
      ${cnt_unique_orders}
    {% endif %} ;;

    }
}
