view: gorillas_test {
  derived_table: {
    sql: with inv as (
          SELECT
              hub_code,
              product_id,
              scrape_id,
              time_scraped,
              quantity as current_quantity,
              LAG(quantity,1) OVER (PARTITION BY hub_code, product_id ORDER BY time_scraped) previous_quantity
          FROM `flink-data-dev.competitive_intelligence.gorillas_inv_test`
          where date(time_scraped) = date(current_date('Europe/Berlin'))
          order by 1,2,3,4,5 asc
      ),
      inv_movement as (
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
      )
      select
          hub_code,
          product_id,
          scrape_id,
          time_scraped,
          current_quantity,
          previous_quantity,
          count_purchased,
          count_restocked,
          row_number() over (partition by hub_code, product_id order by time_scraped desc) as scrape_rank
      From inv_movement
      WHERE count_purchased > 0 or count_restocked > 0
       ;;
  }

  dimension: hub_product_id {
    group_label: "* IDs *"
    type: string
    sql: concat(${product_id}, ${hub_code}) ;;
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

  dimension: quantity {
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

  dimension: scrape_rank {
    type: number
    sql: ${TABLE}.scrape_rank ;;
  }


  dimension: count_restocked {
    type: number
    sql: ${TABLE}.count_restocked ;;
  }



  measure: sum_purchased {
    type: sum
    sql: ${count_purchased} ;;
  }

  measure: sum_restocked {
    type: sum
    sql: ${count_restocked};;
  }




  set: detail {
    fields: [
      hub_code,
      product_id,
      scrape_id,
      time_scraped_time,
      quantity,
      previous_quantity,
      count_purchased,
      count_restocked,
      sum_purchased,
      sum_restocked
    ]
  }
}
