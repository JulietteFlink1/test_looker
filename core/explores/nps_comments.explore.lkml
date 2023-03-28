include: "/**/nps_comments_words_count.view"
include: "/**/nps_comments_words_ranked.view"
include: "/**/nps_comments_labeled.view"
include: "/**/nps_after_order_cl.view"
include: "/pricing/views/bigquery_reporting/hub_specific_price_hub_cluster.view.lkml"

explore: nps_comments {
  view_name: nps_comments_words_count
  hidden:  no
  label: "NPS Comments"
  view_label: "NPS Comments Words Count"

  join: nps_comments_labeled {
    from: nps_comments_labeled
    sql_on: ${nps_comments_words_count.response_uuid} = ${nps_comments_labeled.response_uuid}
  ;;
    relationship: many_to_many
    type: left_outer

  }

  join: nps_comments_words_ranked {
    from: nps_comments_words_ranked
    sql_on: ${nps_comments_words_count.word} = ${nps_comments_words_ranked.word};;
    relationship: many_to_one
    type: left_outer

  }

  join: nps_after_order_cl {
    from: nps_after_order_cl
    view_label: "NPS - Order"
    sql_on: ${nps_comments_words_count.response_uuid} = ${nps_after_order_cl.response_uuid};;
    relationship: many_to_one
    type: left_outer
    fields: [nps_after_order_cl.order_number]

  }

  join: geographic_pricing_hub_cluster {
    from: geographic_pricing_hub_cluster
    sql_on: ${nps_comments_labeled.hub_code} = ${geographic_pricing_hub_cluster.hub_code};;
    type: left_outer
    relationship: many_to_one
  }

}
