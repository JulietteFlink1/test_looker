view: bottom_10_hubs_nps {
  derived_table: {
    sql: with nps as (
          select hub_code
          , country_iso
          , date(submitted_at) as submitted_date
          , (((sum(is_promoter)/nullif(sum(is_nps_response), 0))* 100) - ((sum(is_detractor)/nullif(sum(is_nps_response), 0))* 100)) as nps_score
          from `flink-data-prod.curated.nps_after_order`
          group by 1, 2, 3
      ),

      nps_row as (select *
          , row_number() OVER (PARTITION BY submitted_date ORDER BY nps_score asc) as nps_rank
      from nps
      )

      select *
          , if(nps_rank<=10, 1, 0) as is_bottom_10_nps
      from nps_row
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: uuid {
    type: string
    sql: concat(${TABLE}.hub_code, cast(${TABLE}.submitted_date as string))
      ;;
    primary_key: yes
  }


  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: submitted_date {
    type: date
    datatype: date
    sql: ${TABLE}.submitted_date ;;
  }

  dimension: nps_score {
    type: number
    sql: ${TABLE}.nps_score ;;
  }

  dimension: nps_rank {
    type: number
    sql: ${TABLE}.nps_rank ;;
  }

  dimension: is_bottom_10_nps {
    type: number
    sql: ${TABLE}.is_bottom_10_nps ;;
  }

  measure: cnt_bottom_10_delivery {
    label: "# Bottom 10 for NPS"
    description: "The total number of times at bottom 10 for nps"
    type: sum
    sql: ${is_bottom_10_nps} ;;
  }

  set: detail {
    fields: [
      hub_code,
      country_iso,
      submitted_date,
      nps_score,
      nps_rank,
      is_bottom_10_nps
    ]
  }
}
