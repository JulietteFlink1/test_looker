view: nps_hub_level {
  derived_table: {
    sql: WITH
        orders AS (
        SELECT
          id,
          country_iso,
          DATE(created) AS date,
          CASE
            WHEN JSON_EXTRACT_SCALAR(metadata, '$.warehouse') IN ('hamburg-oellkersallee', 'hamburg-oelkersallee') THEN 'de_ham_alto'
            WHEN JSON_EXTRACT_SCALAR(metadata, '$.warehouse') = 'münchen-leopoldstraße'                            THEN 'de_muc_schw'
            ELSE JSON_EXTRACT_SCALAR(metadata,'$.warehouse')
        END AS hub
        FROM `flink-backend.saleor_db_global.order_order`
        ),

        nps_vals as (
          SELECT
          -- dimensions
          nps.country_iso,
          nps.submitted_at,
          nps.score,
          nps.order_id,
          orders.hub as hub,
          orders.date as date,
          -- aggregates | measures
          -- using distinct, as I found duplicated order_ids in nps-table
          count(distinct nps.order_id) as cnt_responses,
          count(distinct if(nps.score between 0 and 6, nps.order_id, null)) as cnt_detractors,
          count(distinct if(nps.score between 7 and 8, nps.order_id, null)) as cnt_passives,
          count(distinct if(nps.score between 9 and 10, nps.order_id, null)) as cnt_promoters,

          FROM `flink-backend.gsheet_nps.results_global` nps
          LEFT JOIN orders
          ON
          orders.country_iso = nps.country_iso
          AND orders.id = nps.order_id
          group by 1,2,3,4,5,6
        )

      select nps_vals.date,
             nps_vals.hub,
             sum(cnt_responses)  as cnt_responses,
             sum(cnt_detractors) as cnt_detractors,
             sum(cnt_passives)   as cnt_passives,
             sum(cnt_promoters)  as cnt_promoters,
             -- sum(cnt_detractors) / IF(sum(cnt_responses) = 0, null, sum(cnt_responses)) as pct_detractors,
             -- sum(cnt_passives) / IF(sum(cnt_responses) = 0, null, sum(cnt_responses)) as pct_passives,
             -- sum(cnt_promoters) / IF(sum(cnt_responses) = 0, null, sum(cnt_responses)) as pct_promoters,
             -- sum(cnt_promoters) / IF(sum(cnt_responses) = 0, null, sum(cnt_responses)) - sum(cnt_detractors) / IF(sum(cnt_responses) = 0, null, sum(cnt_responses)) as nps_score
      from nps_vals
      group by 1,2
       ;;
  }

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    sql: CONCAT(${TABLE}.date, ${TABLE}.hub) ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~  DIMENSIONS        ~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: date {
    type: date
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension: hub {
    type: string
    sql: ${TABLE}.hub ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~  Hidden Fields     ~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  dimension: cnt_responses {
    label: "# NPS Responses"
    type: number
    sql: ${TABLE}.cnt_responses ;;
    hidden: yes
  }

  dimension: cnt_detractors {
    label: "# Detractors"
    type: number
    sql: ${TABLE}.cnt_detractors ;;
    hidden: yes
  }

  dimension: cnt_passives {
    label: "# Passives"
    type: number
    sql: ${TABLE}.cnt_passives ;;
    hidden: yes
  }

  dimension: cnt_promoters {
    label: "# Promoters"
    type: number
    sql: ${TABLE}.cnt_promoters ;;
    hidden: yes
  }

  # dimension: pct_detractors {
  #   type: number
  #   sql: ${TABLE}.pct_detractors ;;
  #   hidden: yes
  # }

  # dimension: pct_passives {
  #   type: number
  #   sql: ${TABLE}.pct_passives ;;
  #   hidden: yes
  # }

  # dimension: pct_promoters {
  #   type: number
  #   sql: ${TABLE}.pct_promoters ;;
  #   hidden: yes
  # }

  # dimension: nps_score {
  #   type: number
  #   sql: ${TABLE}.nps_score ;;
  #   hidden: yes
  # }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~  MEASURES          ~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: sum_cnt_promoters {
    type:  sum
    label: "# Promoters"
    description: "The number of answers of the NPS-survey, that have a value of 9 or 10 - these are very happy customers. \n\nPlease only use this field on a Hub + (optional) Date level"
    sql: ${cnt_promoters} ;;
    value_format: "#"
  }

  measure: sum_cnt_passives {
    type:  sum
    label: "# Passives"
    description: "The number of answers of the NPS-survey, that have a value of 7 or 8 - these are indecisive customers. \n\nPlease only use this field on a Hub + (optional) Date level"
    sql: ${cnt_passives} ;;
    value_format: "#"
  }

  measure: sum_cnt_detractors {
    type:  sum
    label: "# Detractors"
    description: "The number of answers of the NPS-survey, that have a value of 0 to 6 - these are very unhappy customers. \n\nPlease only use this field on a Hub + (optional) Date level"
    sql: ${cnt_detractors} ;;
    value_format: "#"
  }

  measure: sum_cnt_responses {
    type:  sum
    label: "# NPS Answers"
    description: "The number of answers of the NPS-survey. \n\nPlease only use this field on a Hub + (optional) Date level"
    sql: ${cnt_responses} ;;
    value_format: "#"
  }


  measure: avg_pct_promoters {
    type:  number
    label: "% Promoters"
    description: "The share of answers of the NPS-survey, that have a value of 9 or 10 - these are very happy customers. \n\nPlease only use this field on a Hub + (optional) Date level"
    sql: ${sum_cnt_promoters} / IF(${sum_cnt_responses} = 0, NULL, ${sum_cnt_responses}) ;;
    value_format: "0%"
  }

  measure: avg_pct_passives {
    type:  number
    label: "% Passives"
    description: "The share of answers of the NPS-survey, that have a value of 7 or 8 - these are indecisive customers. \n\nPlease only use this field on a Hub + (optional) Date level"
    sql: ${sum_cnt_passives} / IF(${sum_cnt_responses} = 0, NULL, ${sum_cnt_responses}) ;;
    value_format: "0%"
  }

  measure: avg_pct_detractors {
    type:  number
    label: "% Detractors"
    description: "The share of answers of the NPS-survey, that have a value of 0 to 6 - these are very unhappy customers. \n\nPlease only use this field on a Hub + (optional) Date level"
    sql: ${sum_cnt_detractors} / IF(${sum_cnt_responses} = 0, NULL, ${sum_cnt_responses}) ;;
    value_format: "0%"
  }

  measure: avg_nps_score {
    type:  number
    label: "% NPS"
    description: "The NPS-Score on a Hub-Level. The NPS-Score is defined as  (% Promoters - % Detractors). \n\nPlease only use this field on a Hub + (optional) Date level"
    sql: ${avg_pct_promoters} - ${avg_pct_detractors} ;;
    value_format: "0%"
  }


  set: detail {
    fields: [
      date,
      hub,
      cnt_responses,
      cnt_detractors,
      cnt_passives,
      cnt_promoters,
    ]
  }
}
