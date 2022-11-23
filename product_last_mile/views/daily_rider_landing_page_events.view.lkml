# Owner: Bastian Gerstner
# Created: 2022-11-23
# Stakeholder: Last Mile Product

# This view contains all behavioural events that we track on the rider landing page

view: daily_rider_landing_page_events {
  sql_table_name: `flink-data-prod.curated.daily_rider_landing_page_events`;;
  view_label: "Daily Rider Landing Page Events "

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Dimensions    ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  # ======= IDs ======= #

  dimension: anonymous_id {
    group_label: "IDs"
    label: "Anonymous ID"
    description: "User ID set by Segment"
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }
  dimension: event_uuid {
    group_label: "IDs"
    label: "Event UUID"
    type: string
    description: "Unique ID for each event defined by Segment."
    sql: ${TABLE}.event_uuid ;;
  }

  # ======= Generic Dimensions ======= #

  dimension: component_content {
    group_label: "Generic Dimensions"
    label: "Component Content"
    type: string
    description: "To distinguish between different elements inside the component or for repetitive UI components where the content differs."
    sql: ${TABLE}.component_content ;;
  }
  dimension: component_name {
    group_label: "Generic Dimensions"
    label: "Component Name"
    type: string
    description: "Name of the UI component shown or interacted with. This value should be consistent across all locations where the component is shown."
    sql: ${TABLE}.component_name ;;
  }
  dimension: event_name {
    group_label: "Generic Dimensions"
    label: "Event Name"
    type: string
    description: "Name of an event triggered."
    sql: ${TABLE}.event_name ;;
  }
  dimension: event_origin {
    group_label: "Generic Dimensions"
    label: "Event Origin"
    type: string
    description: "Previous screen or UI component that led to the current screen or UI component"
    sql: ${TABLE}.event_origin ;;
  }

  # ======= Device Dimensions ======= #

  dimension: context_device_type {
    group_label: "Device Dimensions"
    label: "Device Type"
    description: "Information about browser & device used by user"
    type: string
    sql: ${TABLE}.context_device_type ;;
  }

  # ======= Location Dimensions ======= #

  dimension: country_iso {
    group_label: "Location Dimensions"
    label: "Country ISO"
    type: string
    description: "Country based on page URL"
    sql: ${TABLE}.country_iso ;;
  }
  dimension: locale {
    group_label: "Location Dimensions"
    label: "Locale"
    type: string
    description: "Locale on the device."
    sql: ${TABLE}.locale ;;
  }

  # ======= UTM Dimensions ======= #

  dimension: utm_campaign {
    group_label: "UTM Dimensions"
    label: "UTM Campaign"
    type: string
    description: "Used to identify which ads campaign this referral references."
    sql: ${TABLE}.utm_campaign ;;
  }
  dimension: utm_campaign_content {
    group_label: "UTM Dimensions"
    label: "UTM Campaign Content"
    type: string
    description: "Used for A/B testing and content-targeted ads.
    Can be used to differentiate ads or links that point to the same URL."
    sql: ${TABLE}.utm_campaign_content ;;
  }
  dimension: utm_campaign_id {
    group_label: "UTM Dimensions"
    label: "UTM Campaign ID"
    type: string
    description: "Unique ID number that can be used to identify each ad in your Google Ads account."
    sql: ${TABLE}.utm_campaign_id ;;
  }
  dimension: utm_campaign_term {
    group_label: "UTM Dimensions"
    label: "UTM Campaign Term"
    type: string
    description: "Used for paid search, specifically to identify the keywords used to target this ad."
    sql: ${TABLE}.utm_campaign_term ;;
  }
  dimension: utm_medium {
    group_label: "UTM Dimensions"
    label: "UTM Campaign Medium"
    type: string
    description: "Used to identify a medium such as email or cost-per-click."
    sql: ${TABLE}.utm_medium ;;
  }
  dimension: utm_source {
    group_label: "UTM Dimensions"
    label: "UTM Campaign Source"
    type: string
    description: "Used to identify a search engine, newsletter name, or other source."
    sql: ${TABLE}.utm_source ;;
  }

  # ======= Page Dimensions ====== #

  dimension: page_path {
    group_label: "Page Dimensions"
    label: "Page Path"
    description: "Page path after domain extraced from URL"
    type: string
    sql: ${TABLE}.page_path ;;
  }
  dimension: page_referrer {
    group_label: "Page Dimensions"
    label: "Page Referrer"
    type: string
    description: "Optional HTTP header field that identifies the address of the web page."
    sql: ${TABLE}.page_referrer ;;
  }
  dimension: page_title {
    group_label: "Page Dimensions"
    label: "Page Path"
    type: string
    description: "SEO title used to describe the content and purpose of a webpage."
    sql: ${TABLE}.page_title ;;
  }
  dimension: page_url {
    group_label: "Page Dimensions"
    label: "Page URL"
    type: string
    description: "Specific page url for users on web."
    sql: ${TABLE}.page_url ;;
  }

  # ======= Dates / Timestamps =======

  dimension_group: event_timestamp {
    type: time
    description: "Timestamp when an event was triggered within the app / web."
    timeframes: [
      time,
      date,
      week,
      month
    ]
    sql: ${TABLE}.event_timestamp ;;
  }

  # ======= HIDDEN Dimensions ======= #

  dimension_group: received_at_timestamp {
    hidden: yes
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
    sql: ${TABLE}.received_at_timestamp ;;
  }
  dimension: user_id {
    hidden: yes
    type: string
    sql: ${TABLE}.user_id ;;
  }
  dimension: event_text {
    hidden: yes
    type: string
    sql: ${TABLE}.event_text ;;
  }
  dimension: page_search {
    hidden:  yes
    type: string
    sql: ${TABLE}.page_search ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~      Measures     ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  measure: events {
    group_label: "Measures"
    label: "# Events"
    description: "Number of events triggered by users"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
  }
  measure: logged_in_anonymous_users {
    group_label: "Measures"
    label: "# All Users"
    description: "Number of all users based on anonymousID"
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
  }
}
