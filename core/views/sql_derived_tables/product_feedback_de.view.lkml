view: product_feedback_de {
    derived_table: {
      sql: SELECT
          was_mochtest_du_uns_heute_mitteilen_,
          bitte_wahle_die_art_der_produkte_aus_die_du_vorschlagen_mochtest_,
          super_bitte_wahle_die_kategorien_aus_fur_die_du_neue_produkte_vorschlagen_mochtest_,
          welche_produkte_oder_features_fehlen_dir_noch_
      FROM `flink-data-prod.google_sheets.product_feedback_de`
      where was_mochtest_du_uns_heute_mitteilen_ = 'Ein neues Produkt vorschlagen'
       ;;
    }

    measure: count {
      type: count
      drill_fields: [detail*]
    }

    dimension: was_mochtest_du_uns_heute_mitteilen_ {
      type: string
      sql: ${TABLE}.was_mochtest_du_uns_heute_mitteilen_ ;;
    }

    dimension: bitte_wahle_die_art_der_produkte_aus_die_du_vorschlagen_mochtest_ {
      type: string
      sql: ${TABLE}.bitte_wahle_die_art_der_produkte_aus_die_du_vorschlagen_mochtest_ ;;
    }

    dimension: super_bitte_wahle_die_kategorien_aus_fur_die_du_neue_produkte_vorschlagen_mochtest_ {
      type: string
      sql: ${TABLE}.super_bitte_wahle_die_kategorien_aus_fur_die_du_neue_produkte_vorschlagen_mochtest_ ;;
    }

    dimension: welche_produkte_oder_features_fehlen_dir_noch_ {
      type: string
      sql: ${TABLE}.welche_produkte_oder_features_fehlen_dir_noch_ ;;
    }

    set: detail {
      fields: [was_mochtest_du_uns_heute_mitteilen_, bitte_wahle_die_art_der_produkte_aus_die_du_vorschlagen_mochtest_, super_bitte_wahle_die_kategorien_aus_fur_die_du_neue_produkte_vorschlagen_mochtest_, welche_produkte_oder_features_fehlen_dir_noch_]
    }
  }
