# Owner:  Brandon Beckett
# Created: 2022-03-11

# This view contains reporting layer data that identifies unique Flink products by SKU that are distinct from competitor products.


view: unique_assortment {
  label: "* Unique Assortment *"
  sql_table_name: `flink-data-prod.reporting.unique_assortment` ;;

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# ====================     __main__     ====================

  dimension: product_sku {
    type: string
    sql: ${TABLE}.product_sku ;;
    primary_key: yes
    hidden: yes
  }

  dimension: is_distinct_from_albert_heijn {
    type: yesno
    sql: ${TABLE}.is_distinct_from_albert_heijn ;;
    description: "Yes: There is no equivalent product match found in Albert Heijn's assortment.
                  No: There is an equivalent product match found in Albert Heijn's assortment."
  }

  dimension: is_distinct_from_getir {
    type: yesno
    sql: ${TABLE}.is_distinct_from_getir ;;
    description: "Yes: There is no equivalent product match found in Getir's assortment.
                  No: There is an equivalent product match found in Getir's assortment."
  }

  dimension: is_distinct_from_gorillas {
    type: yesno
    sql: ${TABLE}.is_distinct_from_gorillas ;;
    description: "Yes: There is no equivalent product match found in Gorillas's assortment.
                  No: There is an equivalent product match found in Gorillas's assortment."
  }

  dimension: is_distinct_from_rewe {
    type: yesno
    sql: ${TABLE}.is_distinct_from_rewe ;;
    description: "Yes: There is no equivalent product match found in REWE's assortment.
                  No: There is an equivalent product match found in REWE's assortment."
  }

# ====================      hidden      ====================



# ====================       IDs        ====================

  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
  }

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: num_sku {
    label: "# SKUs"
    description: "Number of Total SKUs in the Assortment depending on the Filters Selected"
    type: count
    value_format: "0"
  }

}
