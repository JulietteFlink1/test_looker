view: gorillas_test {
  derived_table: {
    # date(current_date('Europe/Berlin'))
    sql: WITH gorillas_test AS (with inv as (
          SELECT
              gorillas.hub_code,
              gorillas.product_id,
              gorillas.scrape_id,
              gorillas.time_scraped,
              gorillas.quantity as current_quantity,
              LAG(gorillas.quantity,1) OVER (PARTITION BY gorillas.hub_code, gorillas.product_id ORDER BY gorillas.time_scraped) previous_quantity
          FROM `flink-data-dev.competitive_intelligence.gorillas_inv_test` gorillas
          where {% condition time_scraped_date %} gorillas.time_scraped {% endcondition %}

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
       )
  ,  gorillas_current_assortment AS (with gorillas_items as (
          SELECT
          gorillas.time_scraped as assortment_time_scraped,
          gorillas.hub_code,
          gorillas.sku,
          gorillas.id,
          gorillas.price,
          gorillas.label,
          gorillas.category,
          row_number() over (partition by hub_code, id order by time_scraped desc) as scrape_rank
          FROM `flink-data-dev.competitive_intelligence.gorillas_items` gorillas
          WHERE {% condition assortment_time_scraped_date %} gorillas.time_scraped {% endcondition %}
      )
      select * from gorillas_items where scrape_rank=1
       )
SELECT
    gorillas_test.hub_code  AS hub_code,
    gorillas_test.time_scraped AS time_scraped,
    gorillas_test.product_id  AS product_id,
    gorillas_current_assortment.price  AS price,
    gorillas_test.current_quantity  AS quantity,
    gorillas_test.scrape_id  AS scrape_id,
    concat(gorillas_test.product_id, gorillas_test.hub_code)  AS hub_product_id,
    gorillas_current_assortment.label  AS label,
    gorillas_test.count_restocked,
    gorillas_test.count_purchased,
    gorillas_current_assortment.category  AS category,
    gorillas_current_assortment.assortment_time_scraped as assortment_time_scraped,
    gorillas_test.count_purchased * gorillas_current_assortment.price as revenue
FROM gorillas_test
LEFT JOIN gorillas_current_assortment ON gorillas_test.product_id = gorillas_current_assortment.id and gorillas_test.hub_code = gorillas_current_assortment.hub_code
WHERE (( gorillas_test.count_purchased   > 0) OR ( gorillas_test.count_restocked   > 0))
 ;;
  }

  dimension: unique_id {
    group_label: "* IDs *"
    primary_key: yes
    type: string
    sql: concat(${scrape_id}, ${hub_code},${product_id}) ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension_group: time_scraped {
    type: time
    description: "bq-datetime"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      hour_of_day
    ]
    sql: ${TABLE}.time_scraped ;;
  }

  dimension_group: assortment_time_scraped {
    type: time
    description: "bq-datetime"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      hour_of_day
    ]
    sql: ${TABLE}.assortment_time_scraped ;;
  }

  dimension: product_id {
    type: string
    sql: ${TABLE}.product_id ;;
  }

  dimension: price {
    type: number
    sql: ${TABLE}.price ;;
  }

  dimension: quantity {
    type: number
    sql: ${TABLE}.quantity ;;
  }

  dimension: scrape_id {
    type: string
    sql: ${TABLE}.scrape_id ;;
  }

  dimension: hub_product_id {
    type: string
    sql: ${TABLE}.hub_product_id ;;
  }

  dimension: label {
    type: string
    sql: ${TABLE}.label ;;
  }

  dimension: count_restocked {
    type: number
    sql: ${TABLE}.count_restocked ;;
  }

  dimension: count_purchased {
    type: number
    sql: ${TABLE}.count_purchased ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: revenue {
    type: number
    sql: ${TABLE}.revenue ;;
  }

  measure: sum_revenue {
    type: sum
    sql: ${revenue} ;;
    value_format: "#,##0.00€"
  }

  measure: sum_purchased {
    type: sum
    sql: ${count_purchased} ;;
  }

  measure: sum_restocked {
    type: sum
    sql: ${count_restocked} ;;
  }

  measure: last_updated {
    type: time
    sql: MAX(${TABLE}.time_scraped) ;;
    convert_tz: no
  }


  set: detail {
    fields: [
      hub_code,
      time_scraped_time,
      product_id,
      price,
      quantity,
      scrape_id,
      hub_product_id,
      label,
      count_restocked,
      count_purchased,
      category,
      revenue,
      sum_purchased,
      sum_revenue,
      sum_revenue
    ]
  }
}
