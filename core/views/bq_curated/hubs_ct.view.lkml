view: hubs_ct {
  view_label: "* Hub Data *"
  sql_table_name: `flink-data-prod.curated.hubs`
    ;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========
  dimension: hub_code {
    bypass_suggest_restrictions: yes
    type: string
    description: "Code of a hub identical to backend source table."
    sql: ${TABLE}.hub_code ;;
    drill_fields: [products.product_sku, products.category, products.subcategory, vehicle_uptime_metrics.supplier_name]
  }

  dimension: is_hub_opened_14d {
    label: "Hub is Active more than 14 days?"
    type: yesno
    sql: ${start_date} <= DATE_SUB(current_date(), Interval 14 day) and ${is_active_hub} = true ;;
    description: "This is defined based on start_date curated.hubs and is_hub_active flag coming from hub geolocator system."
    group_label: "Admin Data"
  }

  dimension: hub_name {
    type: string
    description: "Name assigned to a hub based on the combination of country ISO code, city and district."
    sql: ${TABLE}.hub_name ;;
  }

  ########## Dates & Timestamps data

  dimension_group: time_between_hub_launch_and_today {
    type: duration
    sql_start: timestamp(${TABLE}.start_date) ;;
    sql_end: current_timestamp ;;
    group_label: "Dates & Timestamps"
    hidden: yes
  }

  dimension_group: created {
    group_label: "Dates & Timestamps "
    label: "Start Date"
    description: "Hub Start Date."
    hidden: yes
    type: time
    timeframes: [
      date,
      week,
      month
    ]
    sql: timestamp(${TABLE}.start_date) ;;
    datatype: timestamp
  }

  dimension: date {
    group_label: "Dates & Timestamps "
    label: "Hub Start Date (Dynamic)"
    hidden: yes
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${created_date}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${created_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${created_month}
    {% endif %};;
  }

  dimension: date_granularity_pass_through {
    group_label: "Parameters"
    description: "To use the parameter value in a table calculation (e.g WoW, % Growth) we need to materialize it into a dimension "
    type: string
    hidden: yes
    sql:
            {% if date_granularity._parameter_value == 'Day' %}
              "Day"
            {% elsif date_granularity._parameter_value == 'Week' %}
              "Week"
            {% elsif date_granularity._parameter_value == 'Month' %}
              "Month"
            {% endif %};;
  }

  ######### Parameters
  parameter: date_granularity {
    group_label: "Dates & Timestamps "
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
    hidden: yes
  }

  # =========  Geographic Data   =========
  dimension: address {
    type: string
    sql: ${TABLE}.address ;;
    group_label: "Geographic Data"
    description: "Address of a hub."
  }

  dimension: city {
    type: string
    bypass_suggest_restrictions: yes
    sql: ${TABLE}.city ;;
    group_label: "Geographic Data"
    description: "The city where a hub is located."
    drill_fields: [hub_code, vehicle_uptime_metrics.supplier_name]
  }

  dimension: city_tier {
    type: string
    sql: ${TABLE}.city_tier ;;
    group_label: "Geographic Data"
    description: "The city tier that relates to a hub."
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
    group_label: "Geographic Data"
    label: "Country"
    description: "Country where a hub is located."
    drill_fields: [region, city, hub_code, vehicle_uptime_metrics.supplier_name]
  }

  dimension: country_iso {
    type: string
    bypass_suggest_restrictions: yes
    sql: ${TABLE}.country_iso ;;
    group_label: "Geographic Data"
    label: "Country Iso"
    description: "Country where a hub is located."
    drill_fields: [region, city, hub_code, vehicle_uptime_metrics.supplier_name]
  }

  dimension: latitude {
    type: number
    sql: round( safe_cast(${TABLE}.latitude as float64) , 10 ) ;;
    hidden: yes
    group_label: "Geographic Data"
  }

  dimension: longitude {
    type: number
    sql: round( safe_cast(${TABLE}.longitude as float64) , 10 ) ;;
    hidden: yes
    group_label: "Geographic Data"
  }

  dimension: region {
    type: string
    sql: ${TABLE}.region ;;
    group_label: "Geographic Data"
    description: "Region where a hub is located."
    drill_fields: [city, hub_code, vehicle_uptime_metrics.supplier_name]
  }

  dimension: region_iso {
    type: string
    sql: ${TABLE}.region_iso ;;
    group_label: "Geographic Data"
    description: "Region ISO where a hub is located."
  }

  dimension: regional_cluster {
    type: string
    sql: ${TABLE}.regional_cluster ;;
    group_label: "Geographic Data"
    description: "Regional cluster assigned to the region where a hub is located (East, West, South, North)."
    drill_fields: [vehicle_uptime_metrics.supplier_name]
  }

  dimension: hub_location {
    type: location
    sql_latitude: ${latitude};;
    sql_longitude: ${longitude};;
    group_label: "Geographic Data"
    hidden: yes
  }

  dimension: timezone {
    type: string
    sql: ${TABLE}.timezone ;;
    group_label: "Geographic Data"
    hidden: yes
  }



  # =========  Admin Data   =========
  dimension: city_manager {
    type: string
    sql: ${TABLE}.city_manager ;;
    group_label: "Admin Data"
    description: "The manager of a city, overseeing the related hub managers."
  }

  dimension: regional_manager {
    type: string
    label: "Regional Manager"
    description: "The person in charge of the region where the hub is located."
    sql: ${TABLE}.regional_manager ;;
    group_label: "Admin Data"
  }

  dimension: hub_manager {
    type: string
    sql: ${TABLE}.hub_manager ;;
    group_label: "Admin Data"
    description: "The manager of a given hub."
  }

  dimension: hub_manager_email {
    type: string
    sql: ${TABLE}.hub_manager_email ;;
    group_label: "Admin Data"
    description: "Email ID of the hub manager."
  }

  dimension: cost_center {
    type: string
    sql: ${TABLE}.cost_center ;;
    group_label: "Admin Data"
    description: "ID of the cost center linked to the budget."
  }

  dimension: last_modified {
    label: "Last Modifed"
    type: date_time
    sql: ${TABLE}.last_modified_at ;;
    group_label: "Admin Data"
    description: "Timestamp generated by the backend representing when some record/ row in the data was updated the last time."
    hidden: yes
  }

  dimension: created_at {
    label: "Created At"
    type: date_time
    sql: ${TABLE}.created_at ;;
    group_label: "Admin Data"
    description: "The Timestamp for when the hub was initially created within CommerceTools."
    hidden: yes
  }

  dimension: languages {
    type: string
    sql: ${TABLE}.languages ;;
    group_label: "Admin Data"
    hidden: yes
  }

  dimension: start_date {
    label: "Hub Start Date"
    type: date
    datatype: date
    sql: ${TABLE}.start_date;;
    group_label: "Admin Data"
    description: "Date when a hub was launched."
  }

  dimension: termination_date {
    label: "Hub Termination Date"
    description: "The date when a hub was closed."
    type: date
    datatype: date
    sql: ${TABLE}.termination_date ;;
    group_label: "Admin Data"
  }


  dimension: is_active_hub {
    label: "Hub is Active?"
    type: yesno
    sql: ${TABLE}.is_active_hub ;;
    group_label: "Admin Data"
    description: "Based on the correct is_active_hub logic which comes from hub geolocator system (same system which is responsible for Hub Turfs in the app)."
  }


  dimension: is_test_hub {
    label: "Is Test Hub"
    type: yesno
    sql: ${TABLE}.is_test_hub ;;
    group_label: "Admin Data"
    description: "Yes if a given hub is a test hub"
  }

  dimension: is_cell_split_hub {
    label: "Is Cell Split Hub"
    description: "Cell Split Hub: when launched, its delivery area covered more than 20% of an existing delivery area."
    type: yesno
    sql: ${TABLE}.is_cell_split_hub ;;
    group_label: "Admin Data"
  }

  dimension: hub_size {
    label: "Hub Size"
    type: string
    sql:  ${TABLE}.hub_size;;
    group_label: "Admin Data"
    description: "Physical size/ space of a hub (measured as S,M or L)."
  }

  dimension: rewe_tier {
    label: "Rewe Tier"
    type: number
    sql:  ${TABLE}.rewe_tier;;
    group_label: "Admin Data"
    description: "The REWE tier of a hub."
  }

  dimension: is_2_0_layout_hub{
    label: "Is 2.0 Layout Hub"
    type: string # Did not change to boolean since there are few null values (mostly inactive hubs)
    sql:  ${TABLE}.hub_2_0_layout;;
    group_label: "Admin Data"
    description: "Design version of the hub that is defined by the number and order of shelves it contains, etc."
  }

  # =========  ID Data   =========
  dimension: distribution_channel_id {
    type: string
    sql: ${TABLE}.distribution_channel_id ;;
    group_label: "IDs"
    description: "ID used to identify a channel such as organic or job platform."
  }

  dimension: hub_id {
    type: string
    sql: ${TABLE}.hub_id ;;
    primary_key: yes
    group_label: "IDs"
    description: "The alphabetical identifier of a hub."
  }

  dimension: supply_channel_id {
    type: string
    sql: ${TABLE}.supply_channel_id ;;
    group_label: "IDs"
    description: "The supplier ID as defined in Oracle - which is a representation of a supplier and its related supplier-location."
  }

  dimension: shipping_method_id {
    type: string
    sql: ${TABLE}.shipping_method_id ;;
    group_label: "IDs"
    description: "Unique ID of the shipping method generated by the backend."
    link: {
      label: "View Shipping Method in CommerceTools"
      url: "https://mc.europe-west1.gcp.commercetools.com/flink-production/settings/project/shipping-methods/{{ value }}"
    }
  }

  dimension:  lighthouse_hubs {
    label: "Is Lighthouse"
    description: "Yes if the hub is Lighthouse hub."
    type: string
    group_label: "Admin Data"
    case:  {
      when: {
        sql: ${hub_code}
                   in
                  (
                  'de_aah_burt','de_ber_alex','de_ber_bism','de_ber_kotd','de_ber_mit2', 'de_ber_pren','de_ber_schl',
                  'de_bra_mich','de_cgn_lind','de_cgn_nipp','de_dar_zent', 'de_dus_pemp','de_ham_eppe','de_ham_otte',
                  'de_ham_wate','de_ham_wint','de_man_qu18', 'de_muc_schw', 'de_nrm_suds','de_wup_elbe',
                  'nl_ape_cent','nl_alk_cent','nl_dev_cent','nl_ame_cent','nl_ens_cent','nl_dha_zuid', 'nl_lee_cent'
                  ) ;;
        label: "Yes"
      }
      else: "No"
    }
  }
  ######### Parameters

  parameter: geographic_data_granularity {
    group_label: "Geographic Data"
    label: "Geographic Granularity"
    type: unquoted
    allowed_value: { value: "Hub" }
    allowed_value: { value: "City" }
    allowed_value: { value: "Region" }
    allowed_value: { value: "regional_cluster"
      label: "Regional Cluster" }
    allowed_value: { value: "city_manager"
      label: "City Manager" }
    allowed_value: { value: "Country" }
    default_value: "Country"
    hidden: yes
  }

  ######## Dynamic Dimensions

  dimension: geographic_data_dynamic {
    group_label: "Geographic Data"
    label: "Geographic Granularity (Dynamic)"
    hidden: yes
    label_from_parameter: geographic_data_granularity
    sql:
    {% if geographic_data_granularity._parameter_value == 'Hub' %}
      ${hub_code}
    {% elsif geographic_data_granularity._parameter_value == 'City' %}
      ${city}
    {% elsif geographic_data_granularity._parameter_value == 'city_manager' %}
      ${city_manager}
    {% elsif geographic_data_granularity._parameter_value == 'Region' %}
      ${region}
    {% elsif geographic_data_granularity._parameter_value == 'regional_cluster' %}
      ${regional_cluster}
    {% elsif geographic_data_granularity._parameter_value == 'Country' %}
      ${country_iso}
    {% endif %};;
    drill_fields: [vehicle_uptime_metrics.supplier_name]
  }

  measure: count {
    type: count
    drill_fields: [hub_name]
    hidden: yes
  }
}
