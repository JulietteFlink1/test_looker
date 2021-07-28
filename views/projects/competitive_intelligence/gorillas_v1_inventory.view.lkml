view: gorillas_v1_inventory {
  derived_table: {
    sql: with inv as (
          SELECT
              gorillas.hub_code,
              gorillas.product_id,
              gorillas.scrape_id,
              gorillas.time_scraped,
              gorillas.quantity as current_quantity,
              LAG(gorillas.quantity,1) OVER (PARTITION BY gorillas.hub_code, gorillas.product_id ORDER BY gorillas.time_scraped) previous_quantity
          FROM `flink-data-dev.gorillas_v1.inventory` gorillas
         where {% condition time_scraped_date %} gorillas.time_scraped {% endcondition %}
          order by 1,2,3,4,5 asc
      )
          SELECT
              hub_code,
              product_id,
              scrape_id,
              time_scraped,
              current_quantity,
              previous_quantity,
              CASE
                  WHEN previous_quantity > current_quantity THEN previous_quantity - current_quantity
                  ELSE 0
              END as count_purchased,
              CASE
                  WHEN previous_quantity < current_quantity THEN current_quantity - previous_quantity
                  ELSE 0
              END as count_restocked
          FROM inv
          order by 1,2,3,4,5 asc

 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: product_id {
    type: string
    sql: ${TABLE}.product_id ;;
  }

  dimension: scrape_id {
    type: string
    sql: ${TABLE}.scrape_id ;;
  }

  dimension_group: time_scraped {
    type: time
    sql: ${TABLE}.time_scraped ;;
  }

  dimension: current_quantity {
    type: number
    sql: ${TABLE}.current_quantity ;;
  }

  dimension: previous_quantity {
    type: number
    sql: ${TABLE}.previous_quantity ;;
  }

  dimension: count_purchased {
    type: number
    sql: ${TABLE}.count_purchased ;;
  }

  dimension: count_restocked {
    type: number
    sql: ${TABLE}.count_restocked ;;
  }

  dimension: revenue {
    type: number
    sql: ${gorillas_v1_items.price} * ${count_purchased} ;;
    value_format: "0.00€"
  }

  measure: sum_restocked {
    type: sum
    sql: ${count_restocked} ;;
  }

  measure: sum_purchased {
    type: sum
    sql: ${count_purchased} ;;
  }

  measure: sum_revenue {
    type: sum
    sql: ${revenue} ;;
    value_format: "0.00€"
  }

  set: detail {
    fields: [
      hub_code,
      product_id,
      scrape_id,
      time_scraped_time,
      current_quantity,
      previous_quantity,
      count_purchased,
      count_restocked
    ]
  }
}
