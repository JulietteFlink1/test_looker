view: supplier_invoices {
  sql_table_name: `flink-data-dev.curated.supplier_invoices`
      ;;

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




########################################################################################################
####################################### Date Dimension #################################################
########################################################################################################


  dimension_group: billing_period_start {
    type: time
    label:       "Invoice date"
    description: "First date of the billing period and date when the invoice is issued."
    group_label: ">> Dates & Timestamps"
    timeframes: [
      date,
      week,
      month,
    ]
    convert_tz: no
    hidden: no
    datatype: date
    sql: ${TABLE}.billing_period_start ;;
  }

  dimension_group: billing_period_end {
    type: time
    label:       "Invoice date"
    description: "Last date of the billing period."
    group_label: ">> Dates & Timestamps"
    timeframes: [
      date,
      week,
      month,
    ]
    convert_tz: no
    hidden: yes
    datatype: date
    sql: ${TABLE}.billing_period_end ;;
  }

  dimension_group: reference_date {
    type: time
    label:       "Delivery date"
    description: "Date when the dispatch notification is imported."
    group_label: ">> Dates & Timestamps"
    timeframes: [
      date,
      week,
      month,
    ]
    convert_tz: no
    hidden: yes
    datatype: date
    sql: ${TABLE}.reference_date ;;
  }

########################################################################################################
############################################### Main ###################################################
########################################################################################################




########################################################################################################
############################################# IDs Dimension ############################################
########################################################################################################

  dimension: invoice_id {
    label:       "Invoice ID"
    description: "The ID of the invoice."
    type: string
    sql: ${TABLE}.invoice_id ;;
  }

  dimension: supplier_id {
    label:       "Supplier ID"
    description: "The ID of the supplier"
    group_label: " >> IDs "
    type: string
    sql: ${TABLE}.supplier_id ;;
  }

  dimension: invoice_item_id {
    label:       "Invoice Item ID"
    description: "The ID of the item in invoice.The item ID is unique per invoice."
    group_label: " >> IDs "
    type: string
    sql: ${TABLE}.invoice_item_id ;;
  }

  dimension: order_number {
    label:       "Order Number"
    description: "Order Number for orders placed by Flink to it's suppliers"
    group_label: " >> IDs "
    type: number
    sql: safe_cast(${TABLE}.order_number as string) ;;
  }

  dimension: table_uuid {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.table_uuid ;;
  }

########################################################################################################
############################################# IDs Dimension ############################################
########################################################################################################

  dimension: hub_code {
    label: "Hub Code"
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: country_iso {
    label: "Country"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: payment_status {
    label: "Payment Status"
    description: "The payment status defines, whether the invoice is paid."
    type: string
    sql: ${TABLE}.payment_status ;;
  }

  dimension: sku {
    label:       "SKU"
    description: "The identified of a product"
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: item_name {
    label:       "Product Name"
    description: "The name of a product"
    type: string
    sql: ${TABLE}.item_name ;;
  }

########################################################################################################
##################################### Line-Items Q Dimensions ##########################################
########################################################################################################


  dimension: item_quantity {
    label:       "Item Quantity"
    description: "The amount of ordered items"
    group_label: " >> Line Item Data"
    type: number
    hidden: no
    sql: safe_cast(${TABLE}.handling_units_count as numeric) ;;
  }

  dimension: amt_item_price {
    label:       "Item Price Net"
    description: "The price (net) per one item."
    group_label: " >> Line Item Data"
    type: number
    hidden: no
    sql: safe_cast(${TABLE}.amt_item_price as numeric) ;;
  }

  dimension: amt_total_price {
    label:       "Item Total Price Net"
    description: "The total price (net) per item (item price multiplied by item quantity)."
    group_label: " >> Line Item Data"
    type: number
    hidden: no
    sql: safe_cast(${TABLE}.amt_total_price as numeric) ;;
  }

  dimension: item_tax_rate {
    label:       "Item Tax Rate (%)"
    description: "The tax rate (%) per item"
    group_label: " >> Line Item Data"
    type: number
    hidden: yes
    sql: safe_cast(${TABLE}.item_tax_rate as numeric) ;;
  }

########################################################################################################
################################################ Measures ##############################################
########################################################################################################

  measure: sum_item_quantity {

    label:       "# Item Quantity"
    description: "The amount of ordered items"
    type: sum
    sql: ${item_quantity} ;;
  }

  measure: sum_amt_item_price {

    label:       "€ Item Price Net"
    description: "The price (net) per one item."
    type: sum
    sql: ${amt_item_price} ;;
  }

  measure: sum_amt_total_price {

    label:       "€ Item Total Price Net"
    description: "The total price (net) per item (item price multiplied by item quantity)."
    type: sum
    sql: ${amt_total_price} ;;
  }












}
