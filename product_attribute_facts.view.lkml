view: product_attribute_facts {
  derived_table: {
    sql:
          SELECT
          a.country_iso,
          a.id,
          b.sku,
          MAX(case when f.slug='leading-product' THEN g.name end) as leading_product,
          MAX(case when f.slug='noos-group' THEN g.name end) as noos_group,
          MAX(case when f.slug='substitute-group' THEN g.name end) as substitute_group,
          MAX(case when f.slug='substitute-group-internal-ranking' THEN g.name end) as substitute_group_internal_ranking,
          MAX(case when f.slug='ean' THEN g.name end) as ean


          FROM `flink-backend.saleor_db_global.product_product` a
          left join `flink-backend.saleor_db_global.product_productvariant` b ON a.id=b.product_id and a.country_iso=b.country_iso
          left join `flink-backend.saleor_db_global.product_assignedproductattribute` c ON a.id=c.product_id and a.country_iso=c.country_iso
          left join `flink-backend.saleor_db_global.product_assignedproductattribute_values` d ON c.id=d.assignedproductattribute_id and c.country_iso=d.country_iso
          left join `flink-backend.saleor_db_global.product_attributeproduct` e ON c.assignment_id=e.id and e.country_iso=c.country_iso
          left join `flink-backend.saleor_db_global.product_attribute` f ON e.attribute_id=f.id and f.country_iso=e.country_iso
          left join `flink-backend.saleor_db_global.product_attributevalue` g ON d.attributevalue_id=g.id and d.country_iso=g.country_iso

          where f.slug IN ('leading-product', 'noos-group', 'substitute-group', 'substitute-group-internal-ranking', 'ean')
          group by 1,2,3
          order by 3
          ;;
  }

  view_label: "* Product / SKU Data *"

  dimension: country_iso {
    type: string
    hidden: yes
    sql: ${TABLE}.country_iso ;;
  }

  dimension: id {
    group_label: "* IDs *"
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: unique_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: concat(${country_iso}, ${id}) ;;
  }

  dimension: sku {
    group_label: "* IDs *"
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: leading_product {
    group_label: "* Product Attributes *"
    type: string
    sql: ${TABLE}.leading_product ;;
  }

  dimension: noos_group {
    group_label: "* Product Attributes *"
    type: string
    sql: ${TABLE}.noos_group ;;
  }

  dimension: substitute_group {
    group_label: "* Product Attributes *"
    type: string
    sql: ${TABLE}.substitute_group ;;
  }

  dimension: substitue_group_complete {
    group_label: "* Product Attributes *"
    description: "Returns the substitute group if set, else returns the product name"
    type: string
    sql: coalesce(${substitute_group}, (${order_orderline.product_name})) ;;
  }

  dimension: substitute_group_internal_ranking {
    group_label: "* Product Attributes *"
    type: string
    sql: ${TABLE}.substitute_group_internal_ranking ;;
  }

  dimension: ean {
    group_label: "* IDs *"
    type: string
    sql: ${TABLE}.ean ;;
  }


}
