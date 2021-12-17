view: ean_labels {
  sql_table_name: `flink-data-dev.sandbox_justine.ean_labels_clean`
    ;;

  dimension: bio {
    type: number
    sql: ${TABLE}.bio ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: ean {
    type: string
    primary_key: yes
    sql:cast( ${TABLE}.ean as string);;
  }

  dimension: european {
    type: number
    sql: ${TABLE}.european ;;
  }

  dimension: fair_trade {
    type: number
    sql: ${TABLE}.fair_trade ;;
  }

  dimension: glutenfree {
    type: number
    sql: ${TABLE}.glutenfree ;;
  }

  dimension: green_dot {
    type: number
    sql: ${TABLE}.green_dot ;;
  }

  dimension: labels {
    type: string
    sql: ${TABLE}.labels ;;
  }

  dimension: low_salt {
    type: number
    sql: ${TABLE}.low_salt ;;
  }

  dimension: made_in_france {
    type: number
    sql: ${TABLE}.made_in_france ;;
  }

  dimension: made_in_germany {
    type: number
    sql: ${TABLE}.made_in_germany ;;
  }

  dimension: nutrition_score {
    type: string
    sql: ${TABLE}.nutrition_score ;;
  }

  dimension: organic {
    type: number
    sql: ${TABLE}.organic ;;
  }

  dimension: rainforest_alliance {
    type: number
    sql: case when ${labels} like '%utz%' then 1 else ${TABLE}.rainforest_alliance end ;;
  }

  dimension: sku {
    type: string
    sql:cast( ${TABLE}.sku as string) ;;
  }

  dimension: sustainable_farming {
    type: number
    sql: ${TABLE}.sustainable_farming ;;
  }

  dimension: vegan {
    type: number
    sql: ${TABLE}.vegan ;;
  }

  dimension: vegetarian {
    type: number
    sql: ${TABLE}.vegetarian ;;
  }

  dimension: without_addition {
    type: number
    sql: ${TABLE}.without_addition ;;
  }

  dimension: without_conservatives {
    type: number
    sql: ${TABLE}.without_conservatives ;;
  }

  dimension: without_lactose {
    type: number
    sql: ${TABLE}.without_lactose ;;
  }

  dimension: without_milk {
    type: number
    sql: ${TABLE}.without_milk ;;
  }

  dimension: without_sugar {
    type: number
    sql: ${TABLE}.without_sugar ;;
  }

  dimension: without_sulfite {
    type: number
    sql: ${TABLE}.without_sulfite ;;
  }

  measure: avg_rainforest_alliance {
    type: average
    sql: ${rainforest_alliance} ;;
    value_format: "0%"
  }

  measure: avg_made_in_germany {
    type: average
    sql: ${made_in_germany} ;;
    value_format: "0%"
  }

  measure: avg_bio {
    type: average
    sql: ${bio} ;;
    value_format: "0%"
  }

  measure: avg_vegan {
    type: average
    sql: ${vegan} ;;
    value_format: "0%"
  }


  measure: count {
    type: count
    drill_fields: []
  }
}
