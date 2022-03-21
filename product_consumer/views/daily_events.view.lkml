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
      group_label: "Generic Dimension"
      label: "Is User Logged-in"
      description: "Whether a user was logged-in when an event was triggered"
      type: yesno
      sql: ${TABLE}.is_user_logged_in ;;
    }
    dimension: has_selected_address {
      group_label: "Generic Dimension"
      label: "Is Address Selected"
      description: "Whether a user had selected address when an event was triggered"
      type: yesno
      sql: ${TABLE}.has_selected_address ;;
    }
    dimension: event_name {
      group_label: "Generic Dimension"
      label: "Event Name"
      description: "Name of the event triggered"
      type: string
      sql: ${TABLE}.event_name ;;
    }
   dimension: page_path {
     group_label: "Generic Dimension"
     label: "Page Path"
     description: "Page path on web"
     type: string
     sql: ${TABLE}.page_path ;;
   }

  # ======= Device Dimensions ======= #

    dimension: platform {
      group_label: "Device Dimension"
      label: "Platform"
      description: "Platform of a device: app or web"
      type: string
      sql: ${TABLE}.platform ;;
    }
    dimension: device_type {
      group_label: "Device Dimension"
      label: "Device Type"
      description: "Type of the device used"
      type: string
      sql: ${TABLE}.device_type ;;
    }
    dimension: device_model {
      group_label: "Device Dimension"
      label: "Device Model"
      description: "Model of the device"
      type: string
      sql: ${TABLE}.device_model ;;
    }
    dimension: os_version {
      group_label: "Device Dimension"
      label: "OS Version"
      description: "Version of the operating system"
      type: string
      sql: ${TABLE}.os_version ;;
    }
    dimension: app_version {
      group_label: "Device Dimension"
      label: "App Version"
      description: "Version of the app"
      type: string
      sql: ${TABLE}.app_version ;;
    }

  # ======= Location Dimension ======= #

    dimension: locale {
      group_label: "Location Dimension"
      label: "Locale"
      description: "Language code | Coutnry, region code"
      type: string
      sql: ${TABLE}.locale ;;
    }
    dimension: timezone {
      group_label: "Location Dimension"
      label: "Timezone"
      description: "Timezone of user's device"
      type: string
      sql: ${TABLE}.timezone ;;
    }
    dimension: hub_code {
      group_label: "Location Dimension"
      label: "Hub Code"
      description: "Hub Code"
      type: string
      sql: ${TABLE}.hub_code ;;
    }
    dimension: country_iso {
      group_label: "Location Dimension"
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
