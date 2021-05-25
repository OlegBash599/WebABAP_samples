CLASS zcl_wa003_var_item_feed DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES zif_wa003_entity_feeder.
    ALIASES mo_odata_in FOR zif_wa003_entity_feeder~mo_odata_in.
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES: BEGIN OF ts_sel_opt
                , var_name_rng TYPE RANGE OF zswa003_var_val2_srv-var_name
                , var_low_value TYPE RANGE OF zswa003_var_val2_srv-low
           , END OF ts_sel_opt
           .

    TYPES: ts_entry TYPE zcl_zweb_abap_demo3_mpc=>ts_vari.
    TYPES: tt_entry TYPE STANDARD TABLE OF zcl_zweb_abap_demo3_mpc=>ts_vari WITH DEFAULT KEY.

    DATA ms_sel_opt TYPE ts_sel_opt.
    DATA ms_entry_in TYPE ts_entry.

    METHODS fill_from_odata_filters
      RAISING /iwbep/cx_mgw_tech_exception.

    METHODS fill_var_item_set
      CHANGING ct_var_item_set TYPE tt_entry
      RAISING  /iwbep/cx_mgw_tech_exception.


    METHODS odata2range
      CHANGING ct_property_rng TYPE zcl_wa003_odata2range=>tt_property_rng
      RAISING  /iwbep/cx_mgw_tech_exception.

    METHODS raise_exception2odata
      IMPORTING iv_msg TYPE bapi_msg OPTIONAL
      RAISING   /iwbep/cx_mgw_busi_exception.

    METHODS if_record_exist
      IMPORTING is_entry_in   TYPE ts_entry
      RETURNING VALUE(rv_val) TYPE abap_bool.

    METHODS save2db
      IMPORTING !it_varval_tab TYPE ztwa001_varval_tab.

ENDCLASS.



CLASS zcl_wa003_var_item_feed IMPLEMENTATION.
  METHOD zif_wa003_entity_feeder~c.
    DATA lv_msg_bapi TYPE bapi_msg.
    CLEAR ms_entry_in.

    mo_odata_in->get_data_provider( )->read_entry_data( IMPORTING es_data = ms_entry_in ).

    "" проверка, что запись не существует
    IF if_record_exist( ms_entry_in ) EQ abap_true.
      "MESSAGE x000(cl) WITH 'Entry exists'.
      MESSAGE s000(cl) WITH 'Entry exist' 'Not for creation' INTO lv_msg_bapi.
      raise_exception2odata( lv_msg_bapi ).
    ENDIF.


    """"""""""""""""""""""""""""""""""""""""
    DATA lt_var_val4db TYPE ztwa001_varval_tab.
    FIELD-SYMBOLS <fs_var_val> TYPE ztwa001_varval.

    GET TIME.
    APPEND INITIAL LINE TO lt_var_val4db ASSIGNING <fs_var_val>.
    MOVE-CORRESPONDING ms_entry_in TO <fs_var_val>.


    save2db( lt_var_val4db ).

    MOVE-CORRESPONDING ms_entry_in TO es.

  ENDMETHOD.

  METHOD zif_wa003_entity_feeder~r.

    DATA lt_key_tab TYPE /iwbep/t_mgw_name_value_pair.
    DATA lr_name_value_line TYPE REF TO /iwbep/s_mgw_name_value_pair.

    DATA lt_entry_tab TYPE tt_entry.
    DATA ls_entry_out TYPE ts_entry.
    DATA lt_var_val TYPE ztwa001_varval_tab.


    FIELD-SYMBOLS <fs_var_id> TYPE ztwa001_varid.
    FIELD-SYMBOLS <fs_var_list> TYPE zswa001_variable_alv.

    lt_key_tab = mo_odata_in->get_key_tab(  ).

    CLEAR ms_entry_in.
    LOOP AT lt_key_tab REFERENCE INTO lr_name_value_line.
      CASE lr_name_value_line->name.
        WHEN 'VarName'.
          ms_entry_in-var_name = lr_name_value_line->value.
        WHEN 'VarNumb'.
          ms_entry_in-var_numb = lr_name_value_line->value.
        WHEN OTHERS.

      ENDCASE.
    ENDLOOP.

    SELECT * FROM ztwa001_varval
        INTO CORRESPONDING FIELDS OF TABLE lt_var_val
        WHERE var_name = ms_entry_in-var_name
         AND  var_numb = ms_entry_in-var_numb
          .

    MOVE-CORRESPONDING VALUE #( lt_var_val[ 1 ] OPTIONAL ) TO es .

  ENDMETHOD.

  METHOD zif_wa003_entity_feeder~u.
    DATA lv_msg_bapi TYPE bapi_msg.
    CLEAR ms_entry_in.

    mo_odata_in->get_data_provider( )->read_entry_data( IMPORTING es_data = ms_entry_in ).

    "" проверка, что запись не существует
    IF if_record_exist( ms_entry_in ) EQ abap_false.
      "MESSAGE x000(cl) WITH 'Entry exists'.
      MESSAGE s000(cl) WITH 'Entry DOES not exist' 'Not for updation' INTO lv_msg_bapi.
      raise_exception2odata( lv_msg_bapi ).
    ENDIF.

    """"""""""""""""""""""""""""""""""""""""
    DATA lt_var_val4db TYPE ztwa001_varval_tab.
    FIELD-SYMBOLS <fs_var_val> TYPE ztwa001_varval.

    GET TIME.
    APPEND INITIAL LINE TO lt_var_val4db ASSIGNING <fs_var_val>.
    MOVE-CORRESPONDING ms_entry_in TO <fs_var_val>.

    save2db( lt_var_val4db ).

    MOVE-CORRESPONDING ms_entry_in TO es.
  ENDMETHOD.

  METHOD zif_wa003_entity_feeder~d.
    DATA lt_key_tab TYPE /iwbep/t_mgw_name_value_pair.
    DATA lr_name_value_line TYPE REF TO /iwbep/s_mgw_name_value_pair.

    DATA lv_msg_bapi TYPE bapi_msg.
    CLEAR ms_entry_in.

    lt_key_tab = mo_odata_in->get_key_tab(  ).

    LOOP AT lt_key_tab REFERENCE INTO lr_name_value_line.
      CASE lr_name_value_line->name.
        WHEN 'VarName'.
          ms_entry_in-var_name = lr_name_value_line->value.
        WHEN 'VarNumb'.
          ms_entry_in-var_numb = lr_name_value_line->value.
        WHEN OTHERS.

      ENDCASE.
    ENDLOOP.

    "" проверка, что запись не существует
    IF if_record_exist( ms_entry_in ) EQ abap_false.
      "MESSAGE x000(cl) WITH 'Entry exists'.
      MESSAGE s000(cl) WITH 'Entry DOES not exist' 'Not for deletion' INTO lv_msg_bapi.
      raise_exception2odata( lv_msg_bapi ).
    ELSE.

    ENDIF.


    """"""""""""""""""""""""""""""""""""""""

    FIELD-SYMBOLS <fs_var_val> TYPE ztwa001_varval.
    DATA lt_var_val4db TYPE ztwa001_varval_tab.
    SELECT * FROM ztwa001_varval
      INTO TABLE lt_var_val4db
      WHERE var_name = ms_entry_in-var_name
      AND var_numb = ms_entry_in-var_numb.

    GET TIME.

    LOOP AT lt_var_val4db ASSIGNING <fs_var_val>.
      <fs_var_val>-sign = 'E'.
    ENDLOOP.

    save2db( lt_var_val4db ).
  ENDMETHOD.

  METHOD zif_wa003_entity_feeder~q.
    DATA lt_var_head_set TYPE zcl_zweb_abap_demo3_mpc=>tt_vari.
    fill_from_odata_filters(  ).
    fill_var_item_set( CHANGING ct_var_item_set = lt_var_head_set ).
    et_set[] =  lt_var_head_set[].
  ENDMETHOD.

  METHOD fill_var_item_set.
*      CHANGING ct_var_item_set TYPE tt_entry
*      RAISING  /iwbep/cx_mgw_tech_exception.

    DATA lt_var_val TYPE ztwa001_varval_tab.
    DATA lt_key_tab TYPE /iwbep/t_mgw_name_value_pair.

    CASE mo_odata_in->mv_source_name.
      WHEN 'VarH'.
        DATA ls_var_val_in TYPE ztwa001_varval.
        DATA lr_name_value_line TYPE REF TO /iwbep/s_mgw_name_value_pair.

        lt_key_tab = mo_odata_in->get_key_tab( ).
        LOOP AT lt_key_tab REFERENCE INTO lr_name_value_line.
          CASE lr_name_value_line->name.
            WHEN 'Name'.
              ls_var_val_in-var_name = lr_name_value_line->value.
            WHEN OTHERS.

          ENDCASE.
        ENDLOOP.

        SELECT * FROM ztwa001_varval
          INTO TABLE lt_var_val
          WHERE var_name = ls_var_val_in-var_name
          ORDER BY PRIMARY KEY
          .
      WHEN OTHERS.
        SELECT * FROM ztwa001_varval
            INTO TABLE lt_var_val
            WHERE   var_name IN ms_sel_opt-var_name_rng
               AND  low IN ms_sel_opt-var_low_value.
    ENDCASE.



    " ct_var_item_set[] = lt_var_val[].
    MOVE-CORRESPONDING lt_var_val[] TO ct_var_item_set[].
  ENDMETHOD.

  METHOD fill_from_odata_filters.
    DATA lt_property_rng TYPE zcl_wa003_odata2range=>tt_property_rng.
    FIELD-SYMBOLS <fs_property_rng> TYPE zcl_wa003_odata2range=>ts_property_rng.
    "CLEAR ms_sel_opt.

    APPEND INITIAL LINE TO lt_property_rng ASSIGNING <fs_property_rng>.
    <fs_property_rng>-prop_in = 'VAR_NAME'.
    GET REFERENCE OF ms_sel_opt-var_name_rng INTO <fs_property_rng>-range.

    APPEND INITIAL LINE TO lt_property_rng ASSIGNING <fs_property_rng>.
    <fs_property_rng>-prop_in = 'LOW'.
    GET REFERENCE OF ms_sel_opt-var_low_value INTO <fs_property_rng>-range.

    me->odata2range( CHANGING ct_property_rng = lt_property_rng  ).

  ENDMETHOD.

  METHOD odata2range.
    "changing ct_property_rng type zcl_wa003_odata2range=>tt_property_rng.
    DATA lo_odata2range TYPE REF TO zcl_wa003_odata2range.
    lo_odata2range = NEW #(  ).
    lo_odata2range->set_odata_in( io_odata_in = mo_odata_in ).
    lo_odata2range->filter2sel_opt( CHANGING ct_property_rng = ct_property_rng  ).

  ENDMETHOD.

  METHOD zif_wa003_entity_feeder~set_batch_tab.

  ENDMETHOD.

  METHOD zif_wa003_entity_feeder~set_odata_in.
    mo_odata_in ?= io_odata_in.
  ENDMETHOD.

  METHOD raise_exception2odata.
*      IMPORTING IV_MSG TYPE BAPI_MSG
*      RAISING /iwbep/cx_mgw_busi_exception.
    DATA lo_message_container TYPE REF TO /iwbep/if_message_container.

    lo_message_container ?=
      mo_odata_in->get_context( )->get_message_container( ).

    lo_message_container->add_message(
      EXPORTING
        iv_msg_type               = sy-msgty
        iv_msg_id                 = sy-msgid
        iv_msg_number             = sy-msgno
        iv_msg_text               = iv_msg
        iv_msg_v1                 = sy-msgv1
        iv_msg_v2                 = sy-msgv2
        iv_msg_v3                 = sy-msgv3
        iv_msg_v4                 = sy-msgv4
    ).

    RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
      EXPORTING
*       textid            =
*       previous          =
        message_container = lo_message_container
        http_status_code  = /iwbep/cx_mgw_busi_exception=>gcs_http_status_codes-not_acceptable
*       http_header_parameters =
*       sap_note_id       =
*       msg_code          =
*       entity_type       =
*       message           =
*       message_unlimited =
*       filter_param      =
*       operation_no      =
      .
  ENDMETHOD.

  METHOD if_record_exist.
*      IMPORTING is_entry_in TYPE ts_entry
*      RETURNING VALUE(rv_val) TYPE abap_bool.
    DATA lt_var_val TYPE ztwa001_varval_tab.

    SELECT * FROM ztwa001_varval
       INTO TABLE lt_var_val
       WHERE var_name = ms_entry_in-var_name.
    IF sy-subrc EQ 0.
      rv_val = abap_true.
    ELSE.
      rv_val = abap_false.
    ENDIF.
  ENDMETHOD.

  METHOD save2db.
    "      IMPORTING !it_varid_tab TYPE ztwa001_varid_tab.
    DATA lt_var_val4db TYPE ztwa001_varval_tab.
    DATA lo_save_var_n_range TYPE REF TO zcl_wa001_save_var_n_rng.

    lo_save_var_n_range = NEW #(  ).

    DATA lv_commit_or_not_commit TYPE abap_bool.
    IF mo_odata_in->mv_batch_changeset_mode EQ abap_true.
      lv_commit_or_not_commit = abap_false.
    ELSE.
      lv_commit_or_not_commit = abap_true.
    ENDIF.

    lo_save_var_n_range->save_vals(  EXPORTING it_varval = it_varval_tab
                                               iv_do_commit = lv_commit_or_not_commit ).

  ENDMETHOD.

ENDCLASS.
