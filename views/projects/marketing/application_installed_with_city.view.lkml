view: application_installed_with_city {
  derived_table: {
    sql:
      -- merge android and ios installations
      WITH union_tb AS (
          SELECT
              anonymous_id,
              timestamp AS installation_timestamp,
              context_locale,
              context_device_type AS device_type,
              row_number() OVER (PARTITION BY id) AS row_number
          FROM `flink-data-prod.flink_android_production.application_installed` android
          WHERE TRUE
          QUALIFY row_number=1

          UNION ALL

          SELECT
              anonymous_id,
              timestamp AS installation_timestamp,
              context_locale,
              context_device_type AS device_type,
              row_number() OVER (PARTITION BY id) AS row_number
          FROM `flink-data-prod.flink_ios_production.application_installed` ios
          WHERE TRUE
          QUALIFY row_number=1
      ),

      joined_tb AS (
        SELECT
          sessions.anonymous_id,
          sessions.city,
          sessions.country_iso,
          sessions.hub_code,
          sessions.session_start_at,
          install.installation_timestamp,
          install.device_type,
          install.context_locale,
          ROW_NUMBER() over (partition by sessions.anonymous_id order by session_start_at) as row_number,
          FIRST_VALUE(city IGNORE NULLS) OVER (PARTITION BY sessions.anonymous_id ORDER BY session_start_at ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS first_city,
          FIRST_VALUE(hub_code IGNORE NULLS) OVER (PARTITION BY sessions.anonymous_id ORDER BY session_start_at ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS first_hub_code,
          FIRST_VALUE(country_iso IGNORE NULLS) OVER (PARTITION BY sessions.anonymous_id ORDER BY session_start_at ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS first_country
        FROM `flink-data-prod.curated.app_sessions_full_load` sessions
        LEFT JOIN union_tb install
            ON sessions.anonymous_id=install.anonymous_id
        WHERE TRUE
        QUALIFY row_number=1
      )

      SELECT
        joined_tb.*,
        COALESCE(first_country, SUBSTRING(context_locale,4,2)) AS derived_country,
        INITCAP(COALESCE(hubs.city, first_city)) AS derived_city
      FROM joined_tb
      LEFT JOIN `flink-data-prod.curated.hubs` hubs
          ON joined_tb.first_hub_code=hubs.hub_code
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: cnt_missing_installations {
    type: count
    filters: [installation_timestamp_date: "NULL"]
    drill_fields: [detail*]
  }

  dimension: anonymous_id {
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension_group: session_start_at {
    description: "When the session started from which location information was derived for the user"
    type: time
    sql: ${TABLE}.session_start_at ;;
    datatype: timestamp
    timeframes: [
      raw,
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
  }

  dimension_group: session_end_at {
    hidden: yes
    description: "When the session ended from which location information was derived for the user"
    type: time
    sql: ${TABLE}.session_end_at ;;
    datatype: timestamp
    timeframes: [
      raw,
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
  }

  dimension_group: installation_timestamp {
    type: time
    sql: ${TABLE}.installation_timestamp ;;
    datatype: timestamp
    timeframes: [
      raw,
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
  }

  dimension: device_type {
    type: string
    label: "Platform"
    description: "iOS or Android"
    sql: ${TABLE}.device_type ;;
  }

  dimension: derived_city {
    type: string
    label: "City"
    description: "The first city the user selected as a location"
    sql: ${TABLE}.derived_city ;;
  }

  dimension: derived_country {
    type: string
    label: "Country ISO"
    description: "The first Country ISO the user selected as a location or no address selection information available, based on device settings"
    sql: ${TABLE}.derived_country ;;
  }

  dimension: country_filter {
    hidden: yes
    description: "Country ISO where countries outside of Flink operations are grouped together for filtering purposes"
    type: string
    case: {
      when: {
        sql: ${derived_country} = "DE" ;;
        label: "DE"
      }
      when: {
        sql: ${derived_country} = "FR" ;;
        label: "FR"
      }
      when: {
        sql: ${derived_country} = "NL" ;;
        label: "NL"
      }
      when: {
        sql: ${derived_country} = "AT" ;;
        label: "AT"
      }
      else: "Other"
    }
  }

  dimension: first_hub_code {
    type: string
    label: "Hub Code"
    description: "The first hub code the user selected as a location"
    sql: ${TABLE}.first_hub_code ;;
  }

  set: detail {
    fields: [
      anonymous_id,
      installation_timestamp_date,
      device_type,
      derived_city,
      first_hub_code,
      derived_country
    ]
  }
}
