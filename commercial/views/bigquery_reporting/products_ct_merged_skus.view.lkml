# Owner: Andreas Stueber
# Created: 2023-01-02
# Purpose:
#   - provide a table to consistently report on merged SKUs in Looker

view: products_ct_merged_skus {
  sql_table_name: `flink-data-dev.dbt_astueber_reporting.products_ct_merged_skus`
    ;;
  view_label: "Product Attributes (Merged SKUs)"

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Main fields
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  dimension: table_uuid {
    group_label: "> per merged SKUs"
    type: string
    description: "Generic identifier of a table in BigQuery that represent 1 unique row of this table."
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
  }

  dimension: country_iso {
    label: "Country Iso (merged SKU)"
    group_label: "> per merged SKUs"
    description: "Country ISO based on 'hub_code'."
    type: string
    sql: ${TABLE}.country_iso ;;
    hidden: yes
  }

  dimension: sku {
    label: "SKU (Merged SKUs)"
    group_label: "> per merged SKUs"
    type: string
    description: "SKU of the product, as available in the backend."
    sql: ${TABLE}.sku ;;
    hidden: yes
  }

  dimension: merged_sku {
    label: "Merged SKU"
    type: string
    description: "The SKU that was kept, when local SKUs were merged into a single SKU defined/unique by its EAN code."
    sql: ${TABLE}.merged_sku ;;
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Fields per merged SKU
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  dimension_group: created {
    label: "SKU Created (merged SKU)"
    group_label: "> per merged SKUs"
    description: "The creation date and time of a record"
    type: time
    timeframes: [
      time,
      date
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: ean {
    label: "EAN (merged SKU)"
    group_label: "> per merged SKUs"
    description: "The european article number (EAN) of a product"
    type: string
    sql: ${TABLE}.ean ;;
  }

  dimension: group_company {
    label: "Group Company (merged SKU)"
    group_label: "> per merged SKUs"
    description: "The producing company of a product."
    type: string
    sql: ${TABLE}.group_company ;;
  }

  dimension: category {
    label: "Parent Category (merged SKU)"
    group_label: "> per merged SKUs"
    description: "Category of the product, as available in the backend tables."
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: amt_product_price_gross {
    label: "Unit Price Gross Amount (merged SKU)"
    group_label: "> per merged SKUs"
    description: "Price of the product for which user bought an item, also includes discounted values (including VAT)."
    type: number
    sql: ${TABLE}.amt_product_price_gross ;;
  }

  dimension: amt_storage_fee_gross {
    label: "Storage Fee Gross (Merged SKUs)"
    group_label: "> per merged SKUs"
    description: "Gross amount of storage fees associated to the order.
    Storage Fees are a new fee which applies to products which require a special storage, in a locked shelf (e.g. cigarettes, jewellery).
    Find out more [here](https://goflink.atlassian.net/wiki/spaces/DATA/pages/413958360/Storage+Fees)."
    type: number
    sql: ${TABLE}.amt_storage_fee_gross ;;
  }

  dimension: base_uom {
    label: "Unit of Measure (Merged SKUs)"
    group_label: "> per merged SKUs"
    description: "The base unit of measure of a product"
    type: string
    sql: ${TABLE}.base_uom ;;
  }

  dimension: deposit_amount {
    label: "Deposit Amount (Merged SKUs)"
    group_label: "> per merged SKUs"
    description: "The deposit amount of a product"
    type: number
    sql: ${TABLE}.deposit_amount ;;
  }

  dimension: hub_type {
    label: "Hub Type (Merged SKUs)"
    group_label: "> per merged SKUs"
    type: string
    description: "The hub type indicates, to which kind of hubs a given product is usually assigned to. Hereby, an assignment to an M-hub indicates, that the product is usually offered in all M hubs or bigger (L hubs)"
    sql: ${TABLE}.hub_type ;;
  }

  dimension: is_published {
    label: "Is Published (Merged SKUs)"
    group_label: "> per merged SKUs"
    type: yesno
    description: "This boolean flag indicates, whether a product is published (and thus orderable by consumers in the app) in CommerceTools"
    sql: ${TABLE}.is_published ;;
  }

  dimension: item_replenishment_substitute_group {
    label: "Replenishment Substitute Group ERP (Merged SKUs)"
    group_label: "> per merged SKUs"
    type: string
    description: "The replenishment substitute group defined by the Supply Chain team to tag substitute products for replenishment."
    sql: ${TABLE}.item_replenishment_substitute_group ;;
  }

  dimension: item_status {
    label: "Item Status (Merged SKUs)"
    group_label: "> per merged SKUs"
    type: string
    description: "The activity/listing status of a product according to our ERP system"
    sql: ${TABLE}.item_status ;;
  }

  dimension_group: item_status_update {
    label: "Last Item Status Update (Merged SKUs)"
    group_label: "> per merged SKUs"
    type: time
    description: "The date, when the item status changed the last time."
    timeframes: [
      raw,
      date
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.item_status_update ;;
  }

  dimension: product_brand {
    label: "Product Brand (Merged SKUs)"
    group_label: "> per merged SKUs"
    type: string
    description: "Brand a product belongs to."
    sql: ${TABLE}.product_brand ;;
  }

  dimension: product_name {
    label: "Product Name (Merged SKUs)"
    group_label: "> per merged SKUs"
    type: string
    description: "Name of the product, as specified in the backend."
    sql: ${TABLE}.product_name ;;
  }

  dimension: purchase_unit {
    label: "Purchase Unit (Merged SKUs)"
    group_label: "> per merged SKUs"
    type: string
    description: "The ERP defined puchase unit code of a product. It defines, which aggregation was bought (examples: STÜCK, PK14, PK06)"
    sql: ${TABLE}.purchase_unit ;;
  }

  dimension: replenishment_substitute_group {
    label: "Replenishment Substitute Group CT (Merged SKUs)"
    group_label: "> per merged SKUs"
    type: string
    description: "The replenishment substitute group defined by the Supply Chain team to tag substitute products for replenishment."
    sql: ${TABLE}.replenishment_substitute_group ;;
  }

  dimension: replenishment_substitute_group_parent_sku {
    label: "Parent SKU (Merged SKUs)"
    group_label: "> per merged SKUs"
    type: string
    description: "Parent SKU of a product. This groups several child SKUs that belongs to the same replenishment substitute group."
    sql: ${TABLE}.replenishment_substitute_group_parent_sku ;;
  }

  dimension: subcategory {
    label: "Sub-Category (Merged SKUs)"
    group_label: "> per merged SKUs"
    type: string
    description: "The Subcategory of the product, as available in the backend tables."
    sql: ${TABLE}.subcategory ;;
  }

  dimension: substitute_group {
    label: "Substitute Group (Merged SKUs)"
    group_label: "> per merged SKUs"
    type: string
    description: "The substitute group according to CommerceTools defining substitute products from the customer perspective."
    sql: ${TABLE}.substitute_group ;;
  }



  dimension: tax_rate {
    label: "Tax Rate (Merged SKUs)"
    group_label: "> per merged SKUs"
    type: number
    description: "The specific tax rate of a product"
    sql: ${TABLE}.tax_rate ;;
  }

  dimension: unit_price {
    label: "Unit Price (Merged SKUs)"
    group_label: "> per merged SKUs"
    type: number
    description: "The price of 1 single product (incl. VAT)"
    sql: ${TABLE}.unit_price ;;
  }

  dimension: unit_price_display {
    label: "Unit Price Displayed (Merged SKUs)"
    group_label: "> per merged SKUs"
    type: string
    description: "The price of 1 single product (incl. VAT) by its unit of measure"
    sql: ${TABLE}.unit_price_display ;;
  }
}
