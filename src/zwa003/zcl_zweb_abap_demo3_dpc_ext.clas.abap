class ZCL_ZWEB_ABAP_DEMO3_DPC_EXT definition
  public
  inheriting from ZCL_ZWEB_ABAP_DEMO3_DPC
  create public .

public section.

  methods CONSTRUCTOR .

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CHANGESET_BEGIN
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CHANGESET_END
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CHANGESET_PROCESS
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~EXECUTE_ACTION
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_DEEP_ENTITY
    redefinition .
protected section.

  methods VARHSET_CREATE_ENTITY
    redefinition .
  methods VARHSET_DELETE_ENTITY
    redefinition .
  methods VARHSET_GET_ENTITY
    redefinition .
  methods VARHSET_GET_ENTITYSET
    redefinition .
  methods VARHSET_UPDATE_ENTITY
    redefinition .
  methods VARISET_CREATE_ENTITY
    redefinition .
  methods VARISET_DELETE_ENTITY
    redefinition .
  methods VARISET_GET_ENTITY
    redefinition .
  methods VARISET_GET_ENTITYSET
    redefinition .
  methods VARISET_UPDATE_ENTITY
    redefinition .
  PRIVATE SECTION.

    DATA mv_batch_mode TYPE abap_bool.

ENDCLASS.



CLASS ZCL_ZWEB_ABAP_DEMO3_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~changeset_begin.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~CHANGESET_BEGIN
*  EXPORTING
*    IT_OPERATION_INFO =
**  CHANGING
**    cv_defer_mode     =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.

    mv_batch_mode = abap_true.

    cv_defer_mode = abap_true.

  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~changeset_end.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~CHANGESET_END
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.

    mv_batch_mode = abap_false.

  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~changeset_process.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~CHANGESET_PROCESS
*  EXPORTING
*    IT_CHANGESET_REQUEST  =
*  CHANGING
*    CT_CHANGESET_RESPONSE =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.


*CD	Create Deep Entity
*CE	Create Entity
*DE	Delete Entity
*UE	Update Entity

    DATA ls_varh TYPE zswa003_var_h2_srv.
    DATA lt_varh TYPE STANDARD TABLE OF zswa003_var_h2_srv.

    DATA ls_vari TYPE zswa003_var_val2_srv.
    DATA lt_vari TYPE STANDARD TABLE OF zswa003_var_val2_srv.

*    DATA ls_var_val TYPE zswa003_var_h2_srv.
*    DATA lt_var_val TYPE STANDARD TABLE OF zswa003_var_h2_srv.

    DATA lo_entry_provider TYPE REF TO /iwbep/if_mgw_entry_provider.
    DATA lo_request_context TYPE REF TO /iwbep/cl_mgw_request.
    DATA lo_request_entity_u TYPE REF TO /iwbep/if_mgw_req_entity_u.
    DATA lv_target_entity TYPE string.


    DATA ls_response TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_response.

    FIELD-SYMBOLS <fs_changeset_request> TYPE /iwbep/if_mgw_appl_types=>ty_s_changeset_request.

    CLEAR lt_varh.
    CLEAR lt_vari.
    LOOP AT it_changeset_request ASSIGNING <fs_changeset_request>.
      CLEAR ls_varh.
      CLEAR ls_vari.

      lo_entry_provider ?= <fs_changeset_request>-entry_provider.

      CASE <fs_changeset_request>-operation_type.
        WHEN 'CD'.  "Create Deep Entity.
        WHEN 'CE'.  "Create Entity .
        WHEN 'DE'.  "Delete Entity .
        WHEN 'UE'.  "Update Entity .
          lo_request_entity_u ?= <fs_changeset_request>-request_context.
          lv_target_entity = lo_request_entity_u->get_entity_type_name( ).

          CASE lv_target_entity.
            WHEN 'VarH'.
              lo_entry_provider->read_entry_data( IMPORTING es_data = ls_varh ).
              APPEND ls_varh TO lt_varh.
            WHEN 'VarI'.
              lo_entry_provider->read_entry_data( IMPORTING es_data = ls_vari ).
              APPEND ls_vari TO lt_vari.
            WHEN OTHERS.
          ENDCASE.



        WHEN OTHERS.
      ENDCASE.


      ls_response-operation_no = <fs_changeset_request>-operation_no.
      copy_data_to_ref( EXPORTING is_data = ls_varh
                        CHANGING  cr_data = ls_response-entity_data ).
      APPEND ls_response TO ct_changeset_response.

    ENDLOOP.

    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'''
    DATA lt_var_id4db TYPE ztwa001_varid_tab.
    DATA lt_var_val4db TYPE ztwa001_varval_tab.

    FIELD-SYMBOLS <fs_varh> TYPE zswa003_var_h2_srv.
    FIELD-SYMBOLS <fs_vari> TYPE zswa003_var_val2_srv.
    FIELD-SYMBOLS <fs_valid4db> TYPE ztwa001_varid.

    DATA lo_save_var_n_range TYPE REF TO zcl_wa001_save_var_n_rng.
    DATA lv_commit_or_not_commit TYPE abap_bool.

    lo_save_var_n_range = NEW #(  ).
    lv_commit_or_not_commit = abap_false.

    "  MOVE-CORRESPONDING lt_varh TO lt_var_id4db.
    CLEAR lt_var_id4db.
    GET TIME.
    LOOP AT lt_varh ASSIGNING <fs_varh>.
      APPEND INITIAL LINE TO lt_var_id4db ASSIGNING <fs_valid4db>.
      <fs_valid4db>-mandt = cl_abap_syst=>get_client( ).
      <fs_valid4db>-var_name = <fs_varh>-name.
      <fs_valid4db>-var_desc = <fs_varh>-description.
      <fs_valid4db>-var_type = <fs_varh>-var_type.
      <fs_valid4db>-is_del   = <fs_varh>-is_del.
      <fs_valid4db>-is_debug_on = <fs_varh>-debug_is_on.
      <fs_valid4db>-fast_val = <fs_varh>-fast_val.
      <fs_valid4db>-cru = sy-uname.
      <fs_valid4db>-crd = sy-datum.
      <fs_valid4db>-crt = sy-uzeit.
      <fs_valid4db>-chu = sy-uname.
      <fs_valid4db>-chd = sy-datum.
      <fs_valid4db>-cht = sy-uzeit.
    ENDLOOP.
    MOVE-CORRESPONDING lt_vari[] TO lt_var_val4db[].

    lo_save_var_n_range->sh(  EXPORTING it_varid      = lt_var_id4db
                                        it_varval     = lt_var_val4db
                                        iv_do_commit  = lv_commit_or_not_commit ).

  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_deep_entity.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_DEEP_ENTITY
*  EXPORTING
**    iv_entity_name          =
**    iv_entity_set_name      =
**    iv_source_name          =
*    IO_DATA_PROVIDER        =
**    it_key_tab              =
**    it_navigation_path      =
*    IO_EXPAND               =
**    io_tech_request_context =
**  IMPORTING
**    er_deep_entity          =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.

    TYPES: BEGIN OF ts_entry_deep.
            INCLUDE TYPE zcl_zweb_abap_demo3_mpc=>ts_varh.
    TYPES: varid2range TYPE STANDARD TABLE OF zcl_zweb_abap_demo3_mpc=>ts_vari WITH DEFAULT KEY
          , END OF ts_entry_deep.

    DATA ls_entry_deep TYPE ts_entry_deep.


    DATA lt_children TYPE /iwbep/if_mgw_odata_expand=>ty_t_node_children.
    DATA lv_child_entity TYPE string.
    FIELD-SYMBOLS <fs_child> TYPE /iwbep/if_mgw_odata_expand=>ty_s_node_child.
    lt_children = io_expand->get_children( ).
    LOOP AT lt_children ASSIGNING <fs_child>.
      lv_child_entity = <fs_child>-node->get_tech_entity_type( ).
    ENDLOOP.


    io_data_provider->read_entry_data( IMPORTING es_data = ls_entry_deep ).

    copy_data_to_ref(
      EXPORTING
        is_data = ls_entry_deep
      CHANGING
        cr_data = er_deep_entity
    ).

  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~execute_action.
*    importing
*      !IV_ACTION_NAME type STRING optional
*      !IT_PARAMETER type /IWBEP/T_MGW_NAME_VALUE_PAIR optional
*      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT optional
*    exporting
*      !ER_DATA type ref to DATA
*    raising
*      /IWBEP/CX_MGW_BUSI_EXCEPTION
*      /IWBEP/CX_MGW_TECH_EXCEPTION .

    DATA lr_parameter TYPE REF TO /iwbep/s_mgw_name_value_pair.
    DATA ls_var_h TYPE zcl_zweb_abap_demo3_mpc=>ts_varh.
    DATA ls_var_h_out TYPE zcl_zweb_abap_demo3_mpc=>ts_varh.

    CASE iv_action_name.
      WHEN 'SwitchOnVarDebug'.
        LOOP AT it_parameter REFERENCE INTO lr_parameter.
          CASE lr_parameter->name.
            WHEN 'VarID'.
              ls_var_h-name = lr_parameter->value.
          ENDCASE.
        ENDLOOP.

        DATA lt_varid_db TYPE ztwa001_varid_tab.
        DATA lt_var_val4db TYPE ztwa001_varval_tab.
        FIELD-SYMBOLS <fs_varid> TYPE ztwa001_varid.

        SELECT * FROM ztwa001_varid
            INTO TABLE lt_varid_db
            WHERE var_name = ls_var_h-name.

        LOOP AT lt_varid_db ASSIGNING <fs_varid>.
          <fs_varid>-is_debug_on = abap_true.
          MOVE-CORRESPONDING <fs_varid> TO ls_var_h_out.
          ls_var_h_out-name         = <fs_varid>-var_name.
          ls_var_h_out-description  = <fs_varid>-var_desc.
        ENDLOOP.
        IF sy-subrc NE 0.
          RETURN.
        ENDIF.

        NEW zcl_wa001_save_var_n_rng(  )->sh(  EXPORTING it_varid =  lt_varid_db
                                                         it_varval = lt_var_val4db ).

        copy_data_to_ref( EXPORTING is_data = ls_var_h_out
                          CHANGING  cr_data = er_data ).

      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.


  METHOD constructor.
    super->constructor( ).
  ENDMETHOD.


  METHOD varhset_create_entity.
*    importing
*      !IV_ENTITY_NAME type STRING
*      !IV_ENTITY_SET_NAME type STRING
*      !IV_SOURCE_NAME type STRING
*      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
*      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_C optional
*      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
*      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER optional
*    exporting
*      !ER_ENTITY type ZCL_ZWEB_ABAP_DEMO3_MPC=>TS_VARH
*    raising
*      /IWBEP/CX_MGW_BUSI_EXCEPTION
*      /IWBEP/CX_MGW_TECH_EXCEPTION .
    DATA lo_odata_in TYPE REF TO zif_wa003_odata_in.
    CREATE OBJECT lo_odata_in TYPE (zif_wa003_odata_in=>imp_b).

    lo_odata_in->set_from_c(
      EXPORTING
        iv_entity_name          = iv_entity_name
        iv_entity_set_name      = iv_entity_set_name
        iv_source_name          = iv_source_name
        it_key_tab              = it_key_tab
        io_tech_request_context = io_tech_request_context
        it_navigation_path      = it_navigation_path
        io_data_provider        = io_data_provider
    ).
    lo_odata_in->set_context( mo_context ).
    lo_odata_in->set_batch_changeset_mode( iv = mv_batch_mode ).
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    DATA lo_entity_var_h TYPE REF TO zif_wa003_entity_feeder.
    DATA lv_entity_var_h_clsname TYPE seoclsname VALUE 'ZCL_WA003_VAR_HEAD_FEED'.
    CREATE OBJECT lo_entity_var_h TYPE (lv_entity_var_h_clsname).
    lo_entity_var_h->set_odata_in( io_odata_in = lo_odata_in ).

    lo_entity_var_h->c( IMPORTING es = er_entity ).

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  ENDMETHOD.


  METHOD varhset_delete_entity.
*    importing
*      !IV_ENTITY_NAME type STRING
*      !IV_ENTITY_SET_NAME type STRING
*      !IV_SOURCE_NAME type STRING
*      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
*      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_D optional
*      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
    DATA lo_odata_in TYPE REF TO zif_wa003_odata_in.
    CREATE OBJECT lo_odata_in TYPE (zif_wa003_odata_in=>imp_b).

    lo_odata_in->set_from_d(
      EXPORTING
        iv_entity_name          = iv_entity_name
        iv_entity_set_name      = iv_entity_set_name
        iv_source_name          = iv_source_name
        it_key_tab              = it_key_tab
        io_tech_request_context = io_tech_request_context
        it_navigation_path      = it_navigation_path
    ).
    lo_odata_in->set_context( mo_context ).
    lo_odata_in->set_batch_changeset_mode( iv = mv_batch_mode ).
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    DATA lo_entity_var_h TYPE REF TO zif_wa003_entity_feeder.
    DATA lv_entity_var_h_clsname TYPE seoclsname VALUE 'ZCL_WA003_VAR_HEAD_FEED'.
    CREATE OBJECT lo_entity_var_h TYPE (lv_entity_var_h_clsname).
    lo_entity_var_h->set_odata_in( io_odata_in = lo_odata_in ).
    lo_entity_var_h->d( ).
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  ENDMETHOD.


  METHOD varhset_get_entity.
*    importing
*      !IV_ENTITY_NAME type STRING
*      !IV_ENTITY_SET_NAME type STRING
*      !IV_SOURCE_NAME type STRING
*      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
*      !IO_REQUEST_OBJECT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
*      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
*      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
*    exporting
*      !ER_ENTITY type ZCL_ZWEB_ABAP_DEMO3_MPC=>TS_VARH
*      !ES_RESPONSE_CONTEXT type /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_ENTITY_CNTXT
*    raising
*      /IWBEP/CX_MGW_BUSI_EXCEPTION
*      /IWBEP/CX_MGW_TECH_EXCEPTION .
    DATA lo_odata_in TYPE REF TO zif_wa003_odata_in.
    CREATE OBJECT lo_odata_in TYPE (zif_wa003_odata_in=>imp_b).

    lo_odata_in->set_from_r(
      EXPORTING
        iv_entity_name          = iv_entity_name
        iv_entity_set_name      = iv_entity_set_name
        iv_source_name          = iv_source_name
        it_key_tab              = it_key_tab
        io_request_object       = io_request_object
        io_tech_request_context = io_tech_request_context
        it_navigation_path      = it_navigation_path
    ).

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    DATA lo_entity_var_h TYPE REF TO zif_wa003_entity_feeder.
    DATA lv_entity_var_h_clsname TYPE seoclsname VALUE 'ZCL_WA003_VAR_HEAD_FEED'.
    CREATE OBJECT lo_entity_var_h TYPE (lv_entity_var_h_clsname).
    lo_entity_var_h->set_odata_in( io_odata_in = lo_odata_in ).

    lo_entity_var_h->r( IMPORTING es                  = er_entity
                                  es_response_context = es_response_context ).
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

  ENDMETHOD.


  METHOD varhset_get_entityset.
**TRY.
*CALL METHOD SUPER->VARHSET_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    io_tech_request_context  =
**  IMPORTING
**    et_entityset             =
**    es_response_context      =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    DATA lo_odata_in TYPE REF TO zif_wa003_odata_in.
    CREATE OBJECT lo_odata_in TYPE (zif_wa003_odata_in=>imp_b).

    lo_odata_in->set_from_q(
      EXPORTING
        iv_entity_name           = iv_entity_name
        iv_entity_set_name       = iv_entity_set_name
        iv_source_name           = iv_source_name
        it_filter_select_options = it_filter_select_options
        is_paging                = is_paging
        it_key_tab               = it_key_tab
        it_navigation_path       = it_navigation_path
        it_order                 = it_order
        iv_filter_string         = iv_filter_string
        iv_search_string         = iv_search_string
        io_tech_request_context  = io_tech_request_context
    ).

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    IF 1 = 2 .
      data lo_where TYPE REF TO ZCL_WA003_VAR_HEAD_FEED.
    ENDIF.

    DATA lo_entity_var_h TYPE REF TO zif_wa003_entity_feeder.
    DATA lv_entity_var_h_clsname TYPE seoclsname VALUE 'ZCL_WA003_VAR_HEAD_FEED'.
    "DATA lv_entity_var_h_clsname TYPE seoclsname VALUE 'ZCL_WA003_VAR_HEAD_FEED_V2'.
    CREATE OBJECT lo_entity_var_h TYPE (lv_entity_var_h_clsname).
    lo_entity_var_h->set_odata_in( io_odata_in = lo_odata_in ).

    lo_entity_var_h->q( IMPORTING et_set              = et_entityset
                                  es_response_context = es_response_context  ).
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

  ENDMETHOD.


  METHOD varhset_update_entity.
*    importing
*      !IV_ENTITY_NAME type STRING
*      !IV_ENTITY_SET_NAME type STRING
*      !IV_SOURCE_NAME type STRING
*      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
*      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_U optional
*      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
*      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER optional

    DATA lo_odata_in TYPE REF TO zif_wa003_odata_in.
    CREATE OBJECT lo_odata_in TYPE (zif_wa003_odata_in=>imp_b).

    lo_odata_in->set_from_u(
      EXPORTING
        iv_entity_name          = iv_entity_name
        iv_entity_set_name      = iv_entity_set_name
        iv_source_name          = iv_source_name
        it_key_tab              = it_key_tab
        io_tech_request_context = io_tech_request_context
        it_navigation_path      = it_navigation_path
        io_data_provider        = io_data_provider
    ).
    lo_odata_in->set_context( mo_context ).
    lo_odata_in->set_batch_changeset_mode( iv = mv_batch_mode ).
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    DATA lo_entity_var_h TYPE REF TO zif_wa003_entity_feeder.
    DATA lv_entity_var_h_clsname TYPE seoclsname VALUE 'ZCL_WA003_VAR_HEAD_FEED'.
    CREATE OBJECT lo_entity_var_h TYPE (lv_entity_var_h_clsname).
    lo_entity_var_h->set_odata_in( io_odata_in = lo_odata_in ).

    lo_entity_var_h->u( IMPORTING es = er_entity ).
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  ENDMETHOD.


  METHOD variset_create_entity  .
    DATA lo_odata_in TYPE REF TO zif_wa003_odata_in.
    CREATE OBJECT lo_odata_in TYPE (zif_wa003_odata_in=>imp_b).

    lo_odata_in->set_from_c(
      EXPORTING
        iv_entity_name          = iv_entity_name
        iv_entity_set_name      = iv_entity_set_name
        iv_source_name          = iv_source_name
        it_key_tab              = it_key_tab
        io_tech_request_context = io_tech_request_context
        it_navigation_path      = it_navigation_path
        io_data_provider        = io_data_provider
    ).
    lo_odata_in->set_context( mo_context ).
    lo_odata_in->set_batch_changeset_mode( iv = mv_batch_mode ).
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    DATA lo_entity_var_h TYPE REF TO zif_wa003_entity_feeder.
    DATA lv_entity_var_h_clsname TYPE seoclsname VALUE 'ZCL_WA003_VAR_ITEM_FEED'.
    CREATE OBJECT lo_entity_var_h TYPE (lv_entity_var_h_clsname).
    lo_entity_var_h->set_odata_in( io_odata_in = lo_odata_in ).

    lo_entity_var_h->c( IMPORTING es = er_entity ).

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  ENDMETHOD.


  METHOD variset_delete_entity .
    DATA lo_odata_in TYPE REF TO zif_wa003_odata_in.
    CREATE OBJECT lo_odata_in TYPE (zif_wa003_odata_in=>imp_b).

    lo_odata_in->set_from_d(
      EXPORTING
        iv_entity_name          = iv_entity_name
        iv_entity_set_name      = iv_entity_set_name
        iv_source_name          = iv_source_name
        it_key_tab              = it_key_tab
        io_tech_request_context = io_tech_request_context
        it_navigation_path      = it_navigation_path
    ).
    lo_odata_in->set_context( mo_context ).
    lo_odata_in->set_batch_changeset_mode( iv = mv_batch_mode ).
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    DATA lo_entity_var_h TYPE REF TO zif_wa003_entity_feeder.
    DATA lv_entity_var_h_clsname TYPE seoclsname VALUE 'ZCL_WA003_VAR_ITEM_FEED'.
    CREATE OBJECT lo_entity_var_h TYPE (lv_entity_var_h_clsname).
    lo_entity_var_h->set_odata_in( io_odata_in = lo_odata_in ).
    lo_entity_var_h->d( ).
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  ENDMETHOD.


  METHOD variset_get_entity  .
    DATA lo_odata_in TYPE REF TO zif_wa003_odata_in.
    CREATE OBJECT lo_odata_in TYPE (zif_wa003_odata_in=>imp_b).

    lo_odata_in->set_from_r(
      EXPORTING
        iv_entity_name          = iv_entity_name
        iv_entity_set_name      = iv_entity_set_name
        iv_source_name          = iv_source_name
        it_key_tab              = it_key_tab
        io_request_object       = io_request_object
        io_tech_request_context = io_tech_request_context
        it_navigation_path      = it_navigation_path
    ).

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    DATA lo_entity_var_h TYPE REF TO zif_wa003_entity_feeder.
    DATA lv_entity_var_h_clsname TYPE seoclsname VALUE 'ZCL_WA003_VAR_ITEM_FEED'.
    CREATE OBJECT lo_entity_var_h TYPE (lv_entity_var_h_clsname).
    lo_entity_var_h->set_odata_in( io_odata_in = lo_odata_in ).

    lo_entity_var_h->r( IMPORTING es                  = er_entity
                                  es_response_context = es_response_context ).
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

  ENDMETHOD.


  METHOD variset_get_entityset .
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    DATA lo_odata_in TYPE REF TO zif_wa003_odata_in.
    CREATE OBJECT lo_odata_in TYPE (zif_wa003_odata_in=>imp_b).

    lo_odata_in->set_from_q(
      EXPORTING
        iv_entity_name           = iv_entity_name
        iv_entity_set_name       = iv_entity_set_name
        iv_source_name           = iv_source_name
        it_filter_select_options = it_filter_select_options
        is_paging                = is_paging
        it_key_tab               = it_key_tab
        it_navigation_path       = it_navigation_path
        it_order                 = it_order
        iv_filter_string         = iv_filter_string
        iv_search_string         = iv_search_string
        io_tech_request_context  = io_tech_request_context
    ).

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    DATA lo_entity_var_h TYPE REF TO zif_wa003_entity_feeder.
    DATA lv_entity_var_h_clsname TYPE seoclsname VALUE 'ZCL_WA003_VAR_ITEM_FEED'.
    CREATE OBJECT lo_entity_var_h TYPE (lv_entity_var_h_clsname).
    lo_entity_var_h->set_odata_in( io_odata_in = lo_odata_in ).

    lo_entity_var_h->q( IMPORTING et_set              = et_entityset
                                  es_response_context = es_response_context  ).
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

  ENDMETHOD.


  METHOD variset_update_entity.
    DATA lo_odata_in TYPE REF TO zif_wa003_odata_in.
    CREATE OBJECT lo_odata_in TYPE (zif_wa003_odata_in=>imp_b).

    lo_odata_in->set_from_u(
      EXPORTING
        iv_entity_name          = iv_entity_name
        iv_entity_set_name      = iv_entity_set_name
        iv_source_name          = iv_source_name
        it_key_tab              = it_key_tab
        io_tech_request_context = io_tech_request_context
        it_navigation_path      = it_navigation_path
        io_data_provider        = io_data_provider
    ).
    lo_odata_in->set_context( mo_context ).
    lo_odata_in->set_batch_changeset_mode( iv = mv_batch_mode ).
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    DATA lo_entity_var_h TYPE REF TO zif_wa003_entity_feeder.
    DATA lv_entity_var_h_clsname TYPE seoclsname VALUE 'ZCL_WA003_VAR_ITEM_FEED'.
    CREATE OBJECT lo_entity_var_h TYPE (lv_entity_var_h_clsname).
    lo_entity_var_h->set_odata_in( io_odata_in = lo_odata_in ).

    lo_entity_var_h->u( IMPORTING es = er_entity ).
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  ENDMETHOD.
ENDCLASS.
