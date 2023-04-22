# Owner: Andreas Stueber
# Created: 2023-04-21
# Purpuse: Giving stakeholders access to CommerceTools category data

view: product_categories {
  sql_table_name: `flink-data-prod.curated.product_categories`;;

  dimension_group: category_created_at {
    label: "Created At"
    type: time
    description: "Timestamp at which a Commerce Tools category was created"
    timeframes: [
      time,
      date
    ]
    sql: ${TABLE}.category_created_at_timestamp ;;
  }

  dimension: category_description {
    label: "Description)"
    type: string
    description: "Description of a Commerce Tools category"
    sql: ${TABLE}.category_description ;;
  }

  dimension: category_external_id {
    label: "External ID"
    type: string
    description: "External ID of a Commerce Tools category"
    sql: ${TABLE}.category_external_id ;;
  }

  dimension: category_id {
    label: "ID"
    type: string
    description: "ID of a product category (not ERP category), passed in BE and client events."
    sql: ${TABLE}.category_id ;;
    primary_key: yes
  }

  dimension: category_key {
    label: "Key"
    type: string
    description: "Value from Commerce Tools category table"
    sql: ${TABLE}.category_key ;;
  }

  dimension_group: category_last_modified_at {
    label: "Last Modified At"
    type: time
    description: "Timestamp at which a Commerce Tools category was updated"
    timeframes: [
      time,
      date
    ]
    sql: ${TABLE}.category_last_modified_at_timestamp ;;
  }

  dimension: category_meta_description {
    label: "Meta Description"
    type: string
    description: "Meta description of a Commerce Tools category"
    sql: ${TABLE}.category_meta_description ;;
  }

  dimension: category_meta_title {
    label: "Meta Title"
    type: string
    description: "Meta title of a Commerce Tools category"
    sql: ${TABLE}.category_meta_title ;;
  }

  dimension: category_name {
    label: "Name"
    type: string
    description: "Name of the category to which product was assigned, (not ERP category)."
    sql: ${TABLE}.category_name ;;
  }

  dimension: category_slug {
    label: "Slug"
    type: string
    description: "Slug of the Commerce Tools category"
    sql: ${TABLE}.category_slug ;;
  }

  dimension: category_type {
    label: "Type"
    type: string
    description: "Type of the Commerce Tools category"
    sql: ${TABLE}.category_type ;;
  }

  dimension: country_iso {
    label: "Country ISO"
    type: string
    description: "Country ISO based on 'hub_code'."
    sql: ${TABLE}.country_iso ;;
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    per parent category
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  dimension: parent_category_description {
    label: "Description (Parent Category)"
    group_label: "Parent Category"
    type: string
    description: "Description of a Commerce Tools category"
    sql: ${TABLE}.parent_category_description ;;
  }

  dimension: parent_category_external_id {
    label: "External ID (Parent Category)"
    group_label: "Parent Category"
    type: string
    description: "External ID of a Commerce Tools category"
    sql: ${TABLE}.parent_category_external_id ;;
  }

  dimension: parent_category_id {
    label: "Category ID (Parent Category)"
    group_label: "Parent Category"
    type: string
    description: "ID of the Commerce Tools category"
    sql: ${TABLE}.parent_category_id ;;
  }

  dimension: parent_category_key {
    label: "Key (Parent Category)"
    group_label: "Parent Category"
    type: string
    description: "Value from Commerce Tools category table"
    sql: ${TABLE}.parent_category_key ;;
  }

  dimension: parent_category_meta_description {
    label: "Meta Description (Parent Category)"
    group_label: "Parent Category"
    type: string
    description: "Meta description of a Commerce Tools category"
    sql: ${TABLE}.parent_category_meta_description ;;
  }

  dimension: parent_category_meta_title {
    label: "Meta Title (Parent Category)"
    group_label: "Parent Category"
    type: string
    description: "Meta title of a Commerce Tools category"
    sql: ${TABLE}.parent_category_meta_title ;;
  }

  dimension: parent_category_name {
    label: "Name (Parent Category)"
    group_label: "Parent Category"
    type: string
    description: "Name of the category to which product was assigned, (not ERP category)."
    sql: ${TABLE}.parent_category_name ;;
  }

  dimension: parent_category_slug {
    label: "Slug (Parent Category)"
    group_label: "Parent Category"
    type: string
    description: "Slug of the Commerce Tools category"
    sql: ${TABLE}.parent_category_slug ;;
  }

  dimension: parent_category_type {
    label: "Type (Parent Category)"
    group_label: "Parent Category"
    type: string
    description: "Type of the Commerce Tools category"
    sql: ${TABLE}.parent_category_type ;;
  }

}
