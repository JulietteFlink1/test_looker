view: nps_comments_labeled {
  sql_table_name: `flink-data-prod.reporting.nps_comments_labeled`
    ;;

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: label {
    label: "Topic"
    hidden: yes
    type: string
    sql: ${TABLE}.label ;;
  }

  dimension: customer_type {
    type: string
    sql: ${TABLE}.customer_type ;;
  }

  dimension: label_transformed {
    label: "Topic"
    type: string
    sql: case when ${TABLE}.label = 'item_quality_prediction' then 'Item Quality'
              when ${TABLE}.label = 'delivery_time_prediction' then 'Delivery Time'
              when ${TABLE}.label = 'pricing_assortment_prediction' then 'Pricing Assortment'
              when ${TABLE}.label = 'pricing_delivery_fee_prediction' then 'Pricing Delivery Fee'
              when ${TABLE}.label = 'picking_prediction' then 'Picking'
              when ${TABLE}.label = 'oos_prediction' then 'OOS'
              when ${TABLE}.label = 'all_good_prediction' then 'All Good'
              when ${TABLE}.label = 'rider_behavior_prediction' then 'Rider Behavior'
              when ${TABLE}.label = 'product_ux_prediction' then 'Product/UX'
              when ${TABLE}.label = 'business_model_prediction' then 'Business Model'
              when ${TABLE}.label = 'customer_service_prediction' then 'Customer Service'
              when ${TABLE}.label = 'vouchers_prediction' then 'Vouchers'
              when ${TABLE}.label = 'product_selection_prediction' then 'Product Selection'
              else ${TABLE}.label end ;;
  }

  dimension: nps_driver {
    label: "NPS Comment"
    type: string
    sql: ${TABLE}.nps_driver ;;
  }

  dimension: nps_score {
    type: number
    sql: ${TABLE}.nps_score ;;
  }

  dimension: customer_group {
    type: string
    label: "Group"
    sql: case when ${nps_score}>=9 then 'Promoters'
              when ${nps_score}<=6 then 'Detractors'
              else 'Passives'
              end
      ;;
  }

  dimension: prediction {
    type: number
    sql: ${TABLE}.prediction ;;
  }

  dimension: response_uuid {
    primary_key: yes
    type: string
    sql: ${TABLE}.response_uuid ;;
  }

  dimension_group: submitted {
    group_label: "> Dates & Timestamps"
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
    sql: ${TABLE}.submitted_date ;;
  }

  parameter: date_granularity {
    group_label: "> Dates & Timestamps"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Month"
  }

  dimension: date {
    group_label: "> Dates & Timestamps"
    label: "Submitted Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${submitted_date}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${submitted_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${submitted_month}
    {% endif %};;
  }

  dimension: date_granularity_pass_through {
    group_label: "> Parameters"
    description: "To use the parameter value in a table calculation (e.g WoW, % Growth) we need to materialize it into a dimension "
    type: string
    hidden: no # yes
    sql:
            {% if date_granularity._parameter_value == 'Day' %}
              "Day"
            {% elsif date_granularity._parameter_value == 'Week' %}
              "Week"
            {% elsif date_granularity._parameter_value == 'Month' %}
              "Month"
            {% endif %};;
  }

  measure: num_responses {
    label: "# NPS Responses"
    type: count_distinct
    sql: ${response_uuid} ;;
  }

  measure: sum_predictions {
    label: "# Topic Occurrences"
    type: sum
    sql: ${prediction}
    ;;
  }

  dimension: nps {
    type: number
    sql: case when ${nps_score} >= 9 then 100
              when ${nps_score} <= 6 then -100
              else 0 end;;
  }

  measure: avg_nps {
    label: "AVG NPS"
    type: average
    sql: ${nps}
    ;;
    value_format:  "0"
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
