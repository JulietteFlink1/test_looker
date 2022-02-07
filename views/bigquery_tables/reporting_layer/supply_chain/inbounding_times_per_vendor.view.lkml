view: inbounding_times_per_vendor {
  sql_table_name: `flink-data-prod.reporting.inbounding_times_per_vendor`
    ;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameter      ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  parameter: select_inbound_times_level {

    label:        "[Param] Switch Inbounding Times Calculation"
    description:  "Changes the calculation type of '[Param] AVG Inbounded SKUs per Supplier'"


    type: unquoted

    allowed_value: { value: "1" label: "All Inbounding" }
    allowed_value: { value: "2" label: "Bulk-Inbounding" }
    allowed_value: { value: "3" label: "Manual Inbounding" }
    default_value: "Day"
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========
  dimension_group: report {
    label: "Inbound"
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
    sql: ${TABLE}.report_date ;;
  }



  # =========  hidden   =========
  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
    hidden: yes
  }

  dimension: erp_vendor_id {
    type: string
    sql: ${TABLE}.vendor_id ;;
    hidden: yes
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
    hidden: yes
  }

  dimension: sku_list {
    type: string
    sql: ${TABLE}.sku_list ;;
    hidden: yes
  }

  dimension: inbounding_time_hours {
    type: number
    sql: ${TABLE}.inbounding_time_hours ;;
    hidden: yes
  }


  dimension: number_of_unique_skus_inbounded {
    type: number
    sql: ${TABLE}.number_of_unique_skus_inbounded ;;
    hidden: yes
  }

  dimension: bulk_inbounding_time_hours {
    type: number
    sql: ${TABLE}.bulk_inbounding_time_hours ;;
    hidden: yes
  }


  dimension: bulk_number_of_unique_skus_inbounded {
    type: number
    sql: ${TABLE}.bulk_number_of_unique_skus_inbounded ;;
    hidden: yes
  }

  dimension: manual_inbounding_time_hours {
    type: number
    sql: ${TABLE}.manual_inbounding_time_hours ;;
    hidden: yes
  }


  dimension: manual_number_of_unique_skus_inbounded {
    type: number
    sql: ${TABLE}.manual_number_of_unique_skus_inbounded ;;
    hidden: yes
  }

  dimension: filter_number_of_unique_skus_inbounded{
    # this filter applies on a dimension aka UNAGGREGATED level. Thus it excludes per row on the raw-data-level.

    label:       "[Filter] # Unique SKUs inbounded"
    description: "This filter lets you set a threashold on how many different SKU had to be delivered by a supplier on a day to a specific hub
                  in order to be included in the data.
                  This filtering is also dependent on what inblunding measures you are using - inbounding as bulk, manual per stock manager or all together"

    type: number

    sql:
      {% if    select_inbound_times_level._parameter_value == '1' %}
         ${number_of_unique_skus_inbounded}

      {% elsif select_inbound_times_level._parameter_value == '2' %}
         ${bulk_number_of_unique_skus_inbounded}

      {% elsif select_inbound_times_level._parameter_value == '3' %}
         ${manual_number_of_unique_skus_inbounded}

      {% endif %}
    ;;


    }


  dimension_group: first_item_booked_in_timestamp {

    label: "Time Inbound Started"
    description: "The start time of the inbounding process per vendor"

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
    sql: ${TABLE}.first_item_booked_in_timestamp ;;
    hidden: yes
  }


  dimension_group: last_item_booked_in_timestamp {

    label: "Time Inbound Ended"
    description: "The end time of the inbounding process per vendor"

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
    sql: ${TABLE}.last_item_booked_in_timestamp ;;
    hidden: yes
  }



  # =========  IDs   =========

  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
    primary_key: yes
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  #  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --
  # TOTAL

  measure: avg_inbounding_time_hours  {

    label:       "AVG Inbounding Time per Supplier (Hours) (All Inbounding)"
    description: "The average time it took to inbound the SKUs of a vendor - without the distinction between bulk and manual inbounding"
    group_label: "Inbounding - All Inbounding"

    sql: ${inbounding_time_hours} ;;
    type: average

    value_format_name: decimal_2
  }

  measure: avg_number_of_unique_skus_inbounded {

    label:       "AVG Inbounded SKUs per Supplier (All Inbounding)"
    description: "The average number of SKUs, that are inbounded per vendor - without the distinction between bulk and manual inbounding"
    group_label: "Inbounding - All Inbounding"

    sql: ${number_of_unique_skus_inbounded} ;;
    type: average

    value_format_name: decimal_1
  }

  measure: avg_hours_per_1k_pieces {

    label:       "AVG Hours per 1k unique SKUs (All Inbounding)"
    description: "Indicates, how long it takes to inbound 1000 unique SKUs given the current 'AVG Inbounding Time per Supplier' and 'AVG Inbounded SKUs per Supplier'"
    group_label: "Inbounding - All Inbounding"

    type: number
    sql:
        ${avg_inbounding_time_hours} * 1000 / nullif(${avg_number_of_unique_skus_inbounded}, 0)
    ;;

    value_format_name: decimal_1
  }

  #  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --


  #  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --
  measure: avg_bulk_inbounding_time_hours  {

    label:       "AVG Inbounding Time per Supplier (Hours) (Bulk)"
    description: "The average time it took to inbound the SKUs of a vendor - only for bulk inbounding"
    group_label: "Inbounding - Bulk Inbounding"

    sql: ${bulk_inbounding_time_hours} ;;
    type: average

    value_format_name: decimal_2
  }

  measure: avg_bulk_number_of_unique_skus_inbounded {

    label:       "AVG Inbounded SKUs per Supplier (Bulk)"
    description: "The average number of SKUs, that are inbounded per vendor - only for bulk inbounding"
    group_label: "Inbounding - Bulk Inbounding"

    sql: ${bulk_number_of_unique_skus_inbounded} ;;
    type: average

    value_format_name: decimal_1
  }

  measure: avg_bulk_hours_per_1k_pieces {

    label:       "AVG Hours per 1k unique SKUs (Bulk)"
    description: "Indicates, how long it takes to inbound 1000 unique SKUs given the current 'AVG Inbounding Time per Supplier' and 'AVG Inbounded SKUs per Supplier'"
    group_label: "Inbounding - Bulk Inbounding"

    type: number
    sql:
        ${avg_bulk_inbounding_time_hours} * 1000 / nullif(${avg_bulk_number_of_unique_skus_inbounded}, 0)
    ;;

      value_format_name: decimal_1
  }

  #  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --


  #  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --
  # MANUAL

  measure: avg_manual_inbounding_time_hours  {

    label:       "AVG Inbounding Time per Supplier (Hours) (Non-Bulk)"
    description: "The average time it took to inbound the SKUs of a vendor - only for manual inbounding through the stock-manager"
    group_label: "Inbounding - Manual Inbounding"

    sql: ${manual_inbounding_time_hours} ;;
    type: average

    value_format_name: decimal_2
  }

  measure: avg_manual_number_of_unique_skus_inbounded {

    label:       "AVG Inbounded SKUs per Supplier (Non-Bulk)"
    description: "The average number of SKUs, that are inbounded per vendor - only for manual inbounding through the stock-manager"
    group_label: "Inbounding - Manual Inbounding"

    sql: ${manual_number_of_unique_skus_inbounded} ;;
    type: average

    value_format_name: decimal_1
  }

  measure: avg_manual_hours_per_1k_pieces {

    label:       "AVG Hours per 1k unique SKUs (Non-Bulk)"
    description: "Indicates, how long it takes to inbound 1000 unique SKUs given the current 'AVG Inbounding Time per Supplier' and 'AVG Inbounded SKUs per Supplier'"
    group_label: "Inbounding - Manual Inbounding"

    type: number
    sql:
        ${avg_manual_inbounding_time_hours} * 1000 / nullif(${avg_manual_number_of_unique_skus_inbounded}, 0)
    ;;

      value_format_name: decimal_1
    }
  #  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --



  #  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --
  # PARAMETERS

  measure: param_number_of_unique_skus_inbounded {

    label:       "[Param] AVG Inbounded SKUs per Supplier"
    description: "Depending on the selection in 'Switch Inbounding Times Calculation', show all , only bulk or only manual inbounded number of SKUs"

    # label_from_parameter: select_inbound_times_level

    type: number
    sql:
      {% if    select_inbound_times_level._parameter_value == '1' %}
        ${avg_number_of_unique_skus_inbounded}

      {% elsif select_inbound_times_level._parameter_value == '2' %}
        ${avg_bulk_number_of_unique_skus_inbounded}

      {% elsif select_inbound_times_level._parameter_value == '3' %}
        ${avg_manual_number_of_unique_skus_inbounded}

      {% endif %}
    ;;

    value_format_name: decimal_0
  }

  measure: param_inbounding_time_hours{

    label:       "[Param] AVG Inbounding Time per Supplier (Hours)"
    description: "Depending on the selection in 'Switch Inbounding Times Calculation', show all , only bulk or only manual inbounding hours per supplier"

    # label_from_parameter: select_inbound_times_level

    type: number

    sql:
      {% if    select_inbound_times_level._parameter_value == '1' %}
        ${avg_inbounding_time_hours}

      {% elsif select_inbound_times_level._parameter_value == '2' %}
        ${avg_bulk_inbounding_time_hours}

      {% elsif select_inbound_times_level._parameter_value == '3' %}
        ${avg_manual_inbounding_time_hours}

      {% endif %}
    ;;

    value_format_name: decimal_2

  }

  measure: param_inbounding_hours_per_1k_pieces {

    label:       "[Param] AVG Hours per 1k unique SKUs"
    description: "Depending on the selection in 'Switch Inbounding Times Calculation', show all , only bulk or only manual inbounding hours per 1k unique SKUs"

    # label_from_parameter: select_inbound_times_level

    type: number

    sql:
      {% if    select_inbound_times_level._parameter_value == '1' %}
        ${avg_hours_per_1k_pieces}

      {% elsif select_inbound_times_level._parameter_value == '2' %}
        ${avg_bulk_hours_per_1k_pieces}

      {% elsif select_inbound_times_level._parameter_value == '3' %}
        ${avg_manual_hours_per_1k_pieces}

      {% endif %}
    ;;

      value_format_name: decimal_2

    }
  #  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --


}
