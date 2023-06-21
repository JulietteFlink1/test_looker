# Owner: Victor Breda
# Created 2023-06-21
view: oracle_fusion_general_ledger_mapping {

  sql_table_name: `flink-data-dev.dbt_vbreda_curated_finance.oracle_fusion_general_ledger_mapping`
    ;;


  dimension: table_uuid {
    type: string
    hidden: yes
    primary_key: yes
    description: "Generic identifier of a table in BigQuery that represents 1 unique row of this table."
    sql: ${TABLE}.table_uuid ;;
  }

  dimension: country_iso {
    group_label: "> Geographic Attributes"
    type: string
    description: "Country ISO based on 'hub_code'."
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    group_label: "> Geographic Attributes"
    type: string
    description: "Code of a hub identical to back-end source tables."
    sql: ${TABLE}.hub_code ;;
  }

  # Entry attributes are dimensions that make more sense used on a row level

  dimension: created_by {
    group_label: "> Entry Attributes"
    type: string
    description: "Email address of the user who entered the row."
    sql: ${TABLE}.created_by ;;
  }

  dimension: accounting_sequence_number {
    group_label: "> Entry Attributes"
    type: string
    hidden: yes
    description: "Value assigned by Oracle Fusion based on the order of posting of the entries of a transaction."
    sql: ${TABLE}.accounting_sequence_number ;;
  }

  dimension: header_id {
    group_label: "> Entry Attributes"
    type: string
    hidden: yes
    description: "System generated ID of a transaction."
    sql: ${TABLE}.header_id ;;
  }

  dimension: line_number {
    group_label: "> Entry Attributes"
    type: string
    hidden: yes
    description: "Line number of the transaction entry."
    sql: ${TABLE}.line_number ;;
  }

  dimension: transaction_number {
    group_label: "> Entry Attributes"
    type: string
    description: "Number associated with a transaction. Only populated for payables, i.e. invoices."
    sql: ${TABLE}.transaction_number ;;
  }

  dimension: line_description {
    group_label: "> Entry Attributes"
    type: string
    description: "Description associated with the entered row."
    sql: ${TABLE}.line_description ;;
  }

  dimension: entered_currency {
    group_label: "> Entry Attributes"
    type: string
    description: "Currency the amount is in."
    sql: ${TABLE}.entered_currency ;;
  }




  # General attributes are dimensions for which it makes more sense to aggregate the data

  dimension: business_area {
    group_label: "> General Attributes"
    type: string
    description: "Flags whether the expenses are related to a Hub or HQ."
    sql: ${TABLE}.business_area ;;
  }

  dimension: job_function {
    group_label: "> General Attributes"
    type: string
    description: "Role performed by the employee."
    sql: ${TABLE}.job_function ;;
  }

  dimension: je_category_name {
    group_label: "> General Attributes"
    label: "JE Category Name"
    type: string
    description: "Journal Entry Category associated with the nature of the transaction. E.g. payment, external revenue."
    sql: ${TABLE}.je_category_name ;;
  }

  dimension: party_name {
    group_label: "> General Attributes"
    type: string
    description: "Name of the supplier/customer."
    sql: ${TABLE}.party_name ;;
  }

  dimension: party_site_name {
    group_label: "> General Attributes"
    type: string
    description: "Subset of the Party Name that designates more precisely which entity of the party name is being referred to.
    E.g. party name might be 'Rewe', and party site name 'Rewe - Munich'."
    sql: ${TABLE}.party_site_name ;;
  }


  dimension: balancing_segment_desc {
    group_label: "> General Attributes"
    label: "Balancing Segment"
    type: string
    description: "Name of the company a transaction relates to."
    sql: ${TABLE}.balancing_segment_desc ;;
  }

  dimension: cost_center_desc {
    group_label: "> General Attributes"
    label: "Cost Center"
    type: string
    description: "Name of the department the expense originates from."
    sql: ${TABLE}.cost_center_desc ;;
  }

  dimension: natural_account_desc {
    group_label: "> General Attributes"
    label: "Natural Account"
    type: string
    description: "Name of the General Ledger account the transaction was posted into."
    sql: ${TABLE}.natural_account_desc ;;
  }

  # dimension: period_name {
  #   type: string
  #   description: "Financial term to refer to a certain month (also called accounting period) to which a budget or expense is posted.
  #   It can sometimes contain information about the country. Example values: '03-2023' or 'DE Budget 10/22'."
  #   sql: ${TABLE}.period_name ;;
  # }

  # main attribute that will be used for P&Ls, thus not grouped under a group label
  dimension: mgmt_mapping {
    label: "MGMT Mapping"
    type: string
    description: "P&L category the expense line is mapped to."
    sql: ${TABLE}.mgmt_mapping ;;
  }


  ## Dimensions used to create metrics

  dimension: amt_accounted_value_eur {
    type: number
    hidden: yes
    description: "Recorded value of the transaction. Calculated as debited amount minus credited amount."
    sql: ${TABLE}.amt_accounted_value_eur ;;
  }


  ######### Dates & Timestamps ###########

  dimension_group: creation {
    group_label: "> Dates & Timestamps"
    type: time
    timeframes: [
      time,
      date
    ]
    sql: ${TABLE}.creation_timestamp ;;
  }

  dimension_group: last_update {
    group_label: "> Dates & Timestamps"
    type: time
    description: "Date at which the row was last updated."
    timeframes: [
      date,
      week,
      month
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.last_update_date ;;
  }

  dimension_group: ingestion {
    group_label: "> Dates & Timestamps"
    type: time
    description: "Timestamp at which the row has been ingested."
    timeframes: [
      time,
      date
    ]
    sql: ${TABLE}.ingestion_timestamp ;;
  }


  dimension_group: gl {
    group_label: "> Dates & Timestamps"
    label: "GL"
    type: time
    description: "General ledger date associated with a financial transaction.
    It corresponds to the date at which a transaction is posted."
    timeframes: [
      date,
      week,
      month
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.gl_date ;;
  }

  dimension_group: transaction {
    group_label: "> Dates & Timestamps"
    type: time
    description: "Determines the period to which the transaction belongs to."
    timeframes: [
      date,
      week,
      month
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.transaction_date ;;
  }

  dimension: period_month {
    group_label: "> Dates & Timestamps"
    type: date_month
    description: "Period start date (first date of the month).
    Period is a financial term to refer to a certain month (also called accounting period) to which a budget or expense is posted."
    convert_tz: no
    datatype: date
    sql: ${TABLE}.period_start_date ;;
  }


  ######### Segments ###########


  dimension: segment1 {
    group_label: "> Segments"
    label: "Segment 1"
    type: number
    description: "Segment 1 is the identifier of the company a transaction is associated to."
    sql: ${TABLE}.segment1 ;;
  }

  dimension: segment2 {
    group_label: "> Segments"
    label: "Segment 2"
    type: number
    description: "Segment 2 is the identifier of the branch a transaction is associated to.
    Branch is a financial term to refer to a unit of the business - e.g. the Alexanderplatz hub or the Netherlands HQ."
    sql: ${TABLE}.segment2 ;;
  }

  dimension: segment3 {
    group_label: "> Segments"
    label: "Segment 3"
    type: number
    description: "Segment 3 is the identifier of the cost center a transaction is associated to."
    sql: ${TABLE}.segment3 ;;
  }

  dimension: segment4 {
    group_label: "> Segments"
    label: "Segment 4"
    type: number
    description: "Segment 4 is the identifier of the General Ledger account a transaction is associated to.
    A GL account is an account that records costs for specific categories, e.g. travel, salaries, etc."
    sql: ${TABLE}.segment4 ;;
  }

  dimension: segment5 {
    group_label: "> Segments"
    label: "Segment 5"
    type: number
    description: "Segment 5 is the identifier of the job function a transaction is associated to.
    Job Function corresponds to the role performed by an employee.
    It is set to 0 for expenses that are not employee related, e.g. COGS."
    sql: ${TABLE}.segment5 ;;
  }

  dimension: segment6 {
    group_label: "> Segments"
    label: "Segment 6"
    type: number
    description: "Segment 6 is the identifier of the product category (e.g. dairy, frozen, etc.) a transaction is associated to."
    sql: ${TABLE}.segment6 ;;
  }

  dimension: segment7 {
    group_label: "> Segments"
    label: "Segment 7"
    type: number
    description: "Segment 7 is the identifier of the sales region a transaction is associated to. 100 for DE, 400 for NL and 500 for FR."
    sql: ${TABLE}.segment7 ;;
  }

  dimension: segment8 {
    group_label: "> Segments"
    label: "Segment 8"
    type: number
    description: "Segment 8 is the identifier of the intercompany a transaction is associated to."
    sql: ${TABLE}.segment8 ;;
  }

  dimension: segment9 {
    group_label: "> Segments"
    label: "Segment 9"
    type: number
    description: "Segment 9 is the identifier of the project a transaction is associated to."
    sql: ${TABLE}.segment9 ;;
  }

  dimension: segment10 {
    group_label: "> Segments"
    label: "Segment 10"
    type: number
    description: "Segment 10 is currently not used."
    sql: ${TABLE}.segment10 ;;
  }

  dimension: segment11 {
    group_label: "> Segments"
    label: "Segment 11"
    type: number
    description: "Segment 11 is currently not used."
    sql: ${TABLE}.segment11 ;;
  }

########### Measures ###########

  measure: sum_amt_accounted_value_eur {
    label: "SUM Accounted Value"
    description: "Sum of the recorded value of the transactions. Calculated as debited amount minus credited amount."
    type: sum
    sql: ${amt_accounted_value_eur} ;;
    value_format_name: eur
  }

}
