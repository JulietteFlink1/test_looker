view: web_attribution {
  # sql_table_name: `flink-data-prod.reporting.daily_web_attribution`;;
  sql_table_name: `flink-data-dev.dbt_nwierzbowska.daily_web_attribution`;;


  ############   Diemnsions   ############

  dimension: web_attribution_uuid {
    description: "Unique id of daily attribution model for web"
    type: string
    sql: ${TABLE}.web_attribution_uuid ;;
    primary_key: yes
    hidden: yes
  }

  dimension: anonymous_id {
    description: "Anonymous id"
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension_group: event_date {
    type: time
    timeframes: [
      date,
      week,
      month,
      year
    ]
    sql: CAST(${TABLE}.event_date AS DATE) ;;
    datatype: date
  }

  dimension: event_date_granularity {
    group_label: "Date Dimensions"
    label: "Event Date (Dynamic)"
    label_from_parameter: timeframe_picker
    type: string # cannot have this as a time type. See this discussion: https://community.looker.com/lookml-5/dynamic-time-granularity-opinions-16675
    hidden:  yes
    sql:
      {% if timeframe_picker._parameter_value == 'Day' %}
        ${event_date_date}
      {% elsif timeframe_picker._parameter_value == 'Week' %}
        ${event_date_week}
      {% elsif timeframe_picker._parameter_value == 'Month' %}
        ${event_date_month}
      {% endif %};;
  }

  parameter: timeframe_picker {
    group_label: "Date Dimensions"
    label: "Event Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }

  dimension: page_url {
    description: "First visited Page URL"
    type: string
    sql: ${TABLE}.page_url ;;
  }

  dimension: page_path {
    description: "First visited Page path"
    type: string
    sql: ${TABLE}.page_path ;;
  }

  dimension: page_referrer {
    description: "Page preceeding firts hit on flink hostname"
    type: string
    sql: ${TABLE}.page_referrer ;;
  }

  dimension: utm_source {
    description: "First UTM Source attributed to web daily visit "
    type: string
    sql: ${TABLE}.utm_source ;;
  }

  dimension: utm_medium {
    description: "First UTM Medium attributed to web daily visit "
    type: string
    sql: ${TABLE}.utm_medium ;;
  }

  dimension: utm_campaign {
    description: "UTM Campaign attributed to web daily visit used to identify which ads campaign this referral references"
    type: string
    sql: ${TABLE}.utm_campaign ;;
  }

  dimension: utm_campaign_term {
    description:  "UTM Campaign Term used for paid search to identify the keywords used to target this ad. "
    type: string
    sql: ${TABLE}.utm_campaign_term ;;
  }

  dimension: utm_campaign_content {
    description:  "UTM Campaign Term used to differentiate ads or links that point to the same URL."
    type: string
    sql: ${TABLE}.utm_campaign_content ;;
  }

  dimension: campaign_id {
    description:  "The unique ID number that can be used to identify each ad in your Google Ads account."
    type: string
    sql: ${TABLE}.campaign_id ;;
  }

  dimension: adgroup_id {
    description: "The unique ID number that can be used to identify an adgroup in Google Ads account."
    type: string
    sql: ${TABLE}.adgroup_id ;;
  }

  dimension: creative_id {
    description: "Google Ads Creative ID is a Dimension in Google Analytics under the Adwords section."
    type: string
    sql: ${TABLE}.adgroup_id ;;
  }

  dimension: is_webshop_visit {
    description: "Whether a user triggered a pageview on Flink's webshop."
    type: yesno
    sql: ${TABLE}.is_webshop_visit ;;
  }

  dimension: is_homepage_visit {
    description: "Whether a user triggered a pageview on Flink's homepage."
    type: yesno
    sql: ${TABLE}.is_homepage_visit ;;
  }

  dimension: is_recipe_lp_visit {
    description: "Whether a user triggered a pageview on Recipe Landing Page."
    type: yesno
    sql: ${TABLE}.is_recipe_lp_visit ;;
  }

  dimension: is_city_lp_visit {
    description: "Whether a user triggered a pageview on City Landing Page."
    type: yesno
    sql: ${TABLE}.is_city_lp_visit ;;
  }

  dimension: is_waitlist_visit {
    description: "Whether a user triggered a pageview on Waitlist Page."
    type: yesno
    sql: ${TABLE}.is_waitlist_visit ;;
  }

  dimension: landing_page {
    description: "Refers to the first page that user vsited on that day, categorised based on the url structure."
    type: string
    sql: ${TABLE}.landing_page ;;
  }

  dimension: has_landed_on_webshop {
    description: "Whether user has landed directly on webshop (no previous hit on homepage or lp)"
    type: yesno
    sql: case when ${TABLE}.landing_page = 'webshop' then true else false end ;;
  }

  dimension: is_landing_page_category {
    description: "Whether user has landed directly on webshop (no previous hit on homepage or lp)"
    type: string
    sql: case when ${TABLE}.page_path like '%city%' then 'city'
              when ${TABLE}.page_path like '%recipes%' then 'recipe'
               end ;;
  }


  ############ Measures   ############

  measure: count_users {
    description: "Unique count of anonymous_id"
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
  }

  measure: count_daily_users {
    description: "Count of daily unique visitors (based on web_attribution_uuid)"
    type: count_distinct
    sql: ${TABLE}.web_attribution_uuid ;;
  }


}
