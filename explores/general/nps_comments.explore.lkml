include: "/views/bigquery_tables/reporting_layer/nps/nps_comments_words_count.view.lkml"
include: "/views/bigquery_tables/reporting_layer/nps/nps_comments_labeled.view.lkml"


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
}
