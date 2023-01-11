view: products {
  view_label: "* Product Data *"
  sql_table_name: `flink-data-dev.dbt_astueber_curated.products`
    ;;

  set: product_attributes {

  ### be careful when manipulating this set, it is used in joins
  ## for product placement reporting ###
    fields: [
      product_name,
      product_sku,
      is_noos_group,
      category,
      subcategory,
      substitute_group
    ]
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========
  dimension: category {
    alias: [random_ct_category, ct_category]
    type: string
    bypass_suggest_restrictions: yes
    label: "Parent Category"
    group_label: "> Product Attributes"
    description: "This is CT reporting category"
    sql: ${TABLE}.category ;;
    drill_fields: [subcategory, hubs.hub_code, hubs_ct.hub_code]
  }

  dimension: erp_category {
    type: string
    bypass_suggest_restrictions: yes
    label: "Parent Category (ERP)"
    group_label: "> Product Attributes"
    sql: ${TABLE}.erp_category ;;
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
    bypass_suggest_restrictions: yes
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

  dimension: is_rezeptkarte {
    type: yesno
    label: "Is Rezeptkarte"
    sql: case
          when ${product_name} like '%Rezeptkarte%'
            then true
          else false
         end    ;;
    group_label: "> Product Attributes"
    description: "Boolean flag that shows if an item is Rezeptkarte or not"
  }

  dimension: product_sku {
    label: "Legacy SKU"
    description: "The SKU of a product. For the case of products that received a different SKU within the Oracle go-live process (e.g. from 14x to an 11x SKU), both numbers are appearing"
    type: string
    sql: ${TABLE}.product_sku ;;
  }

  dimension: global_sku {
    label: "SKU"
    description: "The SKU of a product. It resembles the merged SKU (caused by the Oracle go-live process) - thus if a product was previously labelled with an 14x SKU and now with an 11x SKU, this field will only show the 11x SKU"
    type: string
    sql: ${TABLE}.global_sku ;;
  }

  dimension: product_sku_name {
    label: "SKU + Name"
    type: string
    sql: CONCAT(${TABLE}.product_sku, ' - ', ${TABLE}.product_name) ;;
  }

  dimension: subcategory {
    alias: [random_ct_subcategory, ct_subcategory]
    label: "Sub-Category"
    bypass_suggest_restrictions: yes
    description: "This is CT reporting subcategory"
    type: string
    sql: ${TABLE}.subcategory ;;
    group_label: "> Product Attributes"
  }

  dimension: erp_subcategory {
    label: "Sub-Category (ERP)"
    type: string
    sql: ${TABLE}.erp_subcategory ;;
    group_label: "> Product Attributes"
  }

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
    group_label: "> Product Attributes"

    type: string
    sql: ${TABLE}.replenishment_substitute_group ;;
  }

  dimension: replenishment_substitute_group_parent_sku {

    label:       "Parent SKU (Replenishment Group)"
    description: "The SKU that serves as an identifier per replenishment group. If an item does not belong to a replenishment group, it is the same as its item-SKU"
    group_label: "> Product Attributes"

    type: string
    sql: ${TABLE}.replenishment_substitute_group_parent_sku ;;
  }

  dimension: sku_hub_count {
    label: "Number of Distinct Assigned Hubs"
    type: number
    sql: ${TABLE}.sku_hub_count ;;
    group_label: "> Product Attributes"
  }

  dimension: sku_city_count {
    label: "Number of Distinct Assigned Cities"
    type: number
    sql: ${TABLE}.sku_city_count ;;
    group_label: "> Product Attributes"
  }

  dimension: sku_country_count {
    label: "Number of Distinct Assigned Countries"
    type: number
    sql: ${TABLE}.sku_country_count ;;
    group_label: "> Product Attributes"
  }

  dimension: ingredients {
    type: string
    sql: ${TABLE}.ingredients ;;
    group_label: "> Product Attributes"
  }

  dimension: producer {
    type: string
    sql: ${TABLE}.producer ;;
    group_label: "> Product Attributes"
  }

  dimension: nutrition {
    type: string
    sql: ${TABLE}.nutrition ;;
    group_label: "> Product Attributes"
  }

  dimension: preparation_and_storage {
    type: string
    sql: ${TABLE}.preparation_and_storage ;;
    group_label: "> Product Attributes"
  }

  dimension: allergens {
    type: string
    sql: ${TABLE}.allergens ;;
    group_label: "> Product Attributes"
  }

  dimension: weight {
    group_label: "> Product Attributes"
    hidden: no
    type: number
    sql: ${TABLE}.amt_weight_kg ;;
  }

  dimension: organic_control_number {
    group_label: "> Product Attributes"
    type: string
    sql: ${TABLE}.organic_control_number ;;
  }

  ####### Product Compliance Report Fields ########

  dimension: is_ingredients_missing {
    type: yesno
    sql: case when ${ingredients} is null then True else False end ;;
    group_label: "> Product Compliance"
    html:
    {% if value == 'Yes' %}
    <p style="color: red; font-size: 100%; font-weight: bold">{{ rendered_value }}</p>
    {% elsif value == 'No' %}
    <p style="color: green; font-size:80%">{{ rendered_value }}</p>
    {% endif %};;
  }

  dimension: is_producer_missing {
    type: yesno
    sql: case when ${producer} is null then True else False end ;;
    group_label: "> Product Compliance"
    html:
    {% if value == 'Yes' %}
    <p style="color: red; font-size: 100%; font-weight: bold">{{ rendered_value }}</p>
    {% elsif value == 'No' %}
    <p style="color: green; font-size:80%">{{ rendered_value }}</p>
    {% endif %};;
  }

  dimension: is_nutrition_missing {
    type: yesno
    sql: case when ${nutrition} is null then True else False end ;;
    group_label: "> Product Compliance"
    html:
    {% if value == 'Yes' %}
    <p style="color: red; font-size: 100%; font-weight: bold">{{ rendered_value }}</p>
    {% elsif value == 'No' %}
    <p style="color: green; font-size:80%">{{ rendered_value }}</p>
    {% endif %};;
  }

  dimension: is_preparation_and_storage_missing {
    type: yesno
    sql: case when ${preparation_and_storage} is null then True else False end ;;
    group_label: "> Product Compliance"
    html:
    {% if value == 'Yes' %}
    <p style="color: red; font-size: 100%; font-weight: bold">{{ rendered_value }}</p>
    {% elsif value == 'No' %}
    <p style="color: green; font-size:80%">{{ rendered_value }}</p>
    {% endif %};;
  }

  dimension: is_country_of_origin_missing {
    type: yesno
    sql: case when ${country_of_origin} is null then True else False end ;;
    group_label: "> Product Compliance"
    html:
    {% if value == 'Yes' %}
    <p style="color: red; font-size: 100%; font-weight: bold">{{ rendered_value }}</p>
    {% elsif value == 'No' %}
    <p style="color: green; font-size:80%">{{ rendered_value }}</p>
    {% endif %};;
  }

  dimension: is_unit_of_measure_missing {
    type: yesno
    sql: case when ${unit_of_measure} is null then True else False end ;;
    group_label: "> Product Compliance"
    html:
    {% if value == 'Yes' %}
    <p style="color: red; font-size: 100%; font-weight: bold">{{ rendered_value }}</p>
    {% elsif value == 'No' %}
    <p style="color: green; font-size:80%">{{ rendered_value }}</p>
    {% endif %};;
  }

  dimension: is_product_unit_missing {
    type: yesno
    sql: case when ${product_unit} is null then True else False end ;;
    group_label: "> Product Compliance"
    html:
    {% if value == 'Yes' %}
    <p style="color: red; font-size: 100%; font-weight: bold">{{ rendered_value }}</p>
    {% elsif value == 'No' %}
    <p style="color: green; font-size:80%">{{ rendered_value }}</p>
    {% endif %};;
  }

  dimension: is_base_unit_missing {
    type: yesno
    sql: case when ${base_unit} is null then True else False end ;;
    group_label: "> Product Compliance"
    html:
    {% if value == 'Yes' %}
    <p style="color: red; font-size: 100%; font-weight: bold">{{ rendered_value }}</p>
    {% elsif value == 'No' %}
    <p style="color: green; font-size:80%">{{ rendered_value }}</p>
    {% endif %};;
  }

  dimension: is_allergens_missing {
    type: yesno
    sql: case when ${allergens} is null then True else False end ;;
    group_label: "> Product Compliance"
    html:
    {% if value == 'Yes' %}
    <p style="color: red; font-size: 100%; font-weight: bold">{{ rendered_value }}</p>
    {% elsif value == 'No' %}
    <p style="color: green; font-size:80%">{{ rendered_value }}</p>
    {% endif %};;
  }

  dimension: is_attribute_missing {
    type: yesno
    sql: case when ${is_base_unit_missing} = True
              or ${is_country_of_origin_missing} = True
              or ${is_ingredients_missing} = True
              or ${is_nutrition_missing} = True
              or ${is_preparation_and_storage_missing} = True
              or ${is_producer_missing} = True
              or ${is_product_unit_missing} = True
              or ${is_unit_of_measure_missing} = True
              or ${is_allergens_missing} = True
          then
            True
          else
            False
        end;;
    group_label: "> Product Compliance"
  }

  dimension: missing_attributes_count {
    type: number
    sql: cast(${is_base_unit_missing} as int64) +
         cast(${is_country_of_origin_missing} as int64) +
         cast(${is_ingredients_missing} as int64) +
         cast(${is_nutrition_missing} as int64) +
         cast(${is_preparation_and_storage_missing} as int64) +
         cast(${is_producer_missing} as int64) +
         cast(${is_product_unit_missing} as int64) +
         cast(${is_unit_of_measure_missing} as int64) +
         cast(${is_allergens_missing} as int64);;
    group_label: "> Product Compliance"
  }

  # =========  PARAMETER   =========

  parameter: product_granularity_parameter {
    group_label: "* Granularity *"
    label: "Product Granularity Parameter"
    type: unquoted
    allowed_value: { value: "Subcategory" }
    allowed_value: { value: "Category" }
    allowed_value: { value: "Substitute" }
    default_value: "Category"
  }

  dimension: product_granularity {
    group_label: "> Product Attributes"
    label: "Product Granularity (Dynamic)"
    label_from_parameter: product_granularity_parameter
    sql:
    {% if product_granularity_parameter._parameter_value == 'Subcategory' %}
      ${subcategory}
    {% elsif product_granularity_parameter._parameter_value == 'Category' %}
      ${category}
    {% elsif product_granularity_parameter._parameter_value == 'Substitute' %}
      coalesce(${substitute_group},${product_name})
    {% endif %};;
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
    sql: ${TABLE}.created_at_timestamp ;;
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
    sql: ${TABLE}.last_modified_at_timestamp ;;
    hidden: no
    group_label: "> Dates & Timestamps"
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
    hidden: no
    label: "Country Iso"
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
    sql: ${TABLE}.amt_deposit_gross_eur ;;
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
    sql: ${TABLE}.amt_unit_price_gross_eur ;;
    group_label: "> Price Data"
  }

  dimension: base_unit_price_display {
    type: string
    sql: ${TABLE}.amt_unit_price_display_gross_eur ;;
    group_label: "> Price Data"
  }

  dimension: storage_fee {
    label: "Storage Fee"
    description: "A fee charged to customers for certain products that require special treatment"
    type: number
    sql: ${TABLE}.amt_storage_fee_gross_eur ;;
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
    type: string
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

  dimension: is_drug_item {
    label:       "Is Drug Item"
    description: "This flag is true for all items that relate to wine, hard alcohol and tabac"
    type: yesno
    sql:

    case
      when

      (  lower(${category}) like 'spirit%'
      or lower(${category}) like 'tabak%'
      or lower(${category}) like 'rauchen%'
      or lower(${category}) like '%champagnes'
      or lower(${category}) like 'wein%'
      or lower(${category}) like 'wijn%'
      )

      then true
      else false
    end ;;
  }

  dimension: image_urls {
    type: string
    sql: ${TABLE}.image_urls ;;
    group_label: "> Special Purpose Data"
    label: "Image URLs"
  }

  dimension: rewe_url {
    sql: concat("https://shop.rewe.de/productList?search=", split(${TABLE}.ean, ",")[safe_offset(0)]) ;;
    link: {
      label: "Rewe URL"
      url: "{{ value }}"
      icon_url: "https://upload.wikimedia.org/wikipedia/commons/4/4c/Logo_REWE.svg"
    }
    group_label: "> Special Purpose Data"
    label: "Rewe URL"
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    New fields from curated.erp_item
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dimension: erp_base_uom {
    label: "Base UOM (ERP)"
    description: "The base unit-of-measure of a product according to our ERP system"
    group_label: "ERP fields"
    type: string
    sql: ${TABLE}.erp_base_uom ;;
  }

  dimension: erp_ean {
    label: "EAN (ERP)"
    description: "The european article number (EAN) of a product according to our ERP system"
    group_label: "ERP fields"
    type: string
    sql: ${TABLE}.erp_ean ;;
  }


  dimension: erp_group_company {
    label: "Group Company (ERP)"
    description: "The producing company of a product according to our ERP system"
    group_label: "ERP fields"
    type: string
    sql: ${TABLE}.erp_group_company ;;
  }

  dimension: erp_hub_type {
    label: "Hub Type (ERP)"
    description: "The hub type indicates, to which kind of hubs a given product is usually assigned to. Hereby, an assignment to an M-hub indicates, that the product is usually offered in all M hubs or bigger (L hubs)"
    group_label: "ERP fields"
    type: string
    sql: ${TABLE}.erp_hub_type ;;
  }


  dimension_group: erp_introduction {
    label: "Item Introduction"
    description: "The date, when a given product was listed initially"
    group_label: "ERP fields"
    type: time
    timeframes: [
      date
    ]
    sql: ${TABLE}.erp_introduction_timestamp ;;
  }

  dimension_group: erp_termination {
    label: "Item Termination"
    description: "The date, when a given product was delisted"
    group_label: "ERP fields"
    type: time
    timeframes: [
      date
    ]
    sql: ${TABLE}.erp_termination_timestamp ;;
  }

  dimension: erp_item_status {
    label: "Item Status (ERP)"
    description: "  The activity/listing status of a product according to our ERP system"
    group_label: "ERP fields"
    type: string
    sql: ${TABLE}.erp_item_status ;;
  }

  dimension: erp_item_status_update_date {
    label: "Last Item Status (ERP) Update"
    description: "The date, when the item status changed the last time."
    group_label: "ERP fields"
    type: date
    datatype: date
    sql: ${TABLE}.erp_item_status_update ;;
  }

  dimension: erp_max_shelf_life_days {
    label: "Max Shelf Life Days (ERP)"
    description: "SKU's max amount of days on shelf."
    group_label: "ERP fields"
    type: string
    sql: ${TABLE}.erp_max_shelf_life_days ;;
  }

  dimension: erp_min_days_to_best_before_date {
    label: "Min Days to BBD (ERP)"
    description: "The minimum duration required between the sale of the product and the BBD (in days)."
    group_label: "ERP fields"
    type: string
    sql: ${TABLE}.erp_min_days_to_best_before_date ;;
  }

  dimension: erp_purchase_unit {
    label: "Purchase Unit (ERP)"
    description: "The ERP defined puchase unit code of a product. It defines, which aggregation was bought (examples: STÜCK, PK14, PK06)"
    group_label: "ERP fields"
    type: string
    sql: ${TABLE}.erp_purchase_unit ;;
  }

  dimension: erp_replenishment_substitute_group {
    label: "Replenishment Substitute Group (ERP)"
    description: "The replenishment substitute group defined by the Supply Chain team to tag substitute products for replenishment."
    group_label: "ERP fields"
    type: string
    sql: ${TABLE}.erp_replenishment_substitute_group ;;
  }

  dimension: erp_shelf_type {
    label: "Shelf Type (ERP)"
    description: "The shelf type provides information on where a product is stored in a hub. An example for a shelf code would be `203 | Fridge 7° | Cooled drinks`"
    group_label: "ERP fields"
    type: string
    sql: ${TABLE}.erp_shelf_type ;;
  }

  dimension: erp_temperature_zone {
    label: "Temperature Zone (ERP)"
    description: "  Temperature a product needs to have while being delivered and stored in order to be consumable"
    group_label: "ERP fields"
    type: string
    sql: ${TABLE}.erp_temperature_zone ;;
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Measures
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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
    label: "SUM Product Price Gross"
    group_label: "* Price Stats *"
    type: sum
    value_format: "0.00"
    sql: ${TABLE}.amt_product_price_gross ;;
  }

  measure: avg_amt_product_price_gross{
    label: "AVG Product Price Gross"
    group_label: "* Price Stats *"
    type: average
    value_format: "€0.00"
    sql: ${TABLE}.amt_product_price_gross ;;
  }

  measure: med_amt_product_price_gross{
    label: "MED Product Price Gross"
    group_label: "* Price Stats *"
    type: median
    value_format: "€0.00"
    sql: ${TABLE}.amt_product_price_gross ;;
  }

  measure: max_amt_product_price_gross{
    label: "MAX Product Price Gross"
    group_label: "* Price Stats *"
    type: max
    value_format: "€0.00"
    sql: ${TABLE}.amt_product_price_gross ;;
  }

  measure: min_amt_product_price_gross{
    label: "MIN Product Price Gross"
    group_label: "* Price Stats *"
    type: min
    value_format: "€0.00"
    sql: ${TABLE}.amt_product_price_gross ;;
  }

  measure: avg_storage_fee {
    label: "AVG Storage Fee"
    description: "A fee charged to customers for certain products that require special treatment"
    group_label: "* Price Stats *"
    type: average
    sql: ${storage_fee} ;;
    value_format_name: eur
  }

  measure: count {
    type: count
    drill_fields: [product_name]
    hidden: yes
  }
}
