view: products {
  view_label: "* Product Data *"
  sql_table_name: `flink-data-prod.curated.products`
    ;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========
  dimension: category {
    type: string
    label: "Parent Category"
    group_label: "> Product Attributes"
    sql: ${TABLE}.random_ct_category ;;
  }

  dimension: erp_category {
    type: string
    label: "Parent Category (ERP)"
    group_label: "> Product Attributes"
    sql: ${TABLE}.category ;;
  }

  dimension: is_leading_product {
    type: yesno
    sql: ${TABLE}.is_leading_product ;;
    group_label: "> Product Attributes"
  }

  dimension: is_noos_group {
    label: "Is Never-Out-Of-Stock Group"
    type: yesno
    sql: ${TABLE}.is_noos ;;
    group_label: "> Product Attributes"
  }

  dimension: country_of_origin {
    type: string
    sql: ${TABLE}.country_of_origin ;;
    group_label: "> Geographic Data"
  }

  dimension: product_brand {
    label: "Brand"
    type: string
    sql: ${TABLE}.product_brand ;;
    group_label: "> Product Attributes"
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
    group_label: "> Product Attributes"
  }

  dimension: product_sku {
    label: "SKU"
    type: string
    sql: ${TABLE}.product_sku ;;
    group_label: "> Product Attributes"
  }

  dimension: product_sku_name {
    label: "SKU + Name"
    type: string
    sql: CONCAT(${TABLE}.product_sku, ' - ', ${TABLE}.product_name) ;;
  }

  dimension: subcategory {
    label: "Sub-Category"
    type: string
    sql: ${TABLE}.random_ct_subcategory ;;
    group_label: "> Product Attributes"
  }

  dimension: erp_subcategory {
    label: "Sub-Category (ERP)"
    type: string
    sql: ${TABLE}.subcategory ;;
    group_label: "> Product Attributes"
  }

  #dimension: ct_subcategory {
  #  label: "CT Sub-Category"
  #  type: string
  #  sql:  ;;
  #  group_label: "> Product Attributes"
  #}

  #dimension: ct_category {
  #  label: "CT Category"
  #  type: string
  #  sql: ${TABLE}.random_ct_category ;;
  #  group_label: "> Product Attributes"
  #}

  dimension: substitute_group {
    type: string
    sql: ${TABLE}.substitute_group ;;
    group_label: "> Product Attributes"
  }

  dimension: substitute_group_filled {
    type: string
    sql: coalesce(${substitute_group}, ${product_name}) ;;
    label: "Substitute Group / Product Name"
    group_label: "> Product Attributes"
  }

  dimension: replenishment_substitute_group {
    label: "Replenishment Substitute Groups"
    description: "The substitue groups used by the Supply Chain team as defined in ERP"
    type: string
    sql: ${TABLE}.replenishment_substitute_group ;;
  }

  # =========  hidden   =========
  dimension: primary_key {
    sql: ${TABLE}.product_sku ;;
    primary_key: yes
    hidden: yes
  }

  dimension_group: created {
    label: "SKU Created"
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
    sql: ${TABLE}.created_at ;;
    hidden: no
    group_label: "> Dates & Timestamps"
  }

  dimension_group: last_modified {
    label: "SKU Last Modified"
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
    sql: ${TABLE}.last_modified_at ;;
    hidden: no
    group_label: "> Dates & Timestamps"
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
    hidden: yes
  }

  dimension: units_per_hu {
    type: number
    sql: ${TABLE}.units_per_hu ;;
    hidden: yes
  }

  dimension: product_erp_brand {
    type: string
    sql: ${TABLE}.product_erp_brand ;;
    hidden: yes
  }

  # =========  Price Data   =========
  dimension: amt_product_price_gross {
    type: number
    sql: ${TABLE}.amt_product_price_gross ;;
    group_label: "> Price Data"
    label: "Unit Price Gross Amount"
  }

  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
    group_label: "> Price Data"
    label: "Currency"
  }

  dimension: deposit_amount {
    type: number
    sql: ${TABLE}.deposit_amount ;;
    group_label: "> Price Data"
  }

  dimension: deposit_currency_code {
    type: string
    sql: ${TABLE}.deposit_currencyCode ;;
    group_label: "> Price Data"
  }

  dimension: deposit_type {
    type: string
    sql: ${TABLE}.deposit_type ;;
    group_label: "> Price Data"
  }

  dimension: base_unit_price {
    type: number
    sql: ${TABLE}.unit_price ;;
    group_label: "> Price Data"
  }

  dimension: base_unit_price_display {
    type: string
    sql: ${TABLE}.unit_price_display ;;
    group_label: "> Price Data"
  }



  # =========  IDs   =========
  dimension: ean {
    type: string
    sql: ${TABLE}.ean ;;
    group_label: "> IDs"
  }

  dimension: ean_handling_unit {
    type: number
    sql: ${TABLE}.ean_handling_unit ;;
    group_label: "> IDs"
  }

  dimension: product_id {
    type: number
    sql: ${TABLE}.product_id ;;
    group_label: "> IDs"
  }

  dimension: product_uuid {
    type: string
    sql: ${TABLE}.product_uuid ;;
    group_label: "> IDs"
  }


  # =========  Special Purpose Data   =========
  dimension: max_single_order_quantity {
    type: number
    sql: ${TABLE}.max_single_order_quantity ;;
    group_label: "> Special Purpose Data"
    label: "Max Quantity per Order"
  }

  dimension: meta_description {
    type: string
    sql: ${TABLE}.meta_description ;;
    group_label: "> Special Purpose Data"
    label: "Meta Description"
  }

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
    group_label: "> Special Purpose Data"
    label: "Description"
  }

  dimension: slug_de {
    type: string
    sql: ${TABLE}.slug ;;
    group_label: "> Special Purpose Data"
  }

  dimension: synonyms {
    type: string
    sql: ${TABLE}.synonyms ;;
    group_label: "> Special Purpose Data"
    label: "Synonyms"
  }

  dimension: unit_of_measure {
    type: string
    sql: ${TABLE}.unit_of_measure ;;
    group_label: "> Special Purpose Data"
    label: "Unit of Measure"
  }

  dimension: product_unit {
    type: number
    sql: ${TABLE}.product_unit ;;
    group_label: "> Special Purpose Data"
    label: "Product Unit"
  }

  dimension: base_unit {
    type: number
    sql: ${TABLE}.base_unit ;;
    group_label: "> Special Purpose Data"
    label: "Base Unit"
  }

  dimension: units_per_handling_unit {
    type: number
    sql: ${TABLE}.units_per_handling_unit ;;
    group_label: "> Special Purpose Data"
    label: "Units per Handlung Unit"
  }

  dimension: product_shelf_no {
    type: string
    sql: ${TABLE}.product_shelf_no ;;
    group_label: "> Special Purpose Data"
    label: "Shelf Number"
  }

  dimension: is_published {
    type: yesno
    sql: ${TABLE}.is_published ;;
    hidden: no
    group_label: "> Special Purpose Data"
    label: "Is Published"
  }

  dimension: tax_rate {
    type: number
    sql: ${TABLE}.tax_rate ;;
    hidden: no
    group_label: "> Special Purpose Data"
    label: "Tax Rate"
  }

  dimension: tax_name {
    type: string
    sql: ${TABLE}.tax_name ;;
    hidden: no
    group_label: "> Special Purpose Data"
    label: "Tax Type"
  }

  dimension: image_urls {
    type: string
    sql: ${TABLE}.image_urls ;;
    group_label: "> Special Purpose Data"
    label: "Image URLs"
  }

  measure: cnt_sku {
    label: "# SKUs (Total)"
    group_label: "* Basic Counts *"
    description: "Count of Total SKUs in Assortment"
    hidden:  no
    type: count
    value_format: "0"
  }

  measure: cnt_sku_published {
    label: "# SKUs (Published)"
    group_label: "* Basic Counts *"
    description: "Count of published SKUs in Assortment"
    hidden:  no
    type: count
    value_format: "0"
    filters: [is_published: "yes"]
  }

  measure: cnt_product_images {
    label: "# Product Images"
    group_label: "* Basic Counts *"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.cnt_product_images ;;
  }

  measure: sum_amt_product_price_gross{
    label: "SUM Amt Product Price Gross"
    group_label: "* Price Stats *"
    type: sum
    value_format: "0.00"
    sql: ${TABLE}.amt_product_price_gross ;;
  }

  measure: avg_amt_product_price_gross{
    label: "AVG Amt Product Price Gross"
    group_label: "* Price Stats *"
    type: average
    value_format: "€0.00"
    sql: ${TABLE}.amt_product_price_gross ;;
  }

  measure: med_amt_product_price_gross{
    label: "MED Amt Product Price Gross"
    group_label: "* Price Stats *"
    type: median
    value_format: "€0.00"
    sql: ${TABLE}.amt_product_price_gross ;;
  }

  measure: max_amt_product_price_gross{
    label: "MAX Amt Product Price Gross"
    group_label: "* Price Stats *"
    type: max
    value_format: "€0.00"
    sql: ${TABLE}.amt_product_price_gross ;;
  }

  measure: min_amt_product_price_gross{
    label: "MIN Amt Product Price Gross"
    group_label: "* Price Stats *"
    type: min
    value_format: "€0.00"
    sql: ${TABLE}.amt_product_price_gross ;;
  }

  measure: count {
    type: count
    drill_fields: [product_name]
    hidden: yes
  }
}
