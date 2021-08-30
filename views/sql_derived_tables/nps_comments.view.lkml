view: nps_comments {
    derived_table: {
      datagroup_trigger: flink_default_datagroup
      sql:
          SELECT * FROM `flink-data-dev.sandbox.elvira_nps_cleaned2`

       ;;
    }


    dimension: country_iso {
      type: string
      hidden: no
      sql: ${TABLE}.country_iso ;;
    }

    dimension: hub_code {
      type: string
      hidden: no
      sql: ${TABLE}.hub_code ;;
    }

    dimension: nps_word {
      primary_key: yes
      hidden: no
      type: string
      sql: ${TABLE}.nps_word  ;;
    }


    dimension: score {
      type: number
      hidden:  no
      sql: ${TABLE}.score;;
      value_format: "0"
    }

    dimension: submitted_date {
      type: date
      datatype: date
      sql: ${TABLE}.submitted_date ;;
      hidden: no
  }

  measure: word_count {
    label: "# Word Appearances"
    hidden:  no
    type: count
    #sql: ${TABLE}.nps_word;;
    value_format: "0"
  }

  }
