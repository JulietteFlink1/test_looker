# Owner: Patricia Mitterova
# Created: 2022-02-28

# This view contains all behavioural events and page views / screen views generated by users across web and app

view: daily_events {
    sql_table_name: `flink-data-prod.curated.daily_events`;;
    view_label: "Daily Events "

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Dimensions    ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  # ======= IDs ======= #

    dimension: event_uuid {
      group_label: "IDs"
      label: "Event UUID"
      description: "Unique identifier of an event"
      type: string
      primary_key: yes
      sql: ${TABLE}.event_uuid ;;
    }
    dimension: user_id {
      group_label: "IDs"
      label: "User ID"
      description: "User ID generated upon user registration"
      type: string
      sql: ${TABLE}.user_id ;;
    }
    dimension: anonymous_id {
      group_label: "IDs"
      label: "Anonymous ID"
      description: "User ID set by Segment"
      type: string
      sql: ${TABLE}.anonymous_id ;;
    }
    dimension: device_id {
      group_label: "IDs"
      label: "Device ID"
      description: "ID of an device"
      type: string
      sql: ${TABLE}.device_id ;;
    }

  # ======= Generic Dimensions ======= #

    dimension: is_user_logged_in {
      group_label: "Generic Dimensions"
      label: "Is User Logged-in"
      description: "Whether a user was logged-in when an event was triggered"
      type: yesno
      sql: ${TABLE}.is_user_logged_in ;;
    }
    dimension: has_selected_address {
      group_label: "Generic Dimensions"
      label: "Is Address Selected"
      description: "Whether a user had selected address when an event was triggered"
      type: yesno
      sql: ${TABLE}.has_selected_address ;;
    }
    dimension: event_name {
      group_label: "Generic Dimensions"
      label: "Event Name"
      description: "Name of the event triggered"
      type: string
      sql: ${TABLE}.event_name ;;
    }
   dimension: page_path {
     group_label: "Generic Dimensions"
     label: "Page Path"
     description: "Page path on web"
     type: string
     sql: ${TABLE}.page_path ;;
   }
  dimension: screen_name {
    group_label: "Generic Dimensions"
    label: "Screen Name"
    description: "Screen name where the event was triggered"
    type: string
    sql: ${TABLE}.screen_name ;;
  }
  dimension: component_name {
    group_label: "Generic Dimensions"
    label: "Component Name"
    description: "Component name where the event was triggered"
    type: string
    sql: ${TABLE}.component_name ;;
  }
  dimension: component_content {
    group_label: "Generic Dimensions"
    label: "Component Content"
    description: "Component content where the event was triggered"
    type: string
    sql: ${TABLE}.component_content ;;
  }
  dimension: component_value {
    group_label: "Generic Dimensions"
    label: "Component Value"
    description: "Component value where the event was triggered"
    type: string
    sql: ${TABLE}.component_value ;;
  }
  dimension: component_position {
    group_label: "Generic Dimensions"
    label: "Component Position"
    description: "Position of the component that triggered the event"
    type: string
    sql: ${TABLE}.component_position ;;
  }
  dimension: event_origin {
    group_label: "Generic Dimensions"
    label: "Event Origin"
    description: "The origin of the event, used to determine where the event was generated"
    type: string
    sql: ${TABLE}.event_origin ;;
  }
  dimension: component_variant {
    group_label: "Generic Dimensions"
    label: "Component Variant"
    description: "Variation of the component if multiple variants exist"
    type: string
    sql: ${TABLE}.component_variant ;;
  }


  # ======= Device Dimensions ======= #

    dimension: platform {
      group_label: "Device Dimensions"
      label: "Platform"
      description: "Platform is either iOS, Android or Web"
      type: string
      sql: ${TABLE}.platform ;;
    }
    dimension: device_type {
      group_label: "Device Dimensions"
      label: "Device Type"
      description: "Device type is one of: ios, android, windows, macintosh, linux or other"
      type: string
      sql: ${TABLE}.device_type ;;
    }
    dimension: device_model {
      group_label: "Device Dimensions"
      label: "Device Model"
      description: "Model of the device"
      type: string
      sql: ${TABLE}.device_model ;;
    }
    dimension: os_version {
      group_label: "Device Dimensions"
      label: "OS Version"
      description: "Version of the operating system"
      type: string
      sql: ${TABLE}.os_version ;;
    }
    dimension: app_version {
      group_label: "Device Dimensions"
      label: "App Version"
      description: "Version of the app"
      type: string
      sql: ${TABLE}.app_version ;;
    }
  dimension: app_version_order {
    group_label: "Device Dimensions"
    label: "App Version as Number"
    description: "Version of the app used for ordering recent or old versions"
    type: number
    sql: cast(replace(${TABLE}.app_version,".","") as INT64) ;;
  }
    dimension: full_app_version {
      group_label: "Device Dimensions"
      type: string
      description: "Concatenation of device_type and app_version"
      sql: case when ${TABLE}.device_type in ('ios','android') then  (${TABLE}.device_type || '-' || ${TABLE}.app_version ) end ;;
    }

  # ======= Location Dimension ======= #

    dimension: locale {
      group_label: "Location Dimensions"
      label: "Locale"
      description: "Language code | Coutnry, region code"
      type: string
      sql: ${TABLE}.locale ;;
    }
    dimension: timezone {
      group_label: "Location Dimensions"
      label: "Timezone"
      description: "Timezone of user's device"
      type: string
      sql: ${TABLE}.timezone ;;
    }
    dimension: hub_code {
      group_label: "Location Dimensions"
      label: "Hub Code"
      description: "Hub Code"
      type: string
      sql: ${TABLE}.hub_code ;;
    }
    dimension: country_iso {
      group_label: "Location Dimensions"
      label: "Country ISO"
      description: "ISO country"
      type: string
      sql: ${TABLE}.country_iso ;;
    }

  # ======= Dates / Timestamps =======

    dimension_group: event {
      group_label: "Date / Timestamp"
      label: "Event"
      description: "Timestamp of when an event happened"
      type: time
      timeframes: [
        time,
        date,
        week,
        hour_of_day,
        quarter
      ]
      sql: ${TABLE}.event_timestamp ;;
      datatype: timestamp
    }

 # ======= HIDDEN Dimension ======= #

    dimension_group: received_at {
      hidden: yes
      type: time
      timeframes: [
        date
      ]
      sql: ${TABLE}.received_at ;;
      datatype: timestamp
    }

    dimension: event_name_camel_case {
      hidden: yes
      type: string
      sql: replace(lower(left(replace(INITCAP(${event_name}),'_',' '),1))||right(replace(INITCAP(${event_name}),'_',' '),length(${event_name})-1),' ',"") ;;
    }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~      Measures     ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  measure: events {
    label: "# Events"
    description: "Number of events trigegred by users"
    type: count_distinct
    sql: ${TABLE}.event_uuid ;;
  }
  measure: logged_in_users {
    label: "# Registered Users"
    description: "Number of users who logged-in during a day"
    type: count_distinct
    sql: ${TABLE}.user_id ;;
  }
  measure: logged_in_anonymous_users {
    label: "# All Users"
    description: "Number of all users regardless of their login status."
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
  }

  }
