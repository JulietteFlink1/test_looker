view: investigation_location_pin {
  derived_table: {
    sql: WITH help_tb AS
      (SELECT
              CONCAT(delivery_lat, '-', delivery_lng) AS full_coordinates
            , COUNT(*) as total_freq
            , SUM(CASE WHEN (user_area_available=false) THEN 1 ELSE 0 END) as false_freq
        FROM `flink-backend.flink_android_production.location_pin_placed`
        WHERE DATE(_PARTITIONTIME) > "2021-07-16"
        GROUP BY 1
      ),

      help_tb2 AS
      (SELECT
              CONCAT(delivery_lat, '-', delivery_lng) AS full_coordinates
            , COUNT(*) as total_freq
            , SUM(CASE WHEN (user_area_available=false) THEN 1 ELSE 0 END) as false_freq
        FROM `flink-backend.flink_ios_production.location_pin_placed`
        WHERE DATE(_PARTITIONTIME) > "2021-07-16"
        GROUP BY 1
      ),
      combined_tb AS (
      SELECT
        total_freq AS location_freq
      , count(*) AS freq_freq
      , SUM(false_freq) AS false_freq
      , "android" AS platform
      FROM help_tb
      group by 1

      UNION ALL

      SELECT
        total_freq AS location_freq
      , count(*) AS freq_freq
      , SUM(false_freq) AS false_freq
      , "ios" AS platform
      FROM help_tb2
      group by 1
      )
      SELECT *
      , ROUND((false_freq /(freq_freq * location_freq ))*100, 2) AS perc_false
      FROM combined_tb
      ORDER BY 1
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: location_freq {
    type: number
    sql: ${TABLE}.location_freq ;;
  }

  dimension: freq_freq {
    type: number
    sql: ${TABLE}.freq_freq ;;
  }

  dimension: false_freq {
    type: number
    sql: ${TABLE}.false_freq ;;
  }

  dimension: platform {
    type: string
    sql: ${TABLE}.platform ;;
  }

  dimension: perc_false {
    type: number
    sql: ${TABLE}.perc_false ;;
  }

  set: detail {
    fields: [location_freq, freq_freq, false_freq, platform, perc_false]
  }
}
