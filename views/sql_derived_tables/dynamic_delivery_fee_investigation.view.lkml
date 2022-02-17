view: dynamic_delivery_fee_investigation {
  derived_table: {
    sql: with base_data_ios AS (
          SELECT anonymous_id
      , context_device_type as device_type
      , context_traits_city_name as city_name
      , hub_slug as hub
      , LEFT(hub_slug,2) as country_iso
      , CASE
              WHEN LEFT(hub_slug,2) IN ('de','nl') AND DATE(original_timestamp) < '2022-02-02' THEN 'Country Default'
              WHEN LEFT(hub_slug,2) IN ('fr') AND DATE(original_timestamp) < '2022-02-01' THEN 'Country Default'
              WHEN LEFT(hub_slug,2) = 'at' THEN 'Country Default'
              WHEN hub_slug  IN ('fr_par_brul','fr_par_cago','fr_par_cofi', 'fr_par_cope','fr_par_faur','fr_par_lepe','fr_par_quoi','de_aah_burt','de_aah_juel','de_aah_trie',
                              'de_aah_west','de_boc_zent','de_bon_ditr','de_bon_zent','de_bra_mich','de_brh_klus','de_che_kass','de_che_zent','de_dar_zent','de_dor_benn',
                              'de_dor_koer','de_drs_neus','de_drs_pies','de_drs_stre','de_dui_neud','de_dui_rhei','de_ess_alte','de_ess_hols','de_fre_stue','de_hei_zent',
                              'de_kai_inne','de_kar_zent','de_kas_vowe','de_kie_alma','de_kie_gaar','de_kre_inne','de_lei_eutr','de_lei_plag','de_man_inne','de_man_nied',
                              'de_maz_inne','de_mgl_zent','de_moe_zent','de_mul_zent','de_neu_alts','de_off_zent','de_pas_zent','de_pot_babe','de_rem_zent','de_wie_mitt',
                              'de_wup_barm','de_wup_elbe','de_zcj_zent','de_zcz_mitt','de_zoe_zent','de_zoy_alts','de_zpm_zent','at_wie_zwis','at_wie_oper','at_wie_sank',
                              'at_wie_meid','at_wie_neup','at_wie_hiet','at_wie_marg') THEN 'Country Default'
          WHEN hub_slug   IN ('nl_ams_diem','nl_ape_cent','nl_arn_oost','nl_bre_zuid','nl_dev_cent','nl_ens_cent','nl_zei_cent') THEN '2.9 under 15, free over 35'
          WHEN hub_slug   IN ('nl_alm_cent','nl_alm_buit','nl_ame_cent','nl_ams_buik','nl_ams_hout','nl_ams_neww','nl_ams_oost','nl_ams_oudw','nl_ams_wepa','nl_ams_zeeb',
                              'nl_ave_zuid','nl_bre_cent','nl_del_cent','nl_dha_cent','nl_dha_rijs','nl_dha_sche','nl_dha_zuid','nl_dor_cent','nl_ede_cent','nl_ein_oudw',
                              'nl_ein_west','nl_ein_woen','nl_ein_zuid','nl_gro_cent','nl_gro_noor','nl_haa_cent','nl_hen_cent','nl_hil_cent','nl_lee_cent','nl_maa_oost',
                              'nl_nij_cent','nl_roo_cent','nl_rot_croo','nl_rot_hill','nl_rot_oost','nl_rot_veer','nl_rot_west','nl_til_west','nl_til_zuid','nl_utr_cent',
                              'nl_utr_noor','nl_zoe_cent') THEN '3.9 under 10, free over 35'
          WHEN hub_slug   IN ('fr_par_asna','fr_par_bagn','fr_par_brun','fr_par_clib','fr_par_ivmh','fr_par_moli','fr_par_reau') THEN 'large order free over 45'
          WHEN hub_slug   IN ('de_ber_alex','de_ber_bism','de_ber_blis','de_ber_char','de_ber_dc01','de_ber_frie','de_ber_kope','de_ber_kreu','de_ber_mari','de_ber_mark',
                              'de_ber_mit1','de_ber_mit2','de_ber_moab','de_ber_neuk','de_ber_noll','de_ber_orde','de_ber_pren','de_ber_rumm','de_ber_temp','de_ber_tier',
                              'de_ber_ufhi','de_ber_wedd','de_ber_wedx','de_ber_weis','de_ber_wilm','de_ber_wins','de_ber_witt','de_cgn_ehre','de_cgn_inne','de_cgn_innx',
                              'de_cgn_kalk','de_cgn_lind','de_cgn_love','de_cgn_nipp','de_cgn_suds','de_dus_flin','de_dus_frie','de_dus_gerr','de_dus_kalk','de_dus_ober',
                              'de_dus_okas','de_dus_pemp','de_dus_suit','de_fra_alte','de_fra_bock','de_fra_gall','de_fra_inst','de_fra_nord','de_fra_sach','de_fue_zent',
                              'de_ham_alto','de_ham_bram','de_ham_eims','de_ham_eppe','de_ham_hohe','de_ham_horn','de_ham_neus','de_ham_otte','de_ham_rot2','de_ham_roth',
                              'de_ham_wand','de_ham_wint','de_muc_haid','de_muc_maxv','de_muc_milb','de_muc_nymp','de_muc_ober','de_muc_pasi','de_muc_schw','de_muc_send',
                              'de_muc_swan','de_muc_trud','de_muc_impl','de_nrm_joha','de_nrm_maxf','de_nrm_plar','de_nrm_suds','de_str_mitt','de_str_west') THEN 'small order 3.9 under 10'
      ELSE 'Country Default' END AS ddf_text
      , CASE
              WHEN LEFT(hub_slug,2) IN ('de','nl') AND DATE(original_timestamp) < '2022-02-02' THEN '1.80'
              WHEN LEFT(hub_slug,2) IN ('fr') AND DATE(original_timestamp) < '2022-02-01' THEN '1.80'
              WHEN LEFT(hub_slug,2) = 'at' THEN '2.80'
           WHEN hub_slug  IN ('fr_par_brul','fr_par_cago','fr_par_cofi', 'fr_par_cope','fr_par_faur','fr_par_lepe','fr_par_quoi','de_aah_burt','de_aah_juel','de_aah_trie',
                              'de_aah_west','de_boc_zent','de_bon_ditr','de_bon_zent','de_bra_mich','de_brh_klus','de_che_kass','de_che_zent','de_dar_zent','de_dor_benn',
                              'de_dor_koer','de_drs_neus','de_drs_pies','de_drs_stre','de_dui_neud','de_dui_rhei','de_ess_alte','de_ess_hols','de_fre_stue','de_hei_zent',
                              'de_kai_inne','de_kar_zent','de_kas_vowe','de_kie_alma','de_kie_gaar','de_kre_inne','de_lei_eutr','de_lei_plag','de_man_inne','de_man_nied',
                              'de_maz_inne','de_mgl_zent','de_moe_zent','de_mul_zent','de_neu_alts','de_off_zent','de_pas_zent','de_pot_babe','de_rem_zent','de_wie_mitt',
                              'de_wup_barm','de_wup_elbe','de_zcj_zent','de_zcz_mitt','de_zoe_zent','de_zoy_alts','de_zpm_zent','at_wie_zwis','at_wie_oper','at_wie_sank',
                              'at_wie_meid','at_wie_neup','at_wie_hiet','at_wie_marg') THEN '1.80'
          WHEN hub_slug   IN ('nl_ams_diem','nl_ape_cent','nl_arn_oost','nl_bre_zuid','nl_dev_cent','nl_ens_cent','nl_zei_cent') AND sub_total < 15 THEN '2.90'
          WHEN hub_slug   IN ('nl_ams_diem','nl_ape_cent','nl_arn_oost','nl_bre_zuid','nl_dev_cent','nl_ens_cent','nl_zei_cent') AND sub_total >= 35 THEN '0.00'
          WHEN hub_slug   IN ('nl_alm_cent','nl_alm_buit','nl_ame_cent','nl_ams_buik','nl_ams_hout','nl_ams_neww','nl_ams_oost','nl_ams_oudw','nl_ams_wepa','nl_ams_zeeb',
                              'nl_ave_zuid','nl_bre_cent','nl_del_cent','nl_dha_cent','nl_dha_rijs','nl_dha_sche','nl_dha_zuid','nl_dor_cent','nl_ede_cent','nl_ein_oudw',
                              'nl_ein_west','nl_ein_woen','nl_ein_zuid','nl_gro_cent','nl_gro_noor','nl_haa_cent','nl_hen_cent','nl_hil_cent','nl_lee_cent','nl_maa_oost',
                              'nl_nij_cent','nl_roo_cent','nl_rot_croo','nl_rot_hill','nl_rot_oost','nl_rot_veer','nl_rot_west','nl_til_west','nl_til_zuid','nl_utr_cent',
                              'nl_utr_noor','nl_zoe_cent') AND sub_total < 10 THEN '3.90'
          WHEN hub_slug   IN ('nl_alm_cent','nl_alm_buit','nl_ame_cent','nl_ams_buik','nl_ams_hout','nl_ams_neww','nl_ams_oost','nl_ams_oudw','nl_ams_wepa','nl_ams_zeeb',
                              'nl_ave_zuid','nl_bre_cent','nl_del_cent','nl_dha_cent','nl_dha_rijs','nl_dha_sche','nl_dha_zuid','nl_dor_cent','nl_ede_cent','nl_ein_oudw',
                              'nl_ein_west','nl_ein_woen','nl_ein_zuid','nl_gro_cent','nl_gro_noor','nl_haa_cent','nl_hen_cent','nl_hil_cent','nl_lee_cent','nl_maa_oost',
                              'nl_nij_cent','nl_roo_cent','nl_rot_croo','nl_rot_hill','nl_rot_oost','nl_rot_veer','nl_rot_west','nl_til_west','nl_til_zuid','nl_utr_cent',
                              'nl_utr_noor','nl_zoe_cent') AND sub_total > 35 THEN '0.00'
          WHEN hub_slug   IN ('fr_par_asna','fr_par_bagn','fr_par_brun','fr_par_clib','fr_par_ivmh','fr_par_moli','fr_par_reau') AND sub_total > 45 THEN '0.00'
          WHEN hub_slug   IN ('de_ber_alex','de_ber_bism','de_ber_blis','de_ber_char','de_ber_dc01','de_ber_frie','de_ber_kope','de_ber_kreu','de_ber_mari','de_ber_mark',
                              'de_ber_mit1','de_ber_mit2','de_ber_moab','de_ber_neuk','de_ber_noll','de_ber_orde','de_ber_pren','de_ber_rumm','de_ber_temp','de_ber_tier',
                              'de_ber_ufhi','de_ber_wedd','de_ber_wedx','de_ber_weis','de_ber_wilm','de_ber_wins','de_ber_witt','de_cgn_ehre','de_cgn_inne','de_cgn_innx',
                              'de_cgn_kalk','de_cgn_lind','de_cgn_love','de_cgn_nipp','de_cgn_suds','de_dus_flin','de_dus_frie','de_dus_gerr','de_dus_kalk','de_dus_ober',
                              'de_dus_okas','de_dus_pemp','de_dus_suit','de_fra_alte','de_fra_bock','de_fra_gall','de_fra_inst','de_fra_nord','de_fra_sach','de_fue_zent',
                              'de_ham_alto','de_ham_bram','de_ham_eims','de_ham_eppe','de_ham_hohe','de_ham_horn','de_ham_neus','de_ham_otte','de_ham_rot2','de_ham_roth',
                              'de_ham_wand','de_ham_wint','de_muc_haid','de_muc_maxv','de_muc_milb','de_muc_nymp','de_muc_ober','de_muc_pasi','de_muc_schw','de_muc_send',
                              'de_muc_swan','de_muc_trud','de_muc_impl','de_nrm_joha','de_nrm_maxf','de_nrm_plar','de_nrm_suds','de_str_mitt','de_str_west') AND sub_total < 10 THEN '3.90'
                              ELSE '1.80'
      END AS delivery_fee_value
      , event
      , sub_total
      , context_traits_user_logged_in
      , original_timestamp
      , DATE(original_timestamp) as date_
      , row_number() OVER(PARTITION BY anonymous_id, DATE(original_timestamp) , hub_slug ORDER BY original_timestamp ASC) as event_rank_asc
      FROM `flink-data-prod.flink_ios_production.cart_viewed`
      WHERE DATE(_PARTITIONTIME) BETWEEN "2022-01-25" AND '2022-02-15'
          AND sub_total IS NOT NULL and LEFT(hub_slug,2) != 'at'
      --and anonymous_id = '06A55A77-8D77-4324-83C4-97D7A5A29CD1'
       )

      , first_cart_viewed_ios as (

          SELECT *
          FROM base_data_ios
          where event_rank_asc = 1 )

      , last_cart_view_helper_ios as (
             SELECT anonymous_id
             , date_
             , hub
             , MAX(event_rank_asc) as last_hit
          FROM base_data_ios
          GROUP BY 1,2,3
      )

      , last_cart_viewed_ios as (
          SELECT  bd.anonymous_id
          , bd.country_iso
          , bd.ddf_text as ddf_text_last
          , bd.delivery_fee_value as delivery_fee_value_last
          , bd.sub_total as sub_total_last
          , bd.date_
          , bd.hub
          , last_hit
          FROM base_data_ios as bd
          INNER JOIN last_cart_view_helper_ios as helper ON bd.anonymous_id = helper.anonymous_id
                      AND bd.event_rank_asc = helper.last_hit
                      AND bd.date_ = helper.date_
                      AND bd.hub = helper.hub
      )

      , checkout_started_ios_helper as (
          SELECT
          anonymous_id
          , hub_slug
          , DATE(timestamp) as date_
          , left(hub_slug , 2 ) as country_iso
          , row_number() OVER(PARTITION BY anonymous_id, DATE(timestamp) , hub_slug ORDER BY original_timestamp ASC) as checkout_ranked
       FROM `flink-data-prod.flink_ios_production.checkout_started`
       WHERE DATE(_PARTITIONTIME) BETWEEN "2022-01-25" AND '2022-02-15'
      )

      , checkout_started_ios as (
          SELECT *
          FROM checkout_started_ios_helper
          where checkout_ranked = 1
      )

      , order_placed_helper_ios as (
          SELECT
          anonymous_id
          , hub_slug
          , delivery_fee
          , order_revenue
          , DATE(timestamp) as date_
          , voucher_value
          , order_number
          , left(hub_slug , 2 ) as country_iso
          , row_number() OVER(PARTITION BY anonymous_id , order_number, hub_slug ORDER BY original_timestamp ASC) as order_rank
      FROM `flink-data-prod.flink_ios_production.order_placed`
      WHERE DATE(_PARTITIONTIME) BETWEEN "2022-01-25" AND '2022-02-15'
      and anonymous_id = '02088E93-EA01-4555-8897-B2C131E58421'
      )


      , order_placed_clean_ios as (
          SELECT *
          FROM order_placed_helper_ios
          where order_rank = 1
      )

      , final_ios as (
      SELECT fi.anonymous_id
      , fi.device_type
      , fi.country_iso
      , fi.city_name
      , fi.hub
      , fi.date_
      , fi.ddf_text as ddf_text_first_hit
      , CAST(fi.delivery_fee_value as numeric) as delivery_fee_first_hit
      , fi.sub_total as sub_total_first_hit
      , CASE WHEN fi.sub_total < 10 THEN 'small order'
              WHEN fi.sub_total <  20 THEN 'medium order'
              ELSE 'large order' end as order_type_first
      , fi.event_rank_asc as first_hit
      , CAST (la.delivery_fee_value_last as numeric) as ddf_value_last
      , CASE WHEN  la.sub_total_last IS NULL THEN fi.sub_total ELSE la.sub_total_last END as sub_total_last
      , CASE WHEN la.last_hit IS NULL THEN fi.event_rank_asc ELSE la.last_hit end as last_hit
      , (CAST(la.sub_total_last as numeric) - CAST(fi.sub_total as numeric))  as difference_basket_value_first_to_last
      , CASE WHEN cs.anonymous_id IS NOT NULL THEN 1 ELSE 0 END as checkout_started
      , CASE WHEN op.anonymous_id IS NOT NULL THEN 1 ELSE 0 END AS order_placed
      , op.delivery_fee
      , op.order_revenue
      , op.voucher_value
      , CASE WHEN op.order_revenue != la.sub_total_last THEN op.order_revenue
          ELSE la.sub_total_last END AS order_value
      FROM  first_cart_viewed_ios as fi
      LEFT JOIN last_cart_viewed_ios as la ON fi.anonymous_id = la.anonymous_id AND fi.date_ = la.date_ AND fi.hub = la.hub
      LEFT JOIN checkout_started_ios as cs ON fi.anonymous_id = cs.anonymous_id AND fi.date_ = cs.date_ AND fi.hub = cs.hub_slug
      LEFT JOIN order_placed_clean_ios as op ON fi.anonymous_id = op.anonymous_id AND fi.date_ = op.date_ AND fi.hub = op.hub_slug
      ORDER BY date_ ASC
      )

      , base_data_android AS (
          SELECT anonymous_id
      , context_device_type as device_type
      , context_traits_city_name as city_name
      , hub_slug as hub
      , LEFT(hub_slug,2) as country_iso
      , CASE
              WHEN LEFT(hub_slug,2) IN ('de','nl') AND DATE(original_timestamp) < '2022-02-02' THEN 'Country Default'
              WHEN LEFT(hub_slug,2) IN ('fr') AND DATE(original_timestamp) < '2022-02-01' THEN 'Country Default'
              WHEN LEFT(hub_slug,2) = 'at' THEN 'Country Default'
              WHEN hub_slug  IN ('fr_par_brul','fr_par_cago','fr_par_cofi', 'fr_par_cope','fr_par_faur','fr_par_lepe','fr_par_quoi','de_aah_burt','de_aah_juel','de_aah_trie',
                              'de_aah_west','de_boc_zent','de_bon_ditr','de_bon_zent','de_bra_mich','de_brh_klus','de_che_kass','de_che_zent','de_dar_zent','de_dor_benn',
                              'de_dor_koer','de_drs_neus','de_drs_pies','de_drs_stre','de_dui_neud','de_dui_rhei','de_ess_alte','de_ess_hols','de_fre_stue','de_hei_zent',
                              'de_kai_inne','de_kar_zent','de_kas_vowe','de_kie_alma','de_kie_gaar','de_kre_inne','de_lei_eutr','de_lei_plag','de_man_inne','de_man_nied',
                              'de_maz_inne','de_mgl_zent','de_moe_zent','de_mul_zent','de_neu_alts','de_off_zent','de_pas_zent','de_pot_babe','de_rem_zent','de_wie_mitt',
                              'de_wup_barm','de_wup_elbe','de_zcj_zent','de_zcz_mitt','de_zoe_zent','de_zoy_alts','de_zpm_zent','at_wie_zwis','at_wie_oper','at_wie_sank',
                              'at_wie_meid','at_wie_neup','at_wie_hiet','at_wie_marg') THEN 'Country Default'
          WHEN hub_slug   IN ('nl_ams_diem','nl_ape_cent','nl_arn_oost','nl_bre_zuid','nl_dev_cent','nl_ens_cent','nl_zei_cent') THEN '2.9 under 15, free over 35'
          WHEN hub_slug   IN ('nl_alm_cent','nl_alm_buit','nl_ame_cent','nl_ams_buik','nl_ams_hout','nl_ams_neww','nl_ams_oost','nl_ams_oudw','nl_ams_wepa','nl_ams_zeeb',
                              'nl_ave_zuid','nl_bre_cent','nl_del_cent','nl_dha_cent','nl_dha_rijs','nl_dha_sche','nl_dha_zuid','nl_dor_cent','nl_ede_cent','nl_ein_oudw',
                              'nl_ein_west','nl_ein_woen','nl_ein_zuid','nl_gro_cent','nl_gro_noor','nl_haa_cent','nl_hen_cent','nl_hil_cent','nl_lee_cent','nl_maa_oost',
                              'nl_nij_cent','nl_roo_cent','nl_rot_croo','nl_rot_hill','nl_rot_oost','nl_rot_veer','nl_rot_west','nl_til_west','nl_til_zuid','nl_utr_cent',
                              'nl_utr_noor','nl_zoe_cent') THEN '3.9 under 10, free over 35'
          WHEN hub_slug   IN ('fr_par_asna','fr_par_bagn','fr_par_brun','fr_par_clib','fr_par_ivmh','fr_par_moli','fr_par_reau') THEN 'large order free over 45'
          WHEN hub_slug   IN ('de_ber_alex','de_ber_bism','de_ber_blis','de_ber_char','de_ber_dc01','de_ber_frie','de_ber_kope','de_ber_kreu','de_ber_mari','de_ber_mark',
                              'de_ber_mit1','de_ber_mit2','de_ber_moab','de_ber_neuk','de_ber_noll','de_ber_orde','de_ber_pren','de_ber_rumm','de_ber_temp','de_ber_tier',
                              'de_ber_ufhi','de_ber_wedd','de_ber_wedx','de_ber_weis','de_ber_wilm','de_ber_wins','de_ber_witt','de_cgn_ehre','de_cgn_inne','de_cgn_innx',
                              'de_cgn_kalk','de_cgn_lind','de_cgn_love','de_cgn_nipp','de_cgn_suds','de_dus_flin','de_dus_frie','de_dus_gerr','de_dus_kalk','de_dus_ober',
                              'de_dus_okas','de_dus_pemp','de_dus_suit','de_fra_alte','de_fra_bock','de_fra_gall','de_fra_inst','de_fra_nord','de_fra_sach','de_fue_zent',
                              'de_ham_alto','de_ham_bram','de_ham_eims','de_ham_eppe','de_ham_hohe','de_ham_horn','de_ham_neus','de_ham_otte','de_ham_rot2','de_ham_roth',
                              'de_ham_wand','de_ham_wint','de_muc_haid','de_muc_maxv','de_muc_milb','de_muc_nymp','de_muc_ober','de_muc_pasi','de_muc_schw','de_muc_send',
                              'de_muc_swan','de_muc_trud','de_muc_impl','de_nrm_joha','de_nrm_maxf','de_nrm_plar','de_nrm_suds','de_str_mitt','de_str_west') THEN 'small order 3.9 under 10'
      END AS ddf_text
      , CASE
              WHEN LEFT(hub_slug,2) IN ('de','nl') AND DATE(original_timestamp) < '2022-02-02' THEN '1.80'
              WHEN LEFT(hub_slug,2) IN ('fr') AND DATE(original_timestamp) < '2022-02-01' THEN '1.80'
              WHEN LEFT(hub_slug,2) = 'at' THEN '2.80'
           WHEN hub_slug  IN ('fr_par_brul','fr_par_cago','fr_par_cofi', 'fr_par_cope','fr_par_faur','fr_par_lepe','fr_par_quoi','de_aah_burt','de_aah_juel','de_aah_trie',
                              'de_aah_west','de_boc_zent','de_bon_ditr','de_bon_zent','de_bra_mich','de_brh_klus','de_che_kass','de_che_zent','de_dar_zent','de_dor_benn',
                              'de_dor_koer','de_drs_neus','de_drs_pies','de_drs_stre','de_dui_neud','de_dui_rhei','de_ess_alte','de_ess_hols','de_fre_stue','de_hei_zent',
                              'de_kai_inne','de_kar_zent','de_kas_vowe','de_kie_alma','de_kie_gaar','de_kre_inne','de_lei_eutr','de_lei_plag','de_man_inne','de_man_nied',
                              'de_maz_inne','de_mgl_zent','de_moe_zent','de_mul_zent','de_neu_alts','de_off_zent','de_pas_zent','de_pot_babe','de_rem_zent','de_wie_mitt',
                              'de_wup_barm','de_wup_elbe','de_zcj_zent','de_zcz_mitt','de_zoe_zent','de_zoy_alts','de_zpm_zent','at_wie_zwis','at_wie_oper','at_wie_sank',
                              'at_wie_meid','at_wie_neup','at_wie_hiet','at_wie_marg') THEN '1.80'
          WHEN hub_slug   IN ('nl_ams_diem','nl_ape_cent','nl_arn_oost','nl_bre_zuid','nl_dev_cent','nl_ens_cent','nl_zei_cent') AND subtotal < 15 THEN '2.90'
          WHEN hub_slug   IN ('nl_ams_diem','nl_ape_cent','nl_arn_oost','nl_bre_zuid','nl_dev_cent','nl_ens_cent','nl_zei_cent') AND subtotal >= 35 THEN '0.00'
          WHEN hub_slug   IN ('nl_alm_cent','nl_alm_buit','nl_ame_cent','nl_ams_buik','nl_ams_hout','nl_ams_neww','nl_ams_oost','nl_ams_oudw','nl_ams_wepa','nl_ams_zeeb',
                              'nl_ave_zuid','nl_bre_cent','nl_del_cent','nl_dha_cent','nl_dha_rijs','nl_dha_sche','nl_dha_zuid','nl_dor_cent','nl_ede_cent','nl_ein_oudw',
                              'nl_ein_west','nl_ein_woen','nl_ein_zuid','nl_gro_cent','nl_gro_noor','nl_haa_cent','nl_hen_cent','nl_hil_cent','nl_lee_cent','nl_maa_oost',
                              'nl_nij_cent','nl_roo_cent','nl_rot_croo','nl_rot_hill','nl_rot_oost','nl_rot_veer','nl_rot_west','nl_til_west','nl_til_zuid','nl_utr_cent',
                              'nl_utr_noor','nl_zoe_cent') AND subtotal < 10 THEN '3.90'
          WHEN hub_slug   IN ('nl_alm_cent','nl_alm_buit','nl_ame_cent','nl_ams_buik','nl_ams_hout','nl_ams_neww','nl_ams_oost','nl_ams_oudw','nl_ams_wepa','nl_ams_zeeb',
                              'nl_ave_zuid','nl_bre_cent','nl_del_cent','nl_dha_cent','nl_dha_rijs','nl_dha_sche','nl_dha_zuid','nl_dor_cent','nl_ede_cent','nl_ein_oudw',
                              'nl_ein_west','nl_ein_woen','nl_ein_zuid','nl_gro_cent','nl_gro_noor','nl_haa_cent','nl_hen_cent','nl_hil_cent','nl_lee_cent','nl_maa_oost',
                              'nl_nij_cent','nl_roo_cent','nl_rot_croo','nl_rot_hill','nl_rot_oost','nl_rot_veer','nl_rot_west','nl_til_west','nl_til_zuid','nl_utr_cent',
                              'nl_utr_noor','nl_zoe_cent') AND subtotal > 35 THEN '0.00'
          WHEN hub_slug   IN ('fr_par_asna','fr_par_bagn','fr_par_brun','fr_par_clib','fr_par_ivmh','fr_par_moli','fr_par_reau') AND subtotal > 45 THEN '0.00'
          WHEN hub_slug   IN ('de_ber_alex','de_ber_bism','de_ber_blis','de_ber_char','de_ber_dc01','de_ber_frie','de_ber_kope','de_ber_kreu','de_ber_mari','de_ber_mark',
                              'de_ber_mit1','de_ber_mit2','de_ber_moab','de_ber_neuk','de_ber_noll','de_ber_orde','de_ber_pren','de_ber_rumm','de_ber_temp','de_ber_tier',
                              'de_ber_ufhi','de_ber_wedd','de_ber_wedx','de_ber_weis','de_ber_wilm','de_ber_wins','de_ber_witt','de_cgn_ehre','de_cgn_inne','de_cgn_innx',
                              'de_cgn_kalk','de_cgn_lind','de_cgn_love','de_cgn_nipp','de_cgn_suds','de_dus_flin','de_dus_frie','de_dus_gerr','de_dus_kalk','de_dus_ober',
                              'de_dus_okas','de_dus_pemp','de_dus_suit','de_fra_alte','de_fra_bock','de_fra_gall','de_fra_inst','de_fra_nord','de_fra_sach','de_fue_zent',
                              'de_ham_alto','de_ham_bram','de_ham_eims','de_ham_eppe','de_ham_hohe','de_ham_horn','de_ham_neus','de_ham_otte','de_ham_rot2','de_ham_roth',
                              'de_ham_wand','de_ham_wint','de_muc_haid','de_muc_maxv','de_muc_milb','de_muc_nymp','de_muc_ober','de_muc_pasi','de_muc_schw','de_muc_send',
                              'de_muc_swan','de_muc_trud','de_muc_impl','de_nrm_joha','de_nrm_maxf','de_nrm_plar','de_nrm_suds','de_str_mitt','de_str_west') AND subtotal < 10 THEN '3.90'
                              ELSE '1.80'
      END AS delivery_fee_value
      , event
      , subtotal as sub_total
      , context_traits_user_logged_in
      , original_timestamp
      , DATE(original_timestamp) as date_
      , row_number() OVER(PARTITION BY anonymous_id, DATE(original_timestamp) , hub_slug ORDER BY original_timestamp ASC) as event_rank_asc
      FROM `flink-data-prod.flink_android_production.cart_viewed`
      WHERE DATE(_PARTITIONTIME) BETWEEN "2022-01-25" AND '2022-02-15'
          AND subtotal IS NOT NULL and LEFT(hub_slug,2) != 'at'
          --and anonymous_id = '04c52131-04bc-444c-bfbe-227fcaa137f0'
       )

      , first_cart_viewed_android as (

          SELECT *
          FROM base_data_android
          where event_rank_asc = 1
          )

      , last_cart_view_helper_android as (
             SELECT anonymous_id
             , date_
             , hub
             , MAX(event_rank_asc) as last_hit
          FROM base_data_android
          GROUP BY 1,2,3
      )

      , last_cart_viewed_android as (
          SELECT  bd.anonymous_id
          , bd.country_iso
          , bd.ddf_text as ddf_text_last
          , bd.delivery_fee_value as delivery_fee_value_last
          , bd.sub_total as sub_total_last
          , bd.date_
          , bd.hub
          , helper.last_hit
          FROM base_data_android as bd
          INNER JOIN last_cart_view_helper_android as helper ON bd.anonymous_id = helper.anonymous_id
              AND bd.event_rank_asc = helper.last_hit
              AND bd.date_ = helper.date_
              AND bd.hub = helper.hub
      )


      ,  checkout_started_android_helper as (
          SELECT
          anonymous_id
          , hub_slug
          , DATE(timestamp) as date_
          , left(hub_slug , 2 ) as country_iso
          , row_number() OVER(PARTITION BY anonymous_id , DATE(timestamp), hub_slug ORDER BY original_timestamp ASC) as checkout_ranked
       FROM `flink-data-prod.flink_android_production.checkout_started`
       WHERE DATE(_PARTITIONTIME) BETWEEN "2022-01-25" AND '2022-02-15'
       --and anonymous_id = '04c52131-04bc-444c-bfbe-227fcaa137f0'
      )

      , checkout_started_android as (
          SELECT *
          FROM checkout_started_android_helper
          where checkout_ranked = 1
          )

      , order_placed_helper_android as (
          SELECT anonymous_id
          , hub_slug
          , delivery_fee
          , order_revenue
          , DATE(timestamp) as date_
          , voucher_value
          , order_number
          , left(hub_slug , 2 ) as country_iso
          , row_number() OVER(PARTITION BY anonymous_id , order_number , hub_slug ORDER BY original_timestamp ASC) as order_rank
      FROM `flink-data-prod.flink_android_production.order_placed`
      WHERE DATE(_PARTITIONTIME) BETWEEN "2022-01-25" AND '2022-02-15'

      )


      , order_placed_clean_android as (
          SELECT *
          FROM order_placed_helper_android
          where order_rank = 1
      )

      , final_android as (
      SELECT fi.anonymous_id
      , fi.device_type
      , fi.country_iso
      , fi.city_name
      , fi.hub
      , fi.date_
      , fi.ddf_text as ddf_text_first_hit
      , CAST(fi.delivery_fee_value as numeric) as delivery_fee_first_hit
      , fi.sub_total as sub_total_first_hit
      , CASE WHEN fi.sub_total < 10 THEN 'small order'
              WHEN fi.sub_total <  20 THEN 'medium order'
              ELSE 'large order' end as order_type_first
      , fi.event_rank_asc as first_hit
      , CAST( la.delivery_fee_value_last  as numeric) as ddf_value_last
      , CASE WHEN  la.sub_total_last IS NULL THEN fi.sub_total ELSE la.sub_total_last END as sub_total_last
      , CASE WHEN la.last_hit IS NULL THEN fi.event_rank_asc ELSE la.last_hit end as last_hit
      , (CAST(la.sub_total_last as numeric) - CAST(fi.sub_total as numeric))  as difference_basket_value_first_to_last
      , CASE WHEN cs.anonymous_id IS NOT NULL THEN 1 ELSE 0 END as checkout_started
      , CASE WHEN op.anonymous_id IS NOT NULL THEN 1 ELSE 0 END AS order_placed
      , op.delivery_fee
      , op.order_revenue
      , op.voucher_value
      , CASE WHEN op.order_revenue != la.sub_total_last THEN op.order_revenue
          ELSE la.sub_total_last END AS order_value
      FROM  first_cart_viewed_android as fi
      LEFT JOIN last_cart_viewed_android as la ON fi.anonymous_id = la.anonymous_id AND fi.date_ = la.date_ AND fi.hub = la.hub
      LEFT JOIN checkout_started_android as cs ON fi.anonymous_id = cs.anonymous_id AND fi.date_ = cs.date_ AND fi.hub = cs.hub_slug
      LEFT JOIN order_placed_clean_android as op ON fi.anonymous_id = op.anonymous_id AND fi.date_ = op.date_ AND fi.hub = op.hub_slug
      )

      , merge_data as (
      SELECT *
      FROM final_ios

      UNION ALL
      (
      SELECT *
      FROM final_android )
      )

      , merging as (
      SELECT *
      , CASE
      WHEN date_ < '2022-02-01' AND country_iso = 'fr' THEN 'old_df'
      WHEN date_ < '2022-02-02' AND country_iso IN ('de','nl') THEN 'old_df'
      ELSE 'new-ddf' END AS time_cohort
      , CASE
              WHEN first_hit IS NOT NULL AND checkout_started = 0 THEN 'abandonment_checkout'
              WHEN first_hit IS NOT NULL AND checkout_started = 1 AND order_placed = 0 THEN 'abandonment_payment'
              WHEN sub_total_last > sub_total_first_hit AND checkout_started = 0 THEN 'product_added_abandonment'
              WHEN order_revenue > sub_total_first_hit AND delivery_fee_first_hit > delivery_fee AND order_placed =1 THEN 'product_added_transacted'
              WHEN order_revenue > sub_total_first_hit AND delivery_fee_first_hit = delivery_fee AND order_placed =1 THEN 'product_added_transacted'
              WHEN order_placed = 1 THEN 'transacted'
              WHEN delivery_fee_first_hit > delivery_fee AND order_placed =1 THEN 'product_added_transacted'
      ELSE 'other' END as behaviour_type
      FROM merge_data
       )

      SELECT * FROM merging
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: anonymous_id {
    type: string
    primary_key: yes
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: device_type {
    type: string
    sql: ${TABLE}.device_type ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: city_name {
    type: string
    sql: ${TABLE}.city_name ;;
  }

  dimension: hub {
    type: string
    sql: ${TABLE}.hub ;;
  }

  dimension: date_ {
    type: date
    datatype: date
    sql: ${TABLE}.date_ ;;
  }

  dimension: ddf_text_first_hit {
    type: string
    sql: ${TABLE}.ddf_text_first_hit ;;
  }

  dimension: delivery_fee_first_hit {
    type: number
    sql: ${TABLE}.delivery_fee_first_hit ;;
  }

  dimension: sub_total_first_hit {
    type: number
    sql: ${TABLE}.sub_total_first_hit ;;
  }

  dimension: order_type_first {
    type: string
    sql: ${TABLE}.order_type_first ;;
  }

  measure: first_hit {
    type: sum
    sql: ${TABLE}.first_hit ;;
  }

  dimension: ddf_value_last {
    type: number
    sql: ${TABLE}.ddf_value_last ;;
  }

  dimension: sub_total_last {
    type: number
    sql: ${TABLE}.sub_total_last ;;
  }

  dimension: last_hit {
    type: number
    sql: ${TABLE}.last_hit ;;
  }

  dimension: difference_basket_value_first_to_last {
    type: number
    sql: ${TABLE}.difference_basket_value_first_to_last ;;
  }

  measure: checkout_started {
    type: sum
    sql: ${TABLE}.checkout_started ;;
  }

  measure: order_placed {
    type: sum
    sql: ${TABLE}.order_placed ;;
  }

  dimension: delivery_fee {
    type: number
    sql: ${TABLE}.delivery_fee ;;
  }

  dimension: order_revenue {
    type: number
    sql: ${TABLE}.order_revenue ;;
  }

  dimension: voucher_value {
    type: number
    sql: ${TABLE}.voucher_value ;;
  }

  dimension: order_value {
    type: number
    sql: ${TABLE}.order_value ;;
  }

  dimension: time_cohort {
    type: string
    sql: ${TABLE}.time_cohort ;;
  }

  dimension: behaviour_type {
    type: string
    sql: ${TABLE}.behaviour_type ;;
  }

  set: detail {
    fields: [
      anonymous_id,
      device_type,
      country_iso,
      city_name,
      hub,
      date_,
      ddf_text_first_hit,
      delivery_fee_first_hit,
      sub_total_first_hit,
      order_type_first,
      first_hit,
      ddf_value_last,
      sub_total_last,
      last_hit,
      difference_basket_value_first_to_last,
      checkout_started,
      order_placed,
      delivery_fee,
      order_revenue,
      voucher_value,
      order_value,
      time_cohort,
      behaviour_type
    ]
  }
}
