view: gorillas_items {
  sql_table_name: `flink-data-dev.competitive_intelligence.gorillas_items`
    ;;
  drill_fields: [id]


  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: additional_images {
    hidden: yes
    sql: ${TABLE}.additionalImages ;;
  }

  dimension: additional_information {
    type: string
    sql: ${TABLE}.additionalInformation ;;
  }

  dimension: additives {
    hidden: yes
    sql: ${TABLE}.additives ;;
  }

  dimension: allergens {
    hidden: yes
    sql: ${TABLE}.allergens ;;
  }

  dimension: barcodes {
    hidden: yes
    sql: ${TABLE}.barcodes ;;
  }

  dimension: brand_id {
    type: string
    sql: ${TABLE}.brandId ;;
  }

  dimension: brand_image {
    type: string
    sql: ${TABLE}.brandImage ;;
  }

  dimension: brand_name {
    type: string
    sql: ${TABLE}.brandName ;;
  }

  dimension: buying_category {
    type: string
    sql: ${TABLE}.buyingCategory ;;
  }

  dimension: buying_subcategory {
    type: string
    sql: ${TABLE}.buyingSubcategory ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: collection {
    type: string
    sql: ${TABLE}.collection ;;
  }

  dimension: commission {
    type: number
    sql: ${TABLE}.commission ;;
  }

  dimension: created_on {
    type: number
    sql: ${TABLE}.createdOn ;;
  }

  dimension: customization_items {
    hidden: yes
    sql: ${TABLE}.customizationItems ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }

  dimension: group {
    type: string
    sql: ${TABLE}.`group` ;;
  }

  dimension: has_special_instructions {
    type: yesno
    sql: ${TABLE}.hasSpecialInstructions ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: image_url {
    type: string
    sql: ${TABLE}.imageUrl ;;
  }

  dimension: is_active {
    type: yesno
    sql: ${TABLE}.isActive ;;
  }

  dimension: is_price_overridden {
    type: yesno
    sql: ${TABLE}.isPriceOverridden ;;
  }

  dimension: is_published {
    type: yesno
    sql: ${TABLE}.isPublished ;;
  }

  dimension: is_variable_price {
    type: yesno
    sql: ${TABLE}.isVariablePrice ;;
  }

  dimension: item_type {
    type: string
    sql: ${TABLE}.itemType ;;
  }

  dimension: item_view_type {
    type: string
    sql: ${TABLE}.itemViewType ;;
  }

  dimension: label {
    type: string
    sql: ${TABLE}.label ;;
  }

  dimension: last_modified {
    type: number
    sql: ${TABLE}.lastModified ;;
  }

  dimension: legacy_id {
    type: number
    sql: ${TABLE}.legacyId ;;
  }

  dimension: main_group {
    type: string
    sql: ${TABLE}.mainGroup ;;
  }

  dimension: max_qty {
    type: number
    sql: ${TABLE}.maxQty ;;
  }

  dimension: min_qty {
    type: number
    sql: ${TABLE}.minQty ;;
  }

  dimension: never_recommend {
    type: yesno
    sql: ${TABLE}.neverRecommend ;;
  }

  dimension: operation_uid {
    type: string
    sql: ${TABLE}.operationUid ;;
  }

  dimension: out_of_stock {
    type: yesno
    sql: ${TABLE}.outOfStock ;;
  }

  dimension: price {
    type: number
    sql: ${TABLE}.price ;;
  }

  dimension: product_collections {
    hidden: yes
    sql: ${TABLE}.productCollections ;;
  }

  dimension: promo_tag {
    type: string
    sql: ${TABLE}.promoTag ;;
  }

  dimension: qty_per_unit {
    type: number
    sql: ${TABLE}.qtyPerUnit ;;
  }

  dimension: rating_enabled {
    type: yesno
    sql: ${TABLE}.ratingEnabled ;;
  }

  dimension: recommendation_level {
    type: number
    sql: ${TABLE}.recommendationLevel ;;
  }

  dimension: recommendation_tags {
    hidden: yes
    sql: ${TABLE}.recommendationTags ;;
  }

  dimension: reference_sku {
    type: string
    sql: ${TABLE}.referenceSku ;;
  }

  dimension: requires_legal_age {
    type: yesno
    sql: ${TABLE}.requiresLegalAge ;;
  }

  dimension: scrape_id {
    type: string
    sql: ${TABLE}.scrape_id ;;
  }

  dimension: search_keywords {
    type: string
    sql: ${TABLE}.searchKeywords ;;
  }

  dimension: size {
    type: number
    sql: ${TABLE}.size ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: sort_order {
    type: number
    sql: ${TABLE}.sortOrder ;;
  }

  dimension: stock_threshold {
    type: number
    sql: ${TABLE}.stockThreshold ;;
  }

  dimension: tags {
    hidden: yes
    sql: ${TABLE}.tags ;;
  }

  dimension: tenant_uid {
    type: string
    sql: ${TABLE}.tenantUid ;;
  }

  dimension: third_party_uid {
    type: string
    sql: ${TABLE}.thirdPartyUid ;;
  }

  dimension: thumbnail_url {
    type: string
    sql: ${TABLE}.thumbnailUrl ;;
  }

  dimension_group: time_scraped {
    label: "Scraping Date"
    type: time
    description: "bq-datetime"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.time_scraped ;;
  }

  dimension: unit {
    type: string
    sql: ${TABLE}.unit ;;
  }

  dimension: updated_on {
    type: number
    sql: ${TABLE}.updatedOn ;;
  }

  dimension: vat_free {
    type: yesno
    sql: ${TABLE}.vatFree ;;
  }

  dimension: vat_percent {
    type: number
    sql: ${TABLE}.vatPercent ;;
  }

  dimension: weight {
    type: number
    sql: ${TABLE}.weight ;;
  }

  dimension: with_reminder {
    type: yesno
    sql: ${TABLE}.withReminder ;;
  }

  measure: count {
    type: count
    drill_fields: [id, brand_name]
  }

  measure: count_distinct_id{
    type: count_distinct
    sql: ${TABLE}.id ;;
  }


}

view: gorillas_items__tags {
  dimension: gorillas_items__tags {
    type: string
    sql: gorillas_items__tags ;;
  }
}

view: gorillas_items__barcodes {
  dimension: gorillas_items__barcodes {
    type: string
    sql: gorillas_items__barcodes ;;
  }
}

view: gorillas_items__additives {
  dimension: label {
    type: string
    sql: ${TABLE}.label ;;
  }
}

view: gorillas_items__allergens {
  dimension: label {
    type: string
    sql: ${TABLE}.label ;;
  }
}

view: gorillas_items__recommendation_tags {
  dimension: gorillas_items__recommendation_tags {
    type: string
    sql: gorillas_items__recommendation_tags ;;
  }
}

view: gorillas_items__customization_items {
  dimension: gorillas_items__customization_items {
    type: string
    sql: gorillas_items__customization_items ;;
  }
}

view: gorillas_items__additional_images {
  dimension: normal {
    type: string
    sql: ${TABLE}.normal ;;
  }

  dimension: thumbnail {
    type: string
    sql: ${TABLE}.thumbnail ;;
  }

  dimension: uid {
    type: string
    sql: ${TABLE}.uid ;;
  }
}

view: gorillas_items__product_collections {
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: deleted {
    type: yesno
    sql: ${TABLE}.deleted ;;
  }

  dimension: group {
    type: string
    sql: ${TABLE}.`group` ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }
}
