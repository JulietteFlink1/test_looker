view: order_forecasting_models {
  derived_table: {
    sql:
          WITH latest_forecast AS(
    SELECT country_iso,
        hub_code,
        start_timestamp,
        end_timestamp,
        model_name,
        MAX(job_date) AS job_date
    FROM `flink-data-prod.order_forecast.micro_forecasts_vs_actuals`
    GROUP BY 1, 2, 3, 4, 5
    ORDER BY 1, 2, 3 DESC
),

forecasts_vs_actuals as(

SELECT
    f.job_date,
    f.start_timestamp,
    f.end_timestamp,
    f.utc_date,
    f.local_date,
    f.local_start_time,
    f.country_iso,
    f.city,
    f.hub_code,
    f.is_open,
    f.model_name,
    f.prediction,
    f.observed_orders_total,
    f.live_model,
    f.missed_orders_forced_closure
FROM `flink-data-prod.order_forecast.micro_forecasts_vs_actuals` f
INNER JOIN latest_forecast l ON l.job_date = f.job_date AND l.country_iso = f.country_iso AND l.hub_code = f.hub_code AND l.start_timestamp = f.start_timestamp AND l.end_timestamp = f.end_timestamp AND f.model_name = l.model_name

UNION ALL

    SELECT
    f.job_date,
    f.start_timestamp,
    f.end_timestamp,
    f.utc_date,
    f.local_date,
    f.local_start_time,
    f.country_iso,
    f.city,
    f.hub_code,
    f.is_open,
    'actual_orders' as model_name,
    f.observed_orders_total as prediction,
    f.observed_orders_total,
    False as live_model,
    f.missed_orders_forced_closure
    FROM `flink-data-prod.order_forecast.micro_forecasts_vs_actuals` f
    INNER JOIN latest_forecast l ON l.job_date = f.job_date AND l.country_iso = f.country_iso AND l.hub_code = f.hub_code AND l.start_timestamp = f.start_timestamp AND l.end_timestamp = f.end_timestamp AND f.model_name = l.model_name
    WHERE live_model = TRUE
)

SELECT * from forecasts_vs_actuals
ORDER BY start_timestamp, job_date, hub_code
       ;;
  }


  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension_group: end_timestamp {
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
    sql: ${TABLE}.end_timestamp ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: is_open {
    type: number
    sql: ${TABLE}.is_open ;;
  }

  dimension_group: job {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.job_date ;;
  }

  dimension: live_model {
    type: yesno
    sql: ${TABLE}.live_model ;;
  }

  dimension_group: local {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.local_date ;;
  }

  dimension: local_start_time {
    type: string
    sql: ${TABLE}.local_start_time ;;
  }

  dimension: model_name {
    type: string
    sql: ${TABLE}.model_name ;;
  }



  dimension_group: start_timestamp {
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
    sql: ${TABLE}.start_timestamp ;;
  }


  dimension_group: utc {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.utc_date ;;
  }



  measure: observed_orders_total {
    label: "# Actual Orders"
    hidden: no
    type: sum
    sql: ${TABLE}.observed_orders_total;;
    value_format_name: decimal_0
  }


  measure: prediction {
    label: "# Predicted Orders"
    hidden: no
    type: sum
    sql: ${TABLE}.prediction;;
    value_format_name: decimal_0
  }



  measure: missed_orders_forced_closure {
    label: "# closure Missed Orders"
    hidden: no
    type: sum
    sql: ${TABLE}.missed_orders_forced_closure;;
    value_format_name: decimal_0
  }


}
