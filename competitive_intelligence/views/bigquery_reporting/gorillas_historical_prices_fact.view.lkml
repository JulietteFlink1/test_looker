view: gorillas_historical_prices_fact {
  sql_table_name: `flink-data-prod.reporting.gorillas_historical_prices_fact`
    ;;

  dimension: product_id {
    type: string
    sql: ${TABLE}.product_id ;;
    hidden: yes
    primary_key: yes
  }

  dimension: avg_price_today {
    type: number
    group_label: "> Today"
    sql: ${TABLE}.avg_price ;;
    value_format: "€0.00"
  }

  dimension: avg_price_1_day_ago {
    type: number
    group_label: "> 1 Day Ago"
    sql: ${TABLE}.avg_price_1_day_ago ;;
    value_format: "€0.00"
  }

  dimension: avg_price_28_days_ago {
    type: number
    group_label: "> 28 Days Ago"
    sql: ${TABLE}.avg_price_28_days_ago ;;
    value_format: "€0.00"
  }

  dimension: avg_price_7_days_ago {
    type: number
    group_label: "> 7 Days Ago"
    sql: ${TABLE}.avg_price_7_days_ago ;;
    value_format: "€0.00"
  }

  dimension: max_price_today {
    type: number
    group_label: "> Today"
    sql: ${TABLE}.max_price ;;
    value_format: "€0.00"
  }

  dimension: max_price_1_day_ago {
    type: number
    group_label: "> 1 Day Ago"
    sql: ${TABLE}.max_price_1_day_ago ;;
    value_format: "€0.00"
  }

  dimension: max_price_28_days_ago {
    type: number
    group_label: "> 28 Days Ago"
    sql: ${TABLE}.max_price_28_days_ago ;;
    value_format: "€0.00"
  }

  dimension: max_price_7_days_ago {
    type: number
    group_label: "> 7 Days Ago"
    sql: ${TABLE}.max_price_7_days_ago ;;
    value_format: "€0.00"
  }

  dimension: min_price_today {
    type: number
    group_label: "> Today"
    sql: ${TABLE}.min_price ;;
    value_format: "€0.00"
  }

  dimension: min_price_1_day_ago {
    type: number
    group_label: "> 1 Day Ago"
    sql: ${TABLE}.min_price_1_day_ago ;;
    value_format: "€0.00"
  }

  dimension: min_price_28_days_ago {
    type: number
    group_label: "> 28 Days Ago"
    sql: ${TABLE}.min_price_28_days_ago ;;
    value_format: "€0.00"
  }

  dimension: min_price_7_days_ago {
    type: number
    group_label: "> 7 Days Ago"
    sql: ${TABLE}.min_price_7_days_ago ;;
    value_format: "€0.00"
  }

  measure: 1_day_avg_price_diff {
    label: "1-Day Avg-Price Diff"
    description: "Average price today minus average price yesterday"
    hidden:  no
    type: sum_distinct
    group_label: "> 1 Day Ago"
    sql: ${avg_price_today} - ${avg_price_1_day_ago};;
    value_format: "€0.00"
  }

  measure: 7_day_avg_price_diff {
    label: "7-Day Avg-Price Diff"
    description: "Average price today minus average price 7 days ago"
    hidden:  no
    type: sum_distinct
    group_label: "> 7 Days Ago"
    sql: ${avg_price_today} - ${avg_price_7_days_ago};;
    value_format: "€0.00"
  }

  measure: 28_day_avg_price_diff {
    label: "28-Day Avg-Price Diff"
    description: "Average price today minus average price 28 days ago"
    hidden:  no
    type: sum_distinct
    group_label: "> 28 Days Ago"
    sql: ${avg_price_today} - ${avg_price_28_days_ago};;
    value_format: "€0.00"
  }

  measure: 1_day_min_price_diff {
    label: "1-Day Min-Price Diff"
    description: "Minimum price today minus minimum price yesterday"
    hidden:  no
    type: sum_distinct
    group_label: "> 1 Day Ago"
    sql: ${min_price_today} - ${min_price_1_day_ago};;
    value_format: "€0.00"
  }

  measure: 7_day_min_price_diff {
    label: "7-Day Min-Price Diff"
    description: "Minimum price today minus minimum price 7 days ago"
    hidden:  no
    type: sum_distinct
    group_label: "> 7 Days Ago"
    sql: ${min_price_today} - ${min_price_7_days_ago};;
    value_format: "€0.00"
  }

  measure: 28_day_min_price_diff {
    label: "28-Day Min-Price Diff"
    description: "Minimum price today minus minimum price 28 days ago"
    hidden:  no
    type: sum_distinct
    group_label: "> 28 Days Ago"
    sql: ${min_price_today} - ${min_price_28_days_ago};;
    value_format: "€0.00"
  }

  measure: 1_day_max_price_diff {
    label: "1-Day Max-Price Diff"
    description: "Maximum price today minus maximum price yesterday"
    hidden:  no
    type: sum_distinct
    group_label: "> 1 Day Ago"
    sql: ${max_price_today} - ${max_price_1_day_ago};;
    value_format: "€0.00"
  }

  measure: 7_day_max_price_diff {
    label: "7-Day Max-Price Diff"
    description: "Maximum price today minus maximum price 7 days ago"
    hidden:  no
    type: sum_distinct
    group_label: "> 7 Days Ago"
    sql: ${max_price_today} - ${max_price_7_days_ago};;
    value_format: "€0.00"
  }

  measure: 28_day_max_price_diff {
    label: "28-Day Max-Price Diff"
    description: "Maximum price today minus maximum price 28 days ago"
    hidden:  no
    type: sum_distinct
    group_label: "> 28 Days Ago"
    sql: ${max_price_today} - ${max_price_28_days_ago};;
    value_format: "€0.00"
  }

  # measure: 1_day_avg_price_change {
  #   label: "1-Day Avg-Price Percent Change"
  #   description: "Percentage change calculated as the 1-day average-price difference divided by the earlier average price"
  #   hidden:  yes
  #   group_label: "> 1 Day Ago"
  #   sql: ${1_day_avg_price_diff} / NULLIF(${avg_price_today},0);;
  #   value_format: "0.00%"
  # }

  # measure: 7_day_avg_price_change {
  #   label: "7-Day Avg-Price Percent Change"
  #   description: "Percentage change calculated as the 7-day average-price difference divided by the earlier average price"
  #   hidden:  yes
  #   group_label: "> 7 Days Ago"
  #   sql: ${7_day_avg_price_diff} / NULLIF(${avg_price_7_days_ago},0);;
  #   value_format: "0.00%"
  # }

  # measure: 28_day_avg_price_change {
  #   label: "28-Day Avg-Price Percent Change"
  #   description: "Percentage change calculated as the 28-day average-price difference divided by the earlier average price"
  #   hidden:  yes
  #   group_label: "> 28 Days Ago"
  #   sql: ${28_day_avg_price_diff} / NULLIF(${avg_price_28_days_ago},0);;
  #   value_format: "0.00%"
  # }

  # measure: 1_day_min_price_change {
  #   label: "1-Day Min-Price Percent Change"
  #   description: "Percentage change calculated as the 1-day minimum-price difference divided by the earlier minimum price"
  #   hidden:  yes
  #   group_label: "> 1 Day Ago"
  #   sql: ${1_day_min_price_diff} / NULLIF(${min_price_today},0);;
  #   value_format: "0.00%"
  # }

  # measure: 7_day_min_price_change {
  #   label: "7-Day Min-Price Percent Change"
  #   description: "Percentage change calculated as the 7-day minimum-price difference divided by the earlier minimum price"
  #   hidden:  yes
  #   group_label: "> 7 Days Ago"
  #   sql: ${7_day_min_price_diff} / NULLIF(${min_price_7_days_ago},0);;
  #   value_format: "0.00%"
  # }

  # measure: 28_day_min_price_change {
  #   label: "28-Day Min-Price Percent Change"
  #   description: "Percentage change calculated as the 28-day minimum-price difference divided by the earlier minimum price"
  #   hidden:  yes
  #   group_label: "> 28 Days Ago"
  #   sql: ${28_day_min_price_diff} / NULLIF(${min_price_28_days_ago},0);;
  #   value_format: "0.00%"
  # }

}
