CLASS zcl_wa003_var_head_feed DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES zif_wa003_entity_feeder.
    ALIASES mo_odata_in FOR zif_wa003_entity_feeder~mo_odata_in.
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES: BEGIN OF ts_sel_opt
                , var_type_rng TYPE RANGE OF ztwa001_varid-var_type
                , var_desc_range TYPE RANGE OF ztwa001_varid-var_desc
                , num_of_files_range TYPE RANGE OF zswa003_var_h2_srv-num_of_files
           , END OF ts_sel_opt
           .

    TYPES: ts_entry TYPE zcl_zweb_abap_demo3_mpc=>ts_varh.
    TYPES: tt_entry TYPE STANDARD TABLE OF zcl_zweb_abap_demo3_mpc=>ts_varh WITH DEFAULT KEY.

    DATA ms_sel_opt TYPE ts_sel_opt.
    DATA ms_entry_in TYPE ts_entry.

    METHODS fill_from_odata_filters
      RAISING /iwbep/cx_mgw_tech_exception.

    METHODS fill_var_head_set
      CHANGING ct_var_head_set TYPE tt_entry
      RAISING  /iwbep/cx_mgw_tech_exception.

    METHODS fill_stat_by_head
      IMPORTING it_var_id       TYPE ztwa001_varid_tab
      CHANGING  ct_var_head_set TYPE tt_entry.

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
      IMPORTING !it_varid_tab TYPE ztwa001_varid_tab.

ENDCLASS.



CLASS ZCL_WA003_VAR_HEAD_FEED IMPLEMENTATION.


  METHOD fill_from_odata_filters.

*    DATA lo_odata_req_filter TYPE REF TO /iwbep/if_mgw_req_filter.
*    DATA lo_select_option_list TYPE /iwbep/t_mgw_select_option.
*
*    FIELD-SYMBOLS <fs_select_option> TYPE /iwbep/s_mgw_select_option.
*
*    CLEAR ms_sel_opt.
*
*    lo_odata_req_filter ?= mo_odata_in->get_tech_context_q( )->get_filter( ).
*    lo_select_option_list = lo_odata_req_filter->get_filter_select_options( ).
*    LOOP AT lo_select_option_list ASSIGNING <fs_select_option>.
*
*      CASE <fs_select_option>-property.
*        WHEN 'VarType' OR 'VAR_TYPE'.
*          lo_odata_req_filter->convert_select_option(
*                    EXPORTING is_select_option = <fs_select_option>
*                    IMPORTING et_select_option = ms_sel_opt-var_type_rng ).
*
*        WHEN OTHERS.
*
*      ENDCASE.
*    ENDLOOP.

    DATA lt_property_rng TYPE zcl_wa003_odata2range=>tt_property_rng.
    FIELD-SYMBOLS <fs_property_rng> TYPE zcl_wa003_odata2range=>ts_property_rng.
    "CLEAR ms_sel_opt.

    APPEND INITIAL LINE TO lt_property_rng ASSIGNING <fs_property_rng>.
    <fs_property_rng>-prop_in = 'VAR_TYPE'.
    GET REFERENCE OF ms_sel_opt-var_type_rng INTO <fs_property_rng>-range.

    APPEND INITIAL LINE TO lt_property_rng ASSIGNING <fs_property_rng>.
    <fs_property_rng>-prop_in = 'NUM_OF_FILES'.
    GET REFERENCE OF ms_sel_opt-num_of_files_range INTO <fs_property_rng>-range.

    me->odata2range( CHANGING ct_property_rng = lt_property_rng  ).

  ENDMETHOD.


  METHOD fill_stat_by_head.
*        IMPORTING it_var_id type ztwa001_varid_tab
*        CHANGING ct_var_head_set TYPE tt_entry.
    DATA lt_var_val TYPE ztwa001_varval_tab.
    DATA lt_var_file TYPE ztwa001_varfile_tab.

    FIELD-SYMBOLS <fs_var_id> TYPE ztwa001_varid.
    FIELD-SYMBOLS <fs_var_set> TYPE ts_entry.

    IF it_var_id IS NOT INITIAL.
      SELECT * FROM ztwa001_varval
         INTO TABLE lt_var_val
         FOR ALL ENTRIES IN it_var_id
         WHERE  var_name EQ it_var_id-var_name
         .

      SELECT * FROM ztwa001_varfile
        INTO TABLE lt_var_file
        FOR ALL ENTRIES IN it_var_id
         WHERE  var_name EQ it_var_id-var_name
         .
    ENDIF.


    CLEAR ct_var_head_set.

    LOOP AT it_var_id ASSIGNING <fs_var_id>.
      APPEND INITIAL LINE TO ct_var_head_set ASSIGNING <fs_var_set>.
      MOVE-CORRESPONDING <fs_var_id> TO <fs_var_set>.

      <fs_var_set>-name = <fs_var_id>-var_name.
      <fs_var_set>-description = <fs_var_id>-var_desc.
      <fs_var_set>-var_type = <fs_var_id>-var_type.
      <fs_var_set>-var_type_tx = SWITCH #( <fs_var_set>-var_type
                                        WHEN '1' THEN 'Separate Value'
                                        WHEN '2' THEN 'Switch'
                                        WHEN '3' THEN 'Range'
                                        WHEN '4' THEN 'SpecialRange'
                                        ELSE 'No description' ).


      <fs_var_set>-is_del = <fs_var_id>-is_del.
      <fs_var_set>-debug_is_on = <fs_var_id>-is_debug_on.
      <fs_var_set>-fast_val = <fs_var_id>-fast_val.
      <fs_var_set>-cru = <fs_var_id>-cru.
      <fs_var_set>-crd = <fs_var_id>-crd.
      <fs_var_set>-crt = <fs_var_id>-crt.
      <fs_var_set>-chu = <fs_var_id>-chu.
      <fs_var_set>-chd = <fs_var_id>-chd.
      <fs_var_set>-cht = <fs_var_id>-cht.

      <fs_var_set>-num_of_values = REDUCE i( INIT vals_in_var = 0
                                              FOR ls_var_val IN lt_var_val WHERE ( var_name = <fs_var_id>-var_name )
                                              NEXT vals_in_var = vals_in_var + 1 ).

      <fs_var_set>-num_of_files = REDUCE i( INIT files_in_var = 0
                                              FOR ls_var_file IN lt_var_file WHERE ( var_name = <fs_var_id>-var_name )
                                              NEXT files_in_var = files_in_var + 1 ).
    ENDLOOP.


  ENDMETHOD.


  METHOD fill_var_head_set.
*      changing ct_var_head_set TYPE zcl_zweb_abap_demo3_mpc=>tt_varh
*      RAISING /iwbep/cx_mgw_tech_exception.

    DATA lt_var_id TYPE ztwa001_varid_tab.

    SELECT * FROM ztwa001_varid
      INTO TABLE lt_var_id
      WHERE
          var_type IN ms_sel_opt-var_type_rng
         AND
         var_desc IN ms_sel_opt-var_desc_range
      .

    fill_stat_by_head( EXPORTING it_var_id = lt_var_id
                       CHANGING ct_var_head_set = ct_var_head_set ).


    IF ms_sel_opt-num_of_files_range[] IS NOT INITIAL.
      DELETE ct_var_head_set WHERE num_of_files NOT IN ms_sel_opt-num_of_files_range[].
    ELSE.
      CLEAR lt_var_id. " see coverage
    ENDIF.
    " https://help.sap.com/docs/SAP_NETWEAVER_AS_ABAP_FOR_SOH_740/
    " ba879a6e2ea04d9bb94c7ccd7cdac446/7f27a2638ee64d1d97dd53c69c562e7b.html?version=7.40.19
  ENDMETHOD.


  METHOD if_record_exist.
*      IMPORTING is_entry_in TYPE ts_entry
*      RETURNING VALUE(rv_val) TYPE abap_bool.
    DATA lt_var_id TYPE ztwa001_varid_tab.

    SELECT * FROM ztwa001_varid
       INTO TABLE lt_var_id
       WHERE var_name = ms_entry_in-name
        and is_del = abap_false .
    IF sy-subrc EQ 0.
      rv_val = abap_true.
    ELSE.
      rv_val = abap_false.
    ENDIF.
  ENDMETHOD.


  METHOD odata2range.
    "changing ct_property_rng type zcl_wa003_odata2range=>tt_property_rng.
    DATA lo_odata2range TYPE REF TO zcl_wa003_odata2range.
    lo_odata2range = NEW #(  ).
    lo_odata2range->set_odata_in( io_odata_in = mo_odata_in ).
    lo_odata2range->filter2sel_opt( CHANGING ct_property_rng = ct_property_rng  ).

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

    lo_save_var_n_range->sh(  EXPORTING it_varid =  it_varid_tab
                                        it_varval = lt_var_val4db
                                        iv_do_commit = lv_commit_or_not_commit ).

  ENDMETHOD.


  METHOD zif_wa003_entity_feeder~c.
    DATA lv_msg_bapi TYPE bapi_msg.
    CLEAR ms_entry_in.

    mo_odata_in->get_data_provider( )->read_entry_data( IMPORTING es_data = ms_entry_in ).

    "" проверка, что запись не существует
    IF if_record_exist( ms_entry_in ) EQ abap_true.
      "MESSAGE x000(cl) WITH 'Entry exists'.
      MESSAGE e000(cl) WITH 'Entry exist' 'Not for creation' INTO lv_msg_bapi.
      raise_exception2odata( lv_msg_bapi ).
    ENDIF.


    """"""""""""""""""""""""""""""""""""""""
    DATA lt_var_id4db TYPE ztwa001_varid_tab.
    FIELD-SYMBOLS <fs_var_id> TYPE ztwa001_varid.

    GET TIME.
    APPEND INITIAL LINE TO lt_var_id4db ASSIGNING <fs_var_id>.
    MOVE-CORRESPONDING ms_entry_in TO <fs_var_id>.
    <fs_var_id>-var_name = ms_entry_in-name.
    <fs_var_id>-var_desc = ms_entry_in-description.
    <fs_var_id>-var_type = ms_entry_in-var_type.
    <fs_var_id>-is_debug_on = ms_entry_in-debug_is_on.
    <fs_var_id>-is_del = abap_false.
    <fs_var_id>-crd = sy-datum.
    <fs_var_id>-crt = sy-uzeit.
    <fs_var_id>-cru = cl_abap_syst=>get_user_name( ).
    <fs_var_id>-chd = sy-datum.
    <fs_var_id>-cht = sy-uzeit.
    <fs_var_id>-chu = cl_abap_syst=>get_user_name( ).

    save2db( lt_var_id4db ).

    ms_entry_in-crd =  <fs_var_id>-crd.
    ms_entry_in-crt =  <fs_var_id>-crt.
    ms_entry_in-cru =  <fs_var_id>-cru.
    ms_entry_in-chd =  <fs_var_id>-chd.
    ms_entry_in-cht =  <fs_var_id>-cht.
    ms_entry_in-chu =  <fs_var_id>-chu.
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
        WHEN 'Name'.
          ms_entry_in-name = lr_name_value_line->value.
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

    FIELD-SYMBOLS <fs_var_id> TYPE ztwa001_varid.
    DATA lt_var_id4db TYPE ztwa001_varid_tab.
    SELECT * FROM ztwa001_varid
      INTO TABLE lt_var_id4db
      WHERE var_name = ms_entry_in-name.

    GET TIME.

    LOOP AT lt_var_id4db ASSIGNING <fs_var_id>.
      <fs_var_id>-is_del = abap_true.
      <fs_var_id>-chd = sy-datum.
      <fs_var_id>-cht = sy-uzeit.
      <fs_var_id>-chu = cl_abap_syst=>get_user_name( ).
    ENDLOOP.

    save2db( lt_var_id4db ).
  ENDMETHOD.


  METHOD zif_wa003_entity_feeder~q.
    DATA lt_var_head_set TYPE zcl_zweb_abap_demo3_mpc=>tt_varh.
    fill_from_odata_filters(  ).
    fill_var_head_set( CHANGING ct_var_head_set = lt_var_head_set ).
    et_set[] =  lt_var_head_set[].
  ENDMETHOD.


  METHOD zif_wa003_entity_feeder~r.

    DATA lt_key_tab TYPE /iwbep/t_mgw_name_value_pair.
    DATA lr_name_value_line TYPE REF TO /iwbep/s_mgw_name_value_pair.

    DATA lt_entry_tab TYPE tt_entry.
    DATA ls_entry_out TYPE ts_entry.
    DATA lt_var_id TYPE ztwa001_varid_tab.


    FIELD-SYMBOLS <fs_var_id> TYPE ztwa001_varid.
    FIELD-SYMBOLS <fs_var_list> TYPE zswa001_variable_alv.

    lt_key_tab = mo_odata_in->get_key_tab(  ).

    CLEAR ms_entry_in.
    LOOP AT lt_key_tab REFERENCE INTO lr_name_value_line.
      CASE lr_name_value_line->name.
        WHEN 'Name'.
          ms_entry_in-name = lr_name_value_line->value.
        WHEN OTHERS.

      ENDCASE.
    ENDLOOP.

    SELECT * FROM ztwa001_varid
        INTO TABLE lt_var_id
        WHERE var_name = ms_entry_in-name
          .

    fill_stat_by_head( EXPORTING it_var_id       = lt_var_id
                       CHANGING  ct_var_head_set = lt_entry_tab ).


    MOVE-CORRESPONDING VALUE #( lt_entry_tab[ 1 ] OPTIONAL ) TO es .

  ENDMETHOD.


  METHOD zif_wa003_entity_feeder~set_batch_tab.

  ENDMETHOD.


  METHOD zif_wa003_entity_feeder~set_odata_in.
    mo_odata_in ?= io_odata_in.
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
    DATA lt_var_id4db TYPE ztwa001_varid_tab.
    FIELD-SYMBOLS <fs_var_id> TYPE ztwa001_varid.

    GET TIME.
    APPEND INITIAL LINE TO lt_var_id4db ASSIGNING <fs_var_id>.
    MOVE-CORRESPONDING ms_entry_in TO <fs_var_id>.
    <fs_var_id>-var_name = ms_entry_in-name.
    <fs_var_id>-var_desc = ms_entry_in-description.
    <fs_var_id>-var_type = ms_entry_in-var_type.
    <fs_var_id>-is_debug_on = ms_entry_in-debug_is_on.
    <fs_var_id>-is_del = ms_entry_in-is_del.
*    <fs_var_id>-crd = sy-datum.
*    <fs_var_id>-crt = sy-uzeit.
*    <fs_var_id>-cru = cl_abap_syst=>get_user_name( ).
    <fs_var_id>-chd = sy-datum.
    <fs_var_id>-cht = sy-uzeit.
    <fs_var_id>-chu = cl_abap_syst=>get_user_name( ).

    save2db( lt_var_id4db ).

    ms_entry_in-chd =  <fs_var_id>-chd.
    ms_entry_in-cht =  <fs_var_id>-cht.
    ms_entry_in-chu =  <fs_var_id>-chu.
    MOVE-CORRESPONDING ms_entry_in TO es.
  ENDMETHOD.
ENDCLASS.
