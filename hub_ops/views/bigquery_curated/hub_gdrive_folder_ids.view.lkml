# Owner: Justine Grammatikas
# Created on: 2023-04-05


view: hub_gdrive_folder_ids {
  sql_table_name: `flink-data-prod.curated.hub_gdrive_folder_ids`
    ;;

  dimension: country_iso {
    type: string
    description: "Country ISO based on 'hub_code'."
    sql: ${TABLE}.country_iso ;;
  }

  dimension: drive_id {
    type: string
    description: "Unique identifier for the Google Drive. Each country has its own drive."
    sql: ${TABLE}.drive_id ;;
  }

  dimension: folder_id {
    type: string
    description: "Unique identifier for the Google Drive folder. Each hub has its own folder."
    sql: ${TABLE}.folder_id ;;
  }

  dimension: hub_code {
    type: string
    description: "Code of a hub identical to back-end source tables."
    sql: ${TABLE}.hub_code ;;
  }

  dimension: table_uuid {
    primary_key: yes
    type: string
    description: "Generic identifier of a table in BigQuery that represent 1 unique row of this table."
    sql: ${TABLE}.table_uuid ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
