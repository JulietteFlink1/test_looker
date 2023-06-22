# Owner: Victor Breda
# Created 2023-06-21
# This view contains Oracle Fusion data
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


  dimension: created_by {
    group_label: "> Attributes"
    type: string
    description: "Email address of the user who entered the row."
    sql: ${TABLE}.created_by ;;
  }

  dimension: accounting_sequence_number {
    group_label: "> Attributes"
    type: string
    hidden: yes
    description: "Value assigned by Oracle Fusion based on the order of posting of the entries of a transaction."
    sql: ${TABLE}.accounting_sequence_number ;;
  }

  dimension: header_id {
    group_label: "> Attributes"
    type: string
    hidden: yes
    description: "System generated ID of a transaction."
    sql: ${TABLE}.header_id ;;
  }

  dimension: line_number {
    group_label: "> Attributes"
    type: string
    hidden: yes
    description: "Line number of the transaction entry."
    sql: ${TABLE}.line_number ;;
  }

  dimension: transaction_number {
    group_label: "> Attributes"
    type: string
    description: "Number associated with a transaction. Only populated for payables, i.e. invoices."
    sql: ${TABLE}.transaction_number ;;
  }

  dimension: line_description {
    group_label: "> Attributes"
    type: string
    description: "Description associated with the entered row."
    sql: ${TABLE}.line_description ;;
  }

  dimension: entered_currency {
    group_label: "> Attributes"
    type: string
    description: "Currency the amount is in."
    sql: ${TABLE}.entered_currency ;;
  }

  dimension: business_area {
    group_label: "> Attributes"
    type: string
    description: "Flags whether the expenses are related to a Hub or HQ."
    sql: ${TABLE}.business_area ;;
  }

  dimension: job_function {
    group_label: "> Attributes"
    type: string
    description: "Role performed by the employee."
    sql: ${TABLE}.job_function_name ;;
  }

  dimension: je_category_name {
    group_label: "> Attributes"
    label: "JE Category Name"
    type: string
    description: "Journal Entry Category associated with the nature of the transaction. E.g. payment, external revenue."
    sql: ${TABLE}.je_category_name ;;
  }

  dimension: party_name {
    group_label: "> Attributes"
    type: string
    description: "Name of the supplier/customer."
    sql: ${TABLE}.party_name ;;
  }

  dimension: party_site_name {
    group_label: "> Attributes"
    type: string
    description: "Subset of the Party Name that designates more precisely which entity of the party name is being referred to.
    E.g. party name might be 'Rewe', and party site name 'Rewe - Munich'."
    sql: ${TABLE}.party_site_name ;;
  }

  dimension: company_name {
    group_label: "> Attributes"
    label: "Company Name"
    type: string
    description: "Name of the company a transaction relates to."
    sql: ${TABLE}.company_name ;;
  }

  dimension: cost_center_name {
    group_label: "> Attributes"
    label: "Cost Center Name"
    type: string
    description: "Name of the department the expense originates from."
    sql: ${TABLE}.cost_center_name ;;
  }

  dimension: general_ledger_name {
    group_label: "> Attributes"
    label: "GL Account Name"
    type: string
    description: "Name of the General Ledger account the transaction was posted into."
    sql: ${TABLE}.general_ledger_name ;;
  }



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
    group_label: "> Dates & Timestamps - Entry Metadata"
    type: time
    timeframes: [
      time,
      date
    ]
    sql: ${TABLE}.creation_timestamp ;;
  }

  dimension_group: last_update {
    group_label: "> Dates & Timestamps - Entry Metadata"
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
    group_label: "> Dates & Timestamps - Entry Metadata"
    type: time
    description: "Timestamp at which the row has been ingested."
    timeframes: [
      time,
      date
    ]
    sql: ${TABLE}.ingestion_timestamp ;;
  }

  dimension_group: general_ledger {
    group_label: "> Dates & Timestamps"
    label: "General Ledger"
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
    sql: ${TABLE}.general_ledger_date ;;
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

  dimension: company_id {
    group_label: "> Segments"
    label: "1 - Company"
    type: number
    description: "Identifier of the company a transaction is associated to. Corresponds to Segment 1."
    sql: ${TABLE}.company_id ;;
  }

  dimension: branch_id {
    group_label: "> Segments"
    label: "2 - Branch"
    type: number
    description: "Identifier of the branch a transaction is associated to.
    Branch is a financial term to refer to a unit of the business - e.g. the Alexanderplatz hub or the Netherlands HQ.
    Corresponds to Segment 2."
    sql: ${TABLE}.branch_id ;;
  }

  dimension: cost_center_id {
    group_label: "> Segments"
    label: "3 - Cost Center"
    type: number
    description: "`Identifier of the cost center a transaction is associated to. Corresponds to Segment 3."
    sql: ${TABLE}.cost_center_id ;;
  }

  dimension: general_ledger_account_id {
    group_label: "> Segments"
    label: "4 - GL Account"
    type: number
    description: "Identifier of the General Ledger account a transaction is associated to.
    A GL account is an account that records costs for specific categories, e.g. travel, salaries, etc.
    Corresponds to Segment 4."
    sql: ${TABLE}.general_ledger_account_id ;;
  }

  dimension: job_function_id {
    group_label: "> Segments"
    label: "5 - Job Function"
    type: number
    description: "Identifier of the job function a transaction is associated to.
    Job Function corresponds to the role performed by an employee.
    It is set to 0 for expenses that are not employee related, e.g. COGS.
    Corresponds to Segment 5."
    sql: ${TABLE}.job_function_id ;;
  }

  dimension: product_category_id {
    group_label: "> Segments"
    label: "6 - Product"
    type: number
    description: "Identifier of the product category (e.g. dairy, frozen, etc.) a transaction is associated to. Corresponds to Segment 6."
    sql: ${TABLE}.product_category_id ;;
  }

  dimension: sales_region_id {
    group_label: "> Segments"
    label: "7 - Sales Region"
    type: number
    description: "Identifier of the sales region a transaction is associated to. 100 for DE, 400 for NL and 500 for FR. Corresponds to Segment 7."
    sql: ${TABLE}.sales_region_id ;;
  }

  dimension: intercompany_id {
    group_label: "> Segments"
    label: "8 - Intercompany"
    type: number
    description: "Identifier of the intercompany a transaction is associated to. Corresponds to Segment 8."
    sql: ${TABLE}.intercompany_id ;;
  }

  dimension: project_id {
    group_label: "> Segments"
    label: "9 - Project"
    type: number
    description: "Identifier of the project a transaction is associated to. Corresponds to Segment 9."
    sql: ${TABLE}.project_id ;;
  }

  dimension: future1_id {
    group_label: "> Segments"
    label: "10 - Future 1"
    type: number
    description: "Segment 10 is currently not used."
    sql: ${TABLE}.future1_id ;;
  }

  dimension: future2_id {
    group_label: "> Segments"
    label: "11 - Future 2"
    type: number
    description: "Segment 11 is currently not used."
    sql: ${TABLE}.future2_id ;;
  }



########### Measures ###########

  measure: sum_amt_accounted_value_eur {
    label: "SUM Accounted Value"
    description: "Sum of the recorded values of the transactions. Calculated as debited amount minus credited amount."
    type: sum
    sql: ${amt_accounted_value_eur} ;;
    value_format_name: eur
  }

}
