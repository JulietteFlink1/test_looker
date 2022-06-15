view: product_feedback_cleaned {
  sql_table_name: `flink-data-dev.sandbox.product_feedback_cleaned`
    ;;

  dimension_group: date {
    label: "Submission Response"
    description: "Date when we received the Customer Feedback Response"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.date ;;
  }

  dimension: phrases_matches {
    label: "Customer Comments"
    description: "This field reflects all the comments we are receiving from our customers"
    group_label: "Feedback Comments"
    type: string
    sql: ${TABLE}.phrases_matches ;;
  }

  dimension: stemmed_words {
    label: "Root Keyword Product"
    description: "This field reflects the root keyword that we use to match all the Product Name/Type/Category/etc. found in
                  multiple comments. E.g. Veg-- (Vegan/Veganz/Veggetarian)"
    group_label: "Feedback Comments"
    hidden: yes
    type: string
    sql: ${TABLE}.stemmed_words ;;
  }

  dimension: word_matches {
    label: "Keyword Product"
    description: "This field reflects the Keyword (Product Name/Type/Category/etc.) we could identify from the comments
                  received from our customers (Since a Customer Comments is a free text field, we could receive
                  for example a long text with just one word that actually refers to a product"
    group_label: "Feedback Comments"
    type: string
    sql: ${TABLE}.word_matches ;;
  }

  measure: count {
    label: "Count of Comments"
    type: count
    drill_fields: []
  }
}
