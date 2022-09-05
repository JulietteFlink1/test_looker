view: weekly_hubmanager_sendouts {
  derived_table: {
    sql:
      select *
      from flink-data-prod.reporting.weekly_hubmanager_sendouts;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: dimension {
    type: string
    sql: ${TABLE}.dimension ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: bucket {
    type: string
    sql: concat(${TABLE}.bucket, ' AVG Daily Orders') ;;
  }

  dimension: uuid {
    type: string
    primary_key: yes
    sql: concat(${hub_code},${week},${dimension}) ;;
  }

  dimension: number_of_orders {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_orders ;;
  }

  dimension: share_of_orders_fulfilled_before_targeted_estimate {
    alias: [share_of_orders_with_delta_pdt_less_than_2]
    type: number
    hidden: yes
    sql: ${TABLE}.share_of_orders_fulfilled_before_targeted_estimate ;;
  }

  dimension: share_of_orders_fulfilled_more_than_30 {
    alias: [share_of_orders_delivered_more_than_20,share_of_orders_fulfilled_more_than_20]
    type: number
    hidden: yes
    sql: ${TABLE}.share_of_orders_fulfilled_more_than_30 ;;
  }

  dimension: share_pre_order_issues {
    type: number
    hidden: yes
    sql: ${TABLE}.share_pre_order_issues ;;
  }

  dimension: fulfillment_time_minutes {
    type: number
    hidden: yes
    sql: ${TABLE}.fulfillment_time_minutes ;;
  }

  dimension: share_hub_related_post_order_issues {
    alias: [share_post_order_issues]
    type: number
    hidden: yes
    sql: ${TABLE}.share_hub_related_post_order_issues ;;
  }

  dimension: delta_punched_vs_forecasted {
    type: number
    hidden: yes
    sql: ${TABLE}.delta_punched_vs_forecasted ;;
  }


  dimension: nps {
    hidden: yes
    type: number
    sql: ${TABLE}.nps ;;
  }


  dimension: share_of_no_show {
    type: number
    hidden: yes
    sql: ${TABLE}.share_of_no_show ;;
  }

  dimension: share_external_rider_hours {
    type: number
    hidden: yes
    sql: ${TABLE}.share_external_rider_hours ;;
  }

  dimension: rider_utr {
    type: number
    hidden: yes
    sql: ${TABLE}.rider_utr ;;
  }

  dimension: picker_utr {
    type: number
    hidden: yes
    sql: ${TABLE}.picker_utr ;;
  }

  dimension: hub_staff_utr {
    type: number
    hidden: yes
    sql: ${TABLE}.hub_staff_utr ;;
  }

  dimension: stacking_rate {
    type: number
    hidden: yes
    sql: ${TABLE}.share_of_stacked_orders ;;
  }

  dimension: picking_time_per_item {
    type: number
    hidden: yes
    sql: ${TABLE}.picking_time_per_item_seconds ;;
  }

  dimension: percent_inbounded_fresh_in_3_hours_per_desadv {
    type: number
    hidden: yes
    sql: ${TABLE}.percent_inbounded_fresh_in_3_hours_per_desadv ;;
  }

  dimension: week {
    type: date
    datatype: date
    sql: ${TABLE}.week ;;
  }

  dimension: number_total_hubs_in_bucket {
    type: number
    value_format: "0"
    sql: ${TABLE}.number_total_hubs_in_bucket ;;
  }

  dimension: number_total_hubs_in_country {
    type: number
    value_format: "0"
    sql: ${TABLE}.number_total_hubs_in_country ;;
  }



  ################ Measures

  measure: avg_number_total_hubs_in_bucket {
    type: average
    value_format: "0"
    sql: ${number_total_hubs_in_bucket} ;;
  }

  measure: avg_number_total_hubs_in_country {
    type: average
    value_format: "0"
    sql: ${number_total_hubs_in_country} ;;
  }

  measure: first_tier_country {
    type: average
    value_format: "0"
    sql: ${number_total_hubs_in_country}/3 ;;
  }

  measure: second_tier_country {
    type: average
    value_format: "0"
    sql: ${number_total_hubs_in_country}/3*2 ;;
  }

  measure: third_tier_country {
    type: average
    value_format: "0"
    sql: ${number_total_hubs_in_country} ;;
  }

  measure: first_tier_bucket {
    type: average
    value_format: "0"
    sql: ${number_total_hubs_in_bucket}/3 ;;
  }

  measure: second_tier_bucket {
    type: average
    value_format: "0"
    sql: ${number_total_hubs_in_bucket}/3*2 ;;
  }

  measure: third_tier_bucket {
    type: average
    value_format: "0"
    sql: ${number_total_hubs_in_bucket} ;;
  }

  measure: sum_number_of_orders {
    label: "# Orders"
    type: sum
    value_format: "0"
    sql: ${number_of_orders} ;;
    html: {% if dimension._value == 'WoW' and value >= 0 %}
          <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center">+{{ value }} %</p>
          {% elsif dimension._value == 'WoW' and value < 0 %}
           <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center">{{ value }} %</p>
          <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
          {% elsif dimension._value == 'Last Week'  %}
          <p style="font-weight: bold">{{ rendered_value }}<p>
          {% elsif dimension._value == 'Previous Week' %}
          {{ rendered_value }}
          {% endif %} ;;
  }

  measure: avg_share_of_orders_fulfilled_before_targeted_estimate {
    alias: [avg_share_of_orders_with_delta_pdt_less_than_2]
    label: "% Orders Delivered in Time (Internal target)"
    description: "Share of orders delivered before the internal targeted estimate"
    type: average
    sql: ${share_of_orders_fulfilled_before_targeted_estimate} ;;
    value_format: "0.0%"
    html: {% if dimension._value == 'WoW' and value >= 0 %}
          <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/573/must_have/48/check.png" height=20 width=20>+{{ value }} pp</p>
          {% elsif dimension._value == 'WoW' and value < 0 %}
           <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/719/crystal_clear_actions/64/cancel.png" height=20 width=20>{{ value }} pp</p>
          {% elsif dimension._value == 'Ranking in Bucket' and  first_tier_bucket._value >= value %}
          <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
          {% elsif dimension._value == 'Ranking in Bucket' and  second_tier_bucket._value >= value %}
          <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Bucket' %}
          <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Country' and  first_tier_country._value >= value %}
          <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
          {% elsif dimension._value == 'Ranking in Country' and  second_tier_country._value >= value %}
          <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Country'  %}
          <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
          {% elsif dimension._value == 'Last Week'  %}
          <p style="font-weight: bold">{{ rendered_value }}<p>
          {% else %}
          {{ rendered_value }}
          {% endif %}  ;;
  }



  measure: avg_fulfillment_time_mimutes {
    label: "AVG Fulfillment Time"
    type: average
    sql: ${fulfillment_time_minutes} ;;
    value_format: "0.0"
    html: {% if dimension._value == 'WoW' and value <= 0 %}
          <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/573/must_have/48/check.png" height=20 width=20>{{ value }}% </p>
          {% elsif dimension._value == 'WoW' and value > 0 %}
           <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/719/crystal_clear_actions/64/cancel.png" height=20 width=20>+{{ value }}%</p>
          {% elsif dimension._value == 'Ranking in Bucket' and  first_tier_bucket._value >= value %}
          <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
          {% elsif dimension._value == 'Ranking in Bucket' and  second_tier_bucket._value >= value %}
          <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Bucket' %}
          <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Country' and  first_tier_country._value >= value %}
          <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
          {% elsif dimension._value == 'Ranking in Country' and  second_tier_country._value >= value %}
          <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Country'  %}
          <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
          {% elsif dimension._value == 'Last Week'  %}
          <p style="font-weight: bold">{{ rendered_value }}<p>
          {% else %}
          {{ rendered_value }}
          {% endif %}  ;;
  }

  measure: avg_share_of_orders_fulfilled_more_than_30 {
    alias: [avg_share_of_orders_delivered_more_than_20, avg_share_of_orders_fulfilled_more_than_20]
    label: "% Orders > 30min"
    description: "Share of Orders delivered in more than 30min"
    type: average
    value_format: "0.0%"
    sql: ${share_of_orders_fulfilled_more_than_30} ;;
    html: {% if dimension._value == 'WoW' and value <= 0 %}
          <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/573/must_have/48/check.png" height=20 width=20>{{ value }} pp</p>
          {% elsif dimension._value == 'WoW' and value > 0 %}
           <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/719/crystal_clear_actions/64/cancel.png" height=20 width=20>+{{ value }} pp</p>
          {% elsif dimension._value == 'Ranking in Bucket' and  first_tier_bucket._value >= value %}
          <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
          {% elsif dimension._value == 'Ranking in Bucket' and  second_tier_bucket._value >= value %}
          <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Bucket' %}
          <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Country' and  first_tier_country._value >= value %}
          <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
          {% elsif dimension._value == 'Ranking in Country' and  second_tier_country._value >= value %}
          <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Country'  %}
          <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
          {% elsif dimension._value == 'Last Week'  %}
          <p style="font-weight: bold">{{ rendered_value }}<p>
          {% else %}
          {{ rendered_value }}
          {% endif %} ;;
  }


  measure: avg_share_pre_order_issues {
    label: "% Pre Order Issue Rate"
    description: "Share of Orders with pre delivery issues"
    type: average
    value_format: "0.00%"
    sql: ${share_pre_order_issues} ;;
    html: {% if dimension._value == 'WoW' and value <= 0 %}
          <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/573/must_have/48/check.png" height=20 width=20>{{ value }} pp</p>
          {% elsif dimension._value == 'WoW' and value > 0 %}
           <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/719/crystal_clear_actions/64/cancel.png" height=20 width=20>+{{ value }} pp</p>
          {% elsif dimension._value == 'Ranking in Bucket' and  first_tier_bucket._value >= value %}
          <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
          {% elsif dimension._value == 'Ranking in Bucket' and  second_tier_bucket._value >= value %}
          <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Bucket' %}
          <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Country' and  first_tier_country._value >= value %}
          <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
          {% elsif dimension._value == 'Ranking in Country' and  second_tier_country._value >= value %}
          <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Country'  %}
          <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
          {% elsif dimension._value == 'Last Week'  %}
          <p style="font-weight: bold">{{ rendered_value }}<p>
          {% else %}
          {{ rendered_value }}
          {% endif %};;
  }

  measure: avg_share_post_order_issues {
    label: "% Post-Delivery Issues"
    description: "Share of Orders with post delivery issues related to hubs"
    type: average
    value_format: "0.00%"
    sql: ${share_hub_related_post_order_issues} ;;
    html:  {% if dimension._value == 'WoW' and value <= 0 %}
          <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/573/must_have/48/check.png" height=20 width=20>{{ value }} pp</p>
          {% elsif dimension._value == 'WoW' and value > 0 %}
           <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/719/crystal_clear_actions/64/cancel.png" height=20 width=20>+{{ value }} pp</p>
          {% elsif dimension._value == 'Ranking in Bucket' and  first_tier_bucket._value >= value %}
          <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
          {% elsif dimension._value == 'Ranking in Bucket' and  second_tier_bucket._value >= value %}
          <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Bucket' %}
          <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Country' and  first_tier_country._value >= value %}
          <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
          {% elsif dimension._value == 'Ranking in Country' and  second_tier_country._value >= value %}
          <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Country'  %}
          <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
          {% elsif dimension._value == 'Last Week'  %}
          <p style="font-weight: bold">{{ rendered_value }}<p>
          {% else %}
          {{ rendered_value }}
          {% endif %} ;;
  }

  measure: share_of_stacked_orders {
    label: "% Orders Stacked"
    description: "Share of orders that are stacked"
    type: average
    value_format: "0.0%"
    sql: ${stacking_rate} ;;
    html: {% if dimension._value == 'WoW' and value > 0 %}
          <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/573/must_have/48/check.png" height=20 width=20>+{{ value }} pp</p>
          {% elsif dimension._value == 'WoW' and value <= 0 %}
          <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/719/crystal_clear_actions/64/cancel.png" height=20 width=20>{{ value }} pp</p>
          {% elsif dimension._value == 'Last Week'  %}
          <p style="font-weight: bold">{{ rendered_value }}<p>
          {% elsif dimension._value == 'Previous Week' %}
          {{ rendered_value }}
          {% endif %} ;;
  }

  measure: avg_percent_inbounded_fresh_in_3_hours_per_desadv {
    label: "% of Fresh - Inbounded in 3h"
    description: "Share of fresh goods inbounded in 3 hours"
    type: average
    sql: ${percent_inbounded_fresh_in_3_hours_per_desadv} ;;
    value_format: "0.0%"
    html:   {% if dimension._value == 'WoW' and value >= 0 %}
            <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/573/must_have/48/check.png" height=20 width=20>+{{ value }} pp</p>
            {% elsif dimension._value == 'WoW' and value < 0 %}
            <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/719/crystal_clear_actions/64/cancel.png" height=20 width=20>{{ value }} pp</p>
            {% elsif dimension._value == 'Ranking in Bucket' and  first_tier_bucket._value >= value %}
            <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
            {% elsif dimension._value == 'Ranking in Bucket' and  second_tier_bucket._value >= value %}
            <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
             {% elsif dimension._value == 'Ranking in Bucket' %}
            <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
             {% elsif dimension._value == 'Ranking in Country' and  first_tier_country._value >= value %}
            <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
            {% elsif dimension._value == 'Ranking in Country' and  second_tier_country._value >= value %}
            <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
             {% elsif dimension._value == 'Ranking in Country'  %}
            <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
            {% elsif dimension._value == 'Last Week'  %}
            <p style="font-weight: bold">{{ rendered_value }}<p>
            {% else %}
            {{ rendered_value }}
            {% endif %}
          ;;
  }

  measure: avg_picking_time_per_item {
    label: "AVG Picking Time per Item (Seconds)"
    description: "AVG Time per item picked in seconds"
    type: average
    sql: ${picking_time_per_item} ;;
    value_format: "0.0"
    html: {% if dimension._value == 'WoW' and value <= 0 %}
          <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/573/must_have/48/check.png" height=20 width=20>{{ value }}% </p>
          {% elsif dimension._value == 'WoW' and value > 0 %}
           <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/719/crystal_clear_actions/64/cancel.png" height=20 width=20>+{{ value }}%</p>
          {% elsif dimension._value == 'Ranking in Bucket' and  first_tier_bucket._value >= value %}
          <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
          {% elsif dimension._value == 'Ranking in Bucket' and  second_tier_bucket._value >= value %}
          <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Bucket' %}
          <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Country' and  first_tier_country._value >= value %}
          <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
          {% elsif dimension._value == 'Ranking in Country' and  second_tier_country._value >= value %}
          <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Country'  %}
          <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
          {% elsif dimension._value == 'Last Week'  %}
          <p style="font-weight: bold">{{ rendered_value }}<p>
          {% else %}
          {{ rendered_value }}
          {% endif %}  ;;
  }

  measure: avg_share_no_show {
    label: "% No Show Rate"
    description: "Rider No Show Rate"
    type: average
    value_format: "0.0%"
    sql: ${share_of_no_show} ;;
    html:  {% if dimension._value == 'WoW' and value <= 0 %}
          <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/573/must_have/48/check.png" height=20 width=20>{{ value }} pp</p>
          {% elsif dimension._value == 'WoW' and value > 0 %}
           <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/719/crystal_clear_actions/64/cancel.png" height=20 width=20>+{{ value }} pp</p>
          {% elsif dimension._value == 'Ranking in Bucket' and  first_tier_bucket._value >= value %}
          <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
          {% elsif dimension._value == 'Ranking in Bucket' and  second_tier_bucket._value >= value %}
          <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Bucket' %}
          <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Country' and  first_tier_country._value >= value %}
          <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
          {% elsif dimension._value == 'Ranking in Country' and  second_tier_country._value >= value %}
          <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Country'  %}
          <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
          {% elsif dimension._value == 'Last Week'  %}
           <p style="font-weight: bold">{{ rendered_value }}<p>
          {% else %}
          {{ rendered_value }}
          {% endif %} ;;
  }

  measure: avg_delta_punched_vs_forecasted {
    label: "% Delta Punched vs Forecast"
    description: "(# Punched Hours - # Forecasted Hours)/# Forecasted Hours "
    type: average
    value_format: "0.0%"
    sql: ${delta_punched_vs_forecasted} ;;
    html:  {% if dimension._value == 'WoW' and value <= 0 %}
          <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/573/must_have/48/check.png" height=20 width=20>{{ value }} pp</p>
          {% elsif dimension._value == 'WoW' and value > 0 %}
           <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/719/crystal_clear_actions/64/cancel.png" height=20 width=20>+{{ value }} pp</p>
          {% elsif dimension._value == 'Ranking in Bucket' and  first_tier_bucket._value >= value %}
          <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
          {% elsif dimension._value == 'Ranking in Bucket' and  second_tier_bucket._value >= value %}
          <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Bucket' %}
          <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Country' and  first_tier_country._value >= value %}
          <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
          {% elsif dimension._value == 'Ranking in Country' and  second_tier_country._value >= value %}
          <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Country'  %}
          <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
          {% elsif dimension._value == 'Last Week'  %}
           <p style="font-weight: bold">{{ rendered_value }}<p>
          {% else %}
          {{ rendered_value }}
          {% endif %} ;;
  }

  measure: avg_share_external {
    label: "% External Rider Hours"
    description: "Rider External Share"
    type: average
    value_format: "0.0%"
    sql: ${share_external_rider_hours} ;;
    html:  {% if dimension._value == 'WoW' and value <= 0 %}
          <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/573/must_have/48/check.png" height=20 width=20>{{ value }} pp</p>
          {% elsif dimension._value == 'WoW' and value > 0 %}
           <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/719/crystal_clear_actions/64/cancel.png" height=20 width=20>+{{ value }} pp</p>
          {% elsif dimension._value == 'Ranking in Bucket' and  first_tier_bucket._value >= value %}
          <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
          {% elsif dimension._value == 'Ranking in Bucket' and  second_tier_bucket._value >= value %}
          <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Bucket' %}
          <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Country' and  first_tier_country._value >= value %}
          <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
          {% elsif dimension._value == 'Ranking in Country' and  second_tier_country._value >= value %}
          <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Country'  %}
          <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
          {% elsif dimension._value == 'Last Week'  %}
           <p style="font-weight: bold">{{ rendered_value }}<p>
          {% else %}
          {{ rendered_value }}
          {% endif %} ;;
  }

  measure: avg_rider_utr {
    label: "Rider UTR"
    type: average
    value_format: "0.00"
    sql: ${rider_utr} ;;
    html: {% if dimension._value == 'WoW' and value >= 0 %}
          <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center">+{{ rendered_value }}</p>
          {% elsif dimension._value == 'WoW' and value < 0 %}
           <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center">{{ rendered_value }}</p>
          {% elsif dimension._value == 'Ranking in Bucket' and  first_tier_bucket._value >= value %}
          <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
          {% elsif dimension._value == 'Ranking in Bucket' and  second_tier_bucket._value >= value %}
          <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Bucket' %}
          <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Country' and  first_tier_country._value >= value %}
          <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
          {% elsif dimension._value == 'Ranking in Country' and  second_tier_country._value >= value %}
          <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Country'  %}
          <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
          {% elsif dimension._value == 'Last Week'  %}
          <p style="font-weight: bold">{{ rendered_value }}<p>
          {% else %}
          {{ rendered_value }}
          {% endif %};;
  }

  measure: avg_picker_utr {
    label: "Picker UTR"
    type: average
    value_format: "0.00"
    sql: ${picker_utr} ;;
    html: {% if dimension._value == 'WoW' and value >= 0 %}
          <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/573/must_have/48/check.png" height=20 width=20>+{{ rendered_value }}</p>
          {% elsif dimension._value == 'WoW' and value < 0 %}
           <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/719/crystal_clear_actions/64/cancel.png" height=20 width=20>{{ rendered_value }}</p>
          {% elsif dimension._value == 'Ranking in Bucket' and  first_tier_bucket._value >= value %}
          <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
          {% elsif dimension._value == 'Ranking in Bucket' and  second_tier_bucket._value >= value %}
          <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Bucket' %}
          <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Country' and  first_tier_country._value >= value %}
          <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value | round:0 }} / {{avg_number_total_hubs_in_country._value | round:0}}</p>
          {% elsif dimension._value == 'Ranking in Country' and  second_tier_country._value >= value %}
          <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Country'  %}
          <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{_value | round:0}} / {{avg_number_total_hubs_in_country._value | round:0}}</p>
          {% elsif dimension._value == 'Last Week'  %}
          <p style="font-weight: bold">{{ rendered_value }}<p>
          {% else %}
          {{ rendered_value }}
          {% endif %};;
  }

  measure: avg_hub_staff_utr {
    label: "Hub Staff UTR"
    type: average
    value_format: "0.00"
    sql: ${hub_staff_utr} ;;
    html: {% if dimension._value == 'WoW' and value >= 0 %}
          <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/573/must_have/48/check.png" height=20 width=20>+{{ rendered_value }}</p>
          {% elsif dimension._value == 'WoW' and value < 0 %}
           <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center"><img src="http://findicons.com/files/icons/719/crystal_clear_actions/64/cancel.png" height=20 width=20>{{ rendered_value }}</p>
          {% elsif dimension._value == 'Ranking in Bucket' and  first_tier_bucket._value >= value %}
          <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
          {% elsif dimension._value == 'Ranking in Bucket' and  second_tier_bucket._value >= value %}
          <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Bucket' %}
          <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Country' and  first_tier_country._value >= value %}
          <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
          {% elsif dimension._value == 'Ranking in Country' and  second_tier_country._value >= value %}
          <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Country'  %}
          <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
          {% elsif dimension._value == 'Last Week'  %}
          <p style="font-weight: bold">{{ rendered_value }}<p>
          {% else %}
          {{ rendered_value }}
          {% endif %};;
  }

  measure: avg_nps {
    label: "NPS"
    type: average
    value_format: "0"
    sql: ${nps} ;;
    html: {% if dimension._value == 'WoW' and value >= 0 %}
          <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center">+{{ rendered_value }}</p>
          {% elsif dimension._value == 'WoW' and value < 0 %}
           <p style="color: black; background-color: lightgrey; font-size:100%; text-align:center">{{ rendered_value }}</p>
          {% elsif dimension._value == 'Ranking in Bucket' and  first_tier_bucket._value >= value %}
          <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
          {% elsif dimension._value == 'Ranking in Bucket' and  second_tier_bucket._value >= value %}
          <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Bucket' %}
          <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_bucket._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Country' and  first_tier_country._value >= value %}
          <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
          {% elsif dimension._value == 'Ranking in Country' and  second_tier_country._value >= value %}
          <p style="color: black; background-color: orange; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
           {% elsif dimension._value == 'Ranking in Country'  %}
          <p style="color: black; background-color: red; font-size:100%; text-align:center"># {{value | round}} / {{avg_number_total_hubs_in_country._value | round}}</p>
          {% elsif dimension._value == 'Last Week'  %}
           <p style="font-weight: bold">{{ rendered_value }}<p>
          {% else %}
          {{ rendered_value }}
          {% endif %};;
  }

  set: detail {
    fields: [
      dimension,
      hub_code,
      country_iso,
      bucket,
      number_of_orders,
      share_pre_order_issues,
      share_hub_related_post_order_issues,
      share_of_no_show,
      rider_utr,
      picker_utr,
      week
    ]
  }
}
