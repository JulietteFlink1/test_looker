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
          MAX(case when f.slug='substitute-group-internal-ranking' THEN g.name end) as substitute_group_internal_ranking

          FROM `flink-backend.saleor_db_global.product_product` a
          left join `flink-backend.saleor_db_global.product_productvariant` b ON a.id=b.product_id
          left join `flink-backend.saleor_db_global.product_assignedproductattribute` c ON a.id=c.product_id
          left join `flink-backend.saleor_db_global.product_assignedproductattribute_values` d ON c.id=d.assignedproductattribute_id
          left join `flink-backend.saleor_db_global.product_attributeproduct` e ON c.assignment_id=e.id
          left join `flink-backend.saleor_db_global.product_attribute` f ON e.attribute_id=f.id
          left join `flink-backend.saleor_db_global.product_attributevalue` g ON d.attributevalue_id=g.id

          where f.slug IN ('leading-product', 'noos-group', 'substitute-group', 'substitute-group-internal-ranking')
          group by 1,2,3
          ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: id {
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: unique_id {
    primary_key: yes
    type: string
    sql: concat(${country_iso}, ${id}) ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: leading_product {
    type: string
    sql: ${TABLE}.leading_product ;;
  }

  dimension: noos_group {
    type: string
    sql: ${TABLE}.noos_group ;;
  }

  dimension: substitute_group {
    type: string
    sql: ${TABLE}.substitute_group ;;
  }

  dimension: substitute_group_internal_ranking {
    type: string
    sql: ${TABLE}.substitute_group_internal_ranking ;;
  }


}
