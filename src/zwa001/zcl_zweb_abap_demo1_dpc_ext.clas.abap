CLASS zcl_zweb_abap_demo1_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zweb_abap_demo1_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.
  PROTECTED SECTION.


    METHODS varheadset_get_entityset REDEFINITION .
    METHODS varheadset_get_entity  REDEFINITION .
    METHODS varheadset_create_entity  REDEFINITION .
    METHODS varheadset_update_entity REDEFINITION .
    METHODS varheadset_delete_entity  REDEFINITION .

    METHODS varvalueset_create_entity REDEFINITION .
    METHODS varvalueset_delete_entity  REDEFINITION .
    METHODS varvalueset_get_entity  REDEFINITION .
    METHODS varvalueset_get_entityset REDEFINITION .
    METHODS varvalueset_update_entity  REDEFINITION .
  PRIVATE SECTION.
    METHODS select_from_tab_with_count
      RETURNING VALUE(rv_val) TYPE syindex.
ENDCLASS.



CLASS ZCL_ZWEB_ABAP_DEMO1_DPC_EXT IMPLEMENTATION.


  METHOD select_from_tab_with_count.
    rv_val = 232.
  ENDMETHOD.


  METHOD varheadset_create_entity.
*        importing
*      !IV_ENTITY_NAME type STRING
*      !IV_ENTITY_SET_NAME type STRING
*      !IV_SOURCE_NAME type STRING
*      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
*      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_C optional
*      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
*      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER optional
*    exporting
*      !ER_ENTITY type ZCL_ZWEB_ABAP_DEMO1_MPC=>TS_VARHEAD
*    raising
*      /IWBEP/CX_MGW_BUSI_EXCEPTION
*      /IWBEP/CX_MGW_TECH_EXCEPTION .
    DATA ls_srv_in TYPE zcl_zweb_abap_demo1_mpc=>ts_varhead.

    io_data_provider->read_entry_data( IMPORTING es_data = ls_srv_in ).
    MOVE-CORRESPONDING ls_srv_in TO er_entity.

  ENDMETHOD.


  METHOD varheadset_delete_entity.
*    importing
*      !IV_ENTITY_NAME type STRING
*      !IV_ENTITY_SET_NAME type STRING
*      !IV_SOURCE_NAME type STRING
*      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
*      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_D optional
*      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
*    raising
*      /IWBEP/CX_MGW_BUSI_EXCEPTION
*      /IWBEP/CX_MGW_TECH_EXCEPTION .

    DATA lr_name_value_line TYPE REF TO /iwbep/s_mgw_name_value_pair.
    DATA ls_srv_in TYPE zcl_zweb_abap_demo1_mpc=>ts_varhead.

    LOOP AT it_key_tab REFERENCE INTO lr_name_value_line.
      CASE lr_name_value_line->name.
        WHEN 'NAME' OR 'Name'.
          ls_srv_in-name = lr_name_value_line->value.
        WHEN OTHERS.

      ENDCASE.
    ENDLOOP.

  ENDMETHOD.


  METHOD varheadset_get_entity.
*        importing
*      !IV_ENTITY_NAME type STRING
*      !IV_ENTITY_SET_NAME type STRING
*      !IV_SOURCE_NAME type STRING
*      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
*      !IO_REQUEST_OBJECT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
*      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
*      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
*    exporting
*      !ER_ENTITY type ZCL_ZWEB_ABAP_DEMO1_MPC=>TS_VARHEAD
*      !ES_RESPONSE_CONTEXT type /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_ENTITY_CNTXT
*    raising
*      /IWBEP/CX_MGW_BUSI_EXCEPTION
*      /IWBEP/CX_MGW_TECH_EXCEPTION .

    DATA lr_name_value_line TYPE REF TO /iwbep/s_mgw_name_value_pair.
    DATA ls_srv_in TYPE zswa001_var_h_srv.
    DATA ls_srv_out TYPE zswa001_var_h_srv.

    DATA lt_var_id TYPE ztwa001_varid_tab.
    DATA lt_var_val TYPE ztwa001_varval_tab.
    DATA lt_var_file TYPE ztwa001_varfile_tab.

    FIELD-SYMBOLS <fs_var_id> TYPE ztwa001_varid.
    FIELD-SYMBOLS <fs_var_list> TYPE zswa001_variable_alv.

    LOOP AT it_key_tab REFERENCE INTO lr_name_value_line.
      CASE lr_name_value_line->name.
        WHEN 'NAME' OR 'Name'.
          ls_srv_in-name = lr_name_value_line->value.
        WHEN OTHERS.

      ENDCASE.
    ENDLOOP.

    SELECT * FROM ztwa001_varid
        INTO TABLE lt_var_id
        WHERE var_name = ls_srv_in-name.

    SELECT * FROM ztwa001_varval
        INTO TABLE lt_var_val
        WHERE var_name = ls_srv_in-name.

    LOOP AT lt_var_id ASSIGNING <fs_var_id>.

      MOVE-CORRESPONDING <fs_var_id> TO ls_srv_out.

      ls_srv_out-name = <fs_var_id>-var_name.
      ls_srv_out-description = <fs_var_id>-var_desc.
      ls_srv_out-var_type = <fs_var_id>-var_type.

      ls_srv_out-is_del = <fs_var_id>-is_del.
      ls_srv_out-debug_is_on = <fs_var_id>-is_debug_on.
      ls_srv_out-fast_val = <fs_var_id>-fast_val.
      ls_srv_out-cru = <fs_var_id>-cru.
      ls_srv_out-crd = <fs_var_id>-crd.
      ls_srv_out-crt = <fs_var_id>-crt.
      ls_srv_out-chu = <fs_var_id>-chu.
      ls_srv_out-chd = <fs_var_id>-chd.
      ls_srv_out-cht = <fs_var_id>-cht.

      ls_srv_out-num_of_values = REDUCE i( INIT vals_in_var = 0
                                              FOR ls_var_val IN lt_var_val WHERE ( var_name = <fs_var_id>-var_name )
                                              NEXT vals_in_var = vals_in_var + 1 ).

      ls_srv_out-num_of_files = REDUCE i( INIT files_in_var = 0
                                              FOR ls_var_file IN lt_var_file WHERE ( var_name = <fs_var_id>-var_name )
                                              NEXT files_in_var = files_in_var + 1 ).

      EXIT.
    ENDLOOP.

    MOVE-CORRESPONDING ls_srv_out TO er_entity.

    IF ls_srv_out IS INITIAL.
      es_response_context-no_content = abap_true.
    ENDIF.


  ENDMETHOD.


  METHOD varheadset_get_entityset.
**TRY.
*CALL METHOD SUPER->VARHEADSET_GET_ENTITYSET
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


    DATA lt_var_set TYPE zttwa001_var_h_srv.
    FIELD-SYMBOLS <fs_var_set> TYPE zswa001_var_h_srv.

    DATA lt_var_id TYPE ztwa001_varid_tab.
    DATA lt_var_val TYPE ztwa001_varval_tab.
    DATA lt_var_file TYPE ztwa001_varfile_tab.

    FIELD-SYMBOLS <fs_var_id> TYPE ztwa001_varid.
    FIELD-SYMBOLS <fs_var_list> TYPE zswa001_variable_alv.


    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " $filter - reading
    DATA lo_req_filter TYPE REF TO /iwbep/if_mgw_req_filter.
    DATA lt_select_options TYPE /iwbep/t_mgw_select_option.
    DATA lt_varid_range TYPE RANGE OF ztwa001_varid-var_name.
    DATA lt_vardesc_range TYPE RANGE OF ztwa001_varid-var_desc.

    FIELD-SYMBOLS <fs_select_option> TYPE /iwbep/s_mgw_select_option.

    lo_req_filter ?= io_tech_request_context->get_filter( ).
    lt_select_options = lo_req_filter->get_filter_select_options(  ).

    LOOP AT lt_select_options ASSIGNING <fs_select_option>.
      CASE <fs_select_option>-property.
        WHEN 'Name' OR 'NAME'.
          lo_req_filter->convert_select_option( EXPORTING is_select_option = <fs_select_option>
                                                IMPORTING et_select_option = lt_varid_range ).

        WHEN 'Description' OR 'DESCRIPTION'.
          lo_req_filter->convert_select_option( EXPORTING is_select_option = <fs_select_option>
                                                IMPORTING et_select_option = lt_vardesc_range ).
        WHEN OTHERS.

      ENDCASE.
    ENDLOOP.


    SELECT * FROM ztwa001_varid
        INTO TABLE lt_var_id
        UP TO 1000 ROWS
        WHERE var_name IN lt_varid_range
        and var_desc IN lt_vardesc_range

        .

    IF lt_var_id IS NOT INITIAL.
      SELECT * FROM ztwa001_varval
         INTO TABLE lt_var_val
         FOR ALL ENTRIES IN lt_var_id
         WHERE  var_name EQ lt_var_id-var_name
         .

      SELECT * FROM ztwa001_varfile
        INTO TABLE lt_var_file
        FOR ALL ENTRIES IN lt_var_id
         WHERE  var_name EQ lt_var_id-var_name
         .
    ENDIF.


    CLEAR lt_var_set.

    LOOP AT lt_var_id ASSIGNING <fs_var_id>.
      APPEND INITIAL LINE TO lt_var_set ASSIGNING <fs_var_set>.
      MOVE-CORRESPONDING <fs_var_id> TO <fs_var_set>.

      <fs_var_set>-name = <fs_var_id>-var_name.
      <fs_var_set>-description = <fs_var_id>-var_desc.
      <fs_var_set>-var_type = <fs_var_id>-var_type.
      <fs_var_set>-var_type_tx = SWITCH #( <fs_var_set>-var_type
                                        WHEN '1' then 'Separate Value'
                                        WHEN '2' then 'Switch'
                                        WHEN '3' then 'Range'
                                        WHEN '4' then 'SpecialRange'
                                        else 'No description' ).


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

    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    et_entityset[] = lt_var_set[].
    IF io_tech_request_context->has_count( ) EQ abap_true.
      es_response_context-count = lines( et_entityset[] ).
    ENDIF.
    es_response_context-is_sap_data_exists_calculated = abap_true.
    "es_response_context-skiptoken

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " $select - option: перечисление полей
    DATA lt_select_fields TYPE /iwbep/t_mgw_tech_field_names.
    lt_select_fields = io_tech_request_context->get_select( ).
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " $orderby - поля для сортировки
    DATA lt_orderby_fields TYPE /iwbep/t_mgw_tech_order.
    lt_orderby_fields = io_tech_request_context->get_orderby( ).

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " $inlinecount=allpages
    IF io_tech_request_context->has_inlinecount( ) EQ abap_true.
      es_response_context-inlinecount = select_from_tab_with_count(  ).
    ENDIF.

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " $top / $skip
    " is_paging- передается явно
    DATA(lv_top_records) = io_tech_request_context->get_top( ).
    DATA(lv_skip_offset) = io_tech_request_context->get_skip( ).

    SELECT * FROM ztwa001_varid
         WHERE var_name IN @lt_varid_range ORDER BY PRIMARY KEY
        INTO TABLE @lt_var_id
        OFFSET @is_paging-skip
        UP TO @is_paging-top ROWS.

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " $skiptoken - пагинации средствами сервера
    DATA lv_token_size_on_server TYPE syindex VALUE 12.
    DATA lv_token_size_on_server_plus10 TYPE syindex.
    DATA lv_skiptoken_step TYPE sytabix.
    DATA one_due2minus_offset TYPE syindex VALUE 1.
    DATA one_due2next_record TYPE syindex VALUE 1.

    lv_skiptoken_step = io_tech_request_context->get_skiptoken( ).
    IF lv_skiptoken_step IS NOT INITIAL.
      " skiptoken - это не просто skip, а начало следующей записи, поэтому - для OFFSET
      lv_skiptoken_step = lv_skiptoken_step - 1.

      " чтобы рассчитать
      lv_token_size_on_server_plus10 = lv_token_size_on_server + 10.
      SELECT * FROM ztwa001_varid
       WHERE var_name IN @lt_varid_range ORDER BY PRIMARY KEY
      INTO TABLE @lt_var_id
      OFFSET @lv_skiptoken_step
      UP TO @lv_token_size_on_server_plus10 ROWS.

      IF lines( lt_var_id ) GT lv_token_size_on_server.
        DELETE lt_var_id FROM lv_token_size_on_server.
        es_response_context-skiptoken = lv_skiptoken_step + lv_token_size_on_server + one_due2minus_offset + one_due2next_record.
        CONDENSE es_response_context-skiptoken NO-GAPS.
      ELSE.
        CLEAR es_response_context-skiptoken.
      ENDIF.
      MOVE-CORRESPONDING lt_var_id[] TO et_entityset[].
    ENDIF.
  ENDMETHOD.


  METHOD varheadset_update_entity.
**TRY.
*CALL METHOD SUPER->VARHEADSET_UPDATE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**    io_data_provider        =
**  IMPORTING
**    er_entity               =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.

    DATA ls_srv_in TYPE zcl_zweb_abap_demo1_mpc=>ts_varhead.

    io_data_provider->read_entry_data( IMPORTING es_data = ls_srv_in ).
    MOVE-CORRESPONDING ls_srv_in TO er_entity.

  ENDMETHOD.


  METHOD varvalueset_create_entity  .
*    importing
*      !IV_ENTITY_NAME type STRING
*      !IV_ENTITY_SET_NAME type STRING
*      !IV_SOURCE_NAME type STRING
*      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
*      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_C optional
*      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
*      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER optional
*    exporting
*      !ER_ENTITY type ZCL_ZWEB_ABAP_DEMO1_MPC=>TS_VARVALUE
*    raising
*      /IWBEP/CX_MGW_BUSI_EXCEPTION
*      /IWBEP/CX_MGW_TECH_EXCEPTION .

    DATA ls_srv_in TYPE zcl_zweb_abap_demo1_mpc=>ts_varvalue.

    io_data_provider->read_entry_data( IMPORTING  es_data = ls_srv_in  ).

    MOVE-CORRESPONDING ls_srv_in TO er_entity.
  ENDMETHOD.


  METHOD varvalueset_delete_entity  .
*    importing
*      !IV_ENTITY_NAME type STRING
*      !IV_ENTITY_SET_NAME type STRING
*      !IV_SOURCE_NAME type STRING
*      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
*      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_D optional
*      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
*    raising
*      /IWBEP/CX_MGW_BUSI_EXCEPTION
*      /IWBEP/CX_MGW_TECH_EXCEPTION .
    DATA lr_name_value_line TYPE REF TO /iwbep/s_mgw_name_value_pair.
    DATA ls_srv_to_be_del TYPE zcl_zweb_abap_demo1_mpc=>ts_varvalue.

    DATA lt_var_val TYPE ztwa001_varval_tab.

    FIELD-SYMBOLS <fs_var_id> TYPE ztwa001_varid.
    FIELD-SYMBOLS <fs_var_list> TYPE zswa001_variable_alv.

    LOOP AT it_key_tab REFERENCE INTO lr_name_value_line.
      CASE lr_name_value_line->name.
        WHEN 'VAR_NAME' OR 'VarName'.
          ls_srv_to_be_del-var_name = lr_name_value_line->value.
        WHEN 'VAR_NUMB' OR 'VarNumb'.
          ls_srv_to_be_del-var_numb = lr_name_value_line->value.
        WHEN OTHERS.

      ENDCASE.
    ENDLOOP.

  ENDMETHOD.


  METHOD varvalueset_get_entity  .
*    importing
*      !IV_ENTITY_NAME type STRING
*      !IV_ENTITY_SET_NAME type STRING
*      !IV_SOURCE_NAME type STRING
*      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
*      !IO_REQUEST_OBJECT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
*      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
*      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
*    exporting
*      !ER_ENTITY type ZCL_ZWEB_ABAP_DEMO1_MPC=>TS_VARVALUE
*      !ES_RESPONSE_CONTEXT type /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_ENTITY_CNTXT
*    raising
*      /IWBEP/CX_MGW_BUSI_EXCEPTION
*      /IWBEP/CX_MGW_TECH_EXCEPTION .
    DATA lr_name_value_line TYPE REF TO /iwbep/s_mgw_name_value_pair.
    DATA ls_srv_in TYPE zcl_zweb_abap_demo1_mpc=>ts_varvalue.
    DATA ls_srv_out TYPE zcl_zweb_abap_demo1_mpc=>ts_varvalue.

    DATA lt_var_val TYPE ztwa001_varval_tab.


    FIELD-SYMBOLS <fs_var_id> TYPE ztwa001_varid.
    FIELD-SYMBOLS <fs_var_list> TYPE zswa001_variable_alv.

    LOOP AT it_key_tab REFERENCE INTO lr_name_value_line.
      CASE lr_name_value_line->name.
        WHEN 'VAR_NAME' OR 'VarName'.
          ls_srv_in-var_name = lr_name_value_line->value.
        WHEN 'VAR_NUMB' OR 'VarNumb'.
          ls_srv_in-var_numb = lr_name_value_line->value.
        WHEN OTHERS.

      ENDCASE.
    ENDLOOP.

    SELECT * FROM ztwa001_varval
        INTO TABLE lt_var_val
        WHERE var_name = ls_srv_in-var_name
          AND var_numb = ls_srv_in-var_numb
          .

    MOVE-CORRESPONDING VALUE #( lt_var_val[ 1 ] OPTIONAL ) TO er_entity .

  ENDMETHOD.


  METHOD varvalueset_get_entityset .
*    importing
*      !IV_ENTITY_NAME type STRING
*      !IV_ENTITY_SET_NAME type STRING
*      !IV_SOURCE_NAME type STRING
*      !IT_FILTER_SELECT_OPTIONS type /IWBEP/T_MGW_SELECT_OPTION
*      !IS_PAGING type /IWBEP/S_MGW_PAGING
*      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
*      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
*      !IT_ORDER type /IWBEP/T_MGW_SORTING_ORDER
*      !IV_FILTER_STRING type STRING
*      !IV_SEARCH_STRING type STRING
*      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITYSET optional
*    exporting
*      !ET_ENTITYSET type ZCL_ZWEB_ABAP_DEMO1_MPC=>TT_VARVALUE
*      !ES_RESPONSE_CONTEXT type /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_CONTEXT
*    raising
*      /IWBEP/CX_MGW_BUSI_EXCEPTION
*      /IWBEP/CX_MGW_TECH_EXCEPTION .

    DATA lt_var_val TYPE ztwa001_varval_tab.

    CASE iv_source_name.

      WHEN 'VarHead'.
        DATA ls_var_val_in TYPE ztwa001_varval.
        DATA lr_name_value_line TYPE REF TO /iwbep/s_mgw_name_value_pair.
        LOOP AT it_key_tab REFERENCE INTO lr_name_value_line.
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
          UP TO 1000 ROWS
          ORDER BY PRIMARY KEY.
    ENDCASE.





    MOVE-CORRESPONDING lt_var_val TO et_entityset.
    es_response_context-count = lines( et_entityset ).

  ENDMETHOD.


  METHOD varvalueset_update_entity  .
*    importing
*      !IV_ENTITY_NAME type STRING
*      !IV_ENTITY_SET_NAME type STRING
*      !IV_SOURCE_NAME type STRING
*      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
*      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_U optional
*      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
*      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER optional
*    exporting
*      !ER_ENTITY type ZCL_ZWEB_ABAP_DEMO1_MPC=>TS_VARVALUE
*    raising
*      /IWBEP/CX_MGW_BUSI_EXCEPTION
*      /IWBEP/CX_MGW_TECH_EXCEPTION .
    DATA ls_srv_in TYPE zcl_zweb_abap_demo1_mpc=>ts_varvalue.

    io_data_provider->read_entry_data( IMPORTING  es_data = ls_srv_in  ).

    MOVE-CORRESPONDING ls_srv_in TO er_entity.
  ENDMETHOD.
ENDCLASS.
