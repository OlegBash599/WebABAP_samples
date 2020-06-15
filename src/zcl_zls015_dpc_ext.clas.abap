class ZCL_ZLS015_DPC_EXT definition
  public
  inheriting from ZCL_ZLS015_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_DEEP_ENTITY
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~EXECUTE_ACTION
    redefinition .
  methods /IWBEP/IF_MGW_CORE_SRV_RUNTIME~CHANGESET_BEGIN
    redefinition .
  methods /IWBEP/IF_MGW_CORE_SRV_RUNTIME~CHANGESET_END
    redefinition .
  methods /IWBEP/IF_MGW_CORE_SRV_RUNTIME~CHANGESET_PROCESS
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_EXPANDED_ENTITYSET
    redefinition .
protected section.

  methods VARIABLEIDSET_CREATE_ENTITY
    redefinition .
  methods VARIABLEIDSET_DELETE_ENTITY
    redefinition .
  methods VARIABLEIDSET_GET_ENTITY
    redefinition .
  methods VARIABLEIDSET_GET_ENTITYSET
    redefinition .
  methods VARIABLEIDSET_UPDATE_ENTITY
    redefinition .
  methods VARIABLEVALUESET_GET_ENTITY
    redefinition .
  methods VARIABLEVALUESET_GET_ENTITYSET
    redefinition .
  PRIVATE SECTION.
    DATA mt_varid TYPE STANDARD TABLE OF ztls015_varid.
    DATA mt_varval TYPE STANDARD TABLE OF ztls015_varval.

ENDCLASS.



CLASS ZCL_ZLS015_DPC_EXT IMPLEMENTATION.


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

    TYPES: BEGIN OF ts_deep_entity.
                INCLUDE TYPE  zcl_zls015_mpc=>ts_variableid.
    TYPES: variablevalueset TYPE STANDARD TABLE OF zcl_zls015_mpc=>ts_variablevalue WITH DEFAULT KEY
           , END OF ts_deep_entity
           .
    DATA ls_deep_entity TYPE ts_deep_entity.
    DATA ls_new_var_id TYPE zcl_zls015_mpc=>ts_variableid.
    DATA lt_new_var_id TYPE STANDARD TABLE OF ztls015_varid.
    DATA lt_old_var_id TYPE STANDARD TABLE OF ztls015_varid.
    DATA lt_new_var_val TYPE  zcl_zls015_mpc=>tt_variablevalue.

    io_data_provider->read_entry_data(
      IMPORTING
        es_data = ls_deep_entity
    ).
*    CATCH /iwbep/cx_mgw_tech_exception. " Technical Exception




    MOVE-CORRESPONDING ls_deep_entity TO ls_new_var_id.
    lt_new_var_val[] = ls_deep_entity-variablevalueset[].
    LOOP AT lt_new_var_val ASSIGNING FIELD-SYMBOL(<fs_new_var>).
      <fs_new_var>-name = ls_deep_entity-name.
      <fs_new_var>-numb = sy-tabix.
    ENDLOOP.

*    CATCH /iwbep/cx_mgw_tech_exception. " Technical Exception

    IF ls_new_var_id IS INITIAL.
      RETURN.
    ENDIF.

    ls_deep_entity-crd =
    ls_new_var_id-crd = sy-datum.
    ls_deep_entity-crt =
    ls_new_var_id-crt = sy-uzeit.
    ls_deep_entity-cru =
    ls_new_var_id-cru = cl_abap_syst=>get_user_name( ).
    ls_deep_entity-chd =
    ls_new_var_id-chd = sy-datum.
    ls_deep_entity-cht =
    ls_new_var_id-cht = sy-uzeit.
    ls_deep_entity-chu =
    ls_new_var_id-chu = cl_abap_syst=>get_user_name( ).




    APPEND ls_new_var_id TO lt_new_var_id.


    SELECT * FROM ztls015_varid
      INTO TABLE lt_old_var_id
      WHERE name = ls_deep_entity-name
      .
    IF sy-subrc EQ 0.
      " запись уже существует
      DATA lv_msg TYPE string.
      MESSAGE e000(cl) WITH `запись уже существует` ls_new_var_id-name INTO lv_msg.
      mo_context->get_message_container( )->add_message(
        EXPORTING
          iv_msg_type               = sy-msgty                 " Message Type
          iv_msg_id                 = sy-msgid                 " Message Class
          iv_msg_number             = sy-msgno                 " Message Number
          iv_msg_text               = CONV #( lv_msg )                 " Message Text
          iv_msg_v1                 = sy-msgv1                 " Message Variable
          iv_msg_v2                 = sy-msgv2                  " Message Variable
          iv_msg_v3                 = sy-msgv3                  " Message Variable
          iv_msg_v4                 = sy-msgv4                  " Message Variable
*            iv_error_category         =                  " Error Category
*            iv_is_leading_message     = abap_true
            iv_entity_type            = iv_entity_name                 " Entity type/name
            it_key_tab                =  it_key_tab                " Entity key as name-value pair
*            iv_add_to_response_header = abap_false       " Flag for adding or not the message to the response header
*            iv_message_target         =                  " Target (reference) (e.g. Property ID) of a message
      ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid            = /iwbep/cx_mgw_busi_exception=>business_error
*         previous          =
          message_container = mo_context->get_message_container( )
*         http_status_code  = gcs_http_status_codes-bad_request
*         http_header_parameters =
*         sap_note_id       =
*         msg_code          =
*         entity_type       =
*         message           =
*         message_unlimited =
*         filter_param      =
*         operation_no      =
        .


    ENDIF.


    MODIFY ztls015_varid FROM TABLE lt_new_var_id.
    MODIFY ztls015_varval FROM TABLE lt_new_var_val.
    COMMIT WORK AND WAIT.

    "    MOVE-CORRESPONDING VALUE #( lt_new_var_id[ 1 ] OPTIONAL ) TO er_entity.

    MOVE-CORRESPONDING VALUE #( lt_new_var_id[ 1 ] OPTIONAL ) TO ls_deep_entity.
    ls_deep_entity-variablevalueset[] = lt_new_var_val[].


    copy_data_to_ref(
      EXPORTING
        is_data = ls_deep_entity
      CHANGING
        cr_data = er_deep_entity
    ).



  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~execute_action.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~EXECUTE_ACTION
**  EXPORTING
**    iv_action_name          =
**    it_parameter            =
**    io_tech_request_context =
**  IMPORTING
**    er_data                 =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.

    DATA lo_do_email_with_excel TYPE REF TO zcl_lsp015_email_with_excel.
    DATA lv_email TYPE ad_smtpadr.
    DATA lr_parameter TYPE REF TO /iwbep/s_mgw_name_value_pair.

    CASE iv_action_name.
      WHEN 'SendEmailWithExcelVars'.
        LOOP AT it_parameter REFERENCE INTO lr_parameter.
          lv_email = lr_parameter->value.
        ENDLOOP.

        IF lv_email IS INITIAL.
          RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
            EXPORTING
              textid = /iwbep/cx_mgw_busi_exception=>business_error
*             previous               =
*             message_container      =
*             http_status_code       = gcs_http_status_codes-bad_request
*             http_header_parameters =
*             sap_note_id            =
*             msg_code               =
*             entity_type            =
*             message                =
*             message_unlimited      =
*             filter_param           =
*             operation_no           =
            .
        ENDIF.

        SELECT * FROM ztls015_varid
          UP TO 100 ROWS
          INTO TABLE @DATA(lt_var100)
          .

        lo_do_email_with_excel = NEW #( lv_email ).
        lo_do_email_with_excel->main( ).

        copy_data_to_ref(
          EXPORTING
            is_data = lt_var100
          CHANGING
            cr_data = er_data
        ).

      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.


  method /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_EXPANDED_ENTITYSET.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_EXPANDED_ENTITYSET
**  EXPORTING
**    iv_entity_name           =
**    iv_entity_set_name       =
**    iv_source_name           =
**    it_filter_select_options =
**    it_order                 =
**    is_paging                =
**    it_navigation_path       =
**    it_key_tab               =
**    iv_filter_string         =
**    iv_search_string         =
**    io_expand                =
**    io_tech_request_context  =
**  IMPORTING
**    er_entityset             =
**    et_expanded_clauses      =
**    et_expanded_tech_clauses =
**    es_response_context      =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.


    DATA lt_var_val TYPE STANDARD TABLE OF ztls015_varval.
    DATA lr_varval TYPE REF TO ztls015_varval.

    IF iv_entity_name EQ 'VariableID'
  AND iv_source_name EQ 'VariableID'.

      CLEAR mt_varid.
      CLEAR mt_varval.

      SELECT * FROM ztls015_varid
        UP TO 1000 ROWS
        INTO TABLE mt_varid.


      SELECT * FROM ztls015_varval
        UP TO 5000 ROWS
        INTO TABLE mt_varval.

      copy_data_to_ref(
        EXPORTING
          is_data = mt_varid
        CHANGING
          cr_data = er_entityset
      ).


    ENDIF.

    IF iv_entity_name EQ 'VariableValue'
  AND iv_source_name EQ 'VariableID'.


      """" показать вызов метода по ключу, когда часть вызывается, а часть нет и таблица может быть пустая
      ""
      "" /sap/opu/odata/SAP/ZLS015_SRV/VariableIDSet('ZTEST_FI_RANGE1')?$expand=VariableValueSet
      ""
      ""
      IF mt_varval IS INITIAL.
        SELECT * FROM ztls015_varval
        UP TO 5000 ROWS
        INTO TABLE mt_varval.
      ENDIF.

      " уже читаем из внутренней памяти, а не из БД
      LOOP AT mt_varval REFERENCE INTO lr_varval WHERE name = VALUE #( it_key_tab[ 1 ]-value OPTIONAL ).
        APPEND lr_varval->* TO lt_var_val.
      ENDLOOP.

      copy_data_to_ref(
       EXPORTING
         is_data = lt_var_val
       CHANGING
         cr_data = er_entityset
     ).

    ENDIF.

  endmethod.


  method /IWBEP/IF_MGW_CORE_SRV_RUNTIME~CHANGESET_BEGIN.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_CORE_SRV_RUNTIME~CHANGESET_BEGIN
*  EXPORTING
*    IT_OPERATION_INFO  =
**    it_changeset_input =
**  CHANGING
**    cv_defer_mode      =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.




  endmethod.


  method /IWBEP/IF_MGW_CORE_SRV_RUNTIME~CHANGESET_END.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_CORE_SRV_RUNTIME~CHANGESET_END
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.


  endmethod.


  method /IWBEP/IF_MGW_CORE_SRV_RUNTIME~CHANGESET_PROCESS.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_CORE_SRV_RUNTIME~CHANGESET_PROCESS
*  CHANGING
*    CT_CHANGESET_DATA =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.



  endmethod.


  METHOD variableidset_create_entity.
**TRY.
*CALL METHOD SUPER->VARIABLEIDSET_CREATE_ENTITY
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

    DATA ls_new_var_id TYPE zcl_zls015_mpc=>ts_variableid.
    DATA lt_new_var_id TYPE STANDARD TABLE OF ztls015_varid.
    DATA lt_old_var_id TYPE STANDARD TABLE OF ztls015_varid.

    io_data_provider->read_entry_data(
      IMPORTING
        es_data = ls_new_var_id
    ).
*    CATCH /iwbep/cx_mgw_tech_exception. " Technical Exception

    IF ls_new_var_id IS INITIAL.
      RETURN.
    ENDIF.

    ls_new_var_id-crd = sy-datum.
    ls_new_var_id-crt = sy-uzeit.
    ls_new_var_id-cru = cl_abap_syst=>get_user_name( ).
    ls_new_var_id-chd = sy-datum.
    ls_new_var_id-cht = sy-uzeit.
    ls_new_var_id-chu = cl_abap_syst=>get_user_name( ).

    APPEND ls_new_var_id TO lt_new_var_id.


    SELECT * FROM ztls015_varid
      INTO TABLE lt_old_var_id
      WHERE name = ls_new_var_id-name.
    IF sy-subrc EQ 0.
      " запись уже существует
      DATA lv_msg TYPE string.
      MESSAGE e000(cl) WITH `запись уже существует` ls_new_var_id-name INTO lv_msg.
      mo_context->get_message_container( )->add_message(
        EXPORTING
          iv_msg_type               = sy-msgty                 " Message Type
          iv_msg_id                 = sy-msgid                 " Message Class
          iv_msg_number             = sy-msgno                 " Message Number
          iv_msg_text               = CONV #( lv_msg )                 " Message Text
          iv_msg_v1                 = sy-msgv1                 " Message Variable
          iv_msg_v2                 = sy-msgv2                  " Message Variable
          iv_msg_v3                 = sy-msgv3                  " Message Variable
          iv_msg_v4                 = sy-msgv4                  " Message Variable
*            iv_error_category         =                  " Error Category
*            iv_is_leading_message     = abap_true
            iv_entity_type            = iv_entity_name                 " Entity type/name
            it_key_tab                =  it_key_tab                " Entity key as name-value pair
*            iv_add_to_response_header = abap_false       " Flag for adding or not the message to the response header
*            iv_message_target         =                  " Target (reference) (e.g. Property ID) of a message
      ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid            = /iwbep/cx_mgw_busi_exception=>business_error
*         previous          =
          message_container = mo_context->get_message_container( )
*         http_status_code  = gcs_http_status_codes-bad_request
*         http_header_parameters =
*         sap_note_id       =
*         msg_code          =
*         entity_type       =
*         message           =
*         message_unlimited =
*         filter_param      =
*         operation_no      =
        .


    ENDIF.


    MODIFY ztls015_varid FROM TABLE lt_new_var_id.
    COMMIT WORK AND WAIT.

    MOVE-CORRESPONDING VALUE #( lt_new_var_id[ 1 ] OPTIONAL ) TO er_entity.


  ENDMETHOD.


  METHOD variableidset_delete_entity.

**TRY.
*CALL METHOD SUPER->VARIABLEIDSET_UPDATE_ENTITY
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



    DATA ls_new_var_id TYPE zcl_zls015_mpc=>ts_variableid.
    DATA ls_old_var_id TYPE zcl_zls015_mpc=>ts_variableid.
    DATA lt_new_var_id TYPE STANDARD TABLE OF ztls015_varid.
    DATA lt_old_var_id TYPE STANDARD TABLE OF ztls015_varid.
    DATA lr_key_line TYPE REF TO /iwbep/s_mgw_name_value_pair.


    LOOP AT it_key_tab REFERENCE INTO lr_key_line.
      CASE lr_key_line->name.
        WHEN 'Name'.
          ls_new_var_id-name = lr_key_line->value.

        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.


    IF ls_new_var_id IS INITIAL.
      RETURN.
    ENDIF.



    SELECT * FROM ztls015_varid
      INTO TABLE lt_old_var_id
      WHERE name = ls_new_var_id-name.
    IF sy-subrc NE 0.
      " запись не существует
      DATA lv_msg TYPE string.
      MESSAGE e000(cl) WITH `запись НЕ существует` ls_new_var_id-name INTO lv_msg.
      mo_context->get_message_container( )->add_message(
        EXPORTING
          iv_msg_type               = sy-msgty                 " Message Type
          iv_msg_id                 = sy-msgid                 " Message Class
          iv_msg_number             = sy-msgno                 " Message Number
          iv_msg_text               = CONV #( lv_msg )                 " Message Text
          iv_msg_v1                 = sy-msgv1                 " Message Variable
          iv_msg_v2                 = sy-msgv2                  " Message Variable
          iv_msg_v3                 = sy-msgv3                  " Message Variable
          iv_msg_v4                 = sy-msgv4                  " Message Variable
*            iv_error_category         =                  " Error Category
*            iv_is_leading_message     = abap_true
            iv_entity_type            = iv_entity_name                 " Entity type/name
            it_key_tab                =  it_key_tab                " Entity key as name-value pair
*            iv_add_to_response_header = abap_false       " Flag for adding or not the message to the response header
*            iv_message_target         =                  " Target (reference) (e.g. Property ID) of a message
      ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid            = /iwbep/cx_mgw_busi_exception=>business_error
*         previous          =
          message_container = mo_context->get_message_container( )
*         http_status_code  = gcs_http_status_codes-bad_request
*         http_header_parameters =
*         sap_note_id       =
*         msg_code          =
*         entity_type       =
*         message           =
*         message_unlimited =
*         filter_param      =
*         operation_no      =
        .
    ELSE.
      ls_old_var_id = VALUE #( lt_old_var_id[ 1 ] OPTIONAL ).

      " определяем, что можно менять, а что нет

      ls_new_var_id-crd = ls_old_var_id-crd.
      ls_new_var_id-crt = ls_old_var_id-crt.
      ls_new_var_id-cru = ls_old_var_id-cru.
      ls_new_var_id-chd = sy-datum.
      ls_new_var_id-cht = sy-uzeit.
      ls_new_var_id-chu = cl_abap_syst=>get_user_name( ).

      APPEND ls_new_var_id TO lt_new_var_id.

    ENDIF.


    DELETE ztls015_varid FROM TABLE lt_new_var_id.
    COMMIT WORK AND WAIT.


  ENDMETHOD.


  METHOD variableidset_get_entity.
**TRY.
*CALL METHOD SUPER->VARIABLEIDSET_GET_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_request_object       =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**  IMPORTING
**    er_entity               =
**    es_response_context     =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.

    DATA lt_valid_sel_by_key TYPE STANDARD TABLE OF ztls015_varid.
    DATA ls_valid TYPE ztls015_varid.
    DATA lr_key_line TYPE REF TO /iwbep/s_mgw_name_value_pair.

    LOOP AT it_key_tab REFERENCE INTO lr_key_line.
      CASE lr_key_line->name.
        WHEN 'Name'.
          ls_valid-name = lr_key_line->value.
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.


    IF ls_valid IS INITIAL.
      es_response_context-no_content = abap_true.
      RETURN.
    ENDIF.

    SELECT * FROM ztls015_varid
      INTO TABLE lt_valid_sel_by_key
      WHERE name = ls_valid-name.
    IF sy-subrc EQ 0.
      er_entity = VALUE #( lt_valid_sel_by_key[ 1 ] OPTIONAL ).
    ELSE.
      es_response_context-no_content = abap_true.
    ENDIF.


  ENDMETHOD.


  METHOD variableidset_get_entityset.
**TRY.
*CALL METHOD SUPER->VARIABLEIDSET_GET_ENTITYSET
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


    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*""" step1 - simple
*    DATA lt_varid TYPE STANDARD TABLE OF ztls015_varid.
*
*
*    SELECT * FROM ztls015_varid
*        INTO TABLE lt_varid
*      UP TO 1000 ROWS.
*
*    et_entityset[] = lt_varid[].
*
*""" step1 - simple
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*""" step2 - $select option - select specific fields
***    DATA lt_varid TYPE STANDARD TABLE OF ztls015_varid.
***    DATA lt_select TYPE /iwbep/t_mgw_tech_field_names.
***    DATA lr_field_name TYPE REF TO fieldname.
***    DATA lv_fields_to_select TYPE string.
***
***    lt_select = io_tech_request_context->get_select( ). """ <<<<< с помощью этого метода получаем нужный список
***
***    LOOP AT lt_select REFERENCE INTO lr_field_name.
***      lv_fields_to_select = lv_fields_to_select && ` ` && lr_field_name->*.
***    ENDLOOP.
***    IF sy-subrc NE 0.
***      lv_fields_to_select = `*`.
***    ENDIF.
***
***    SELECT (lv_fields_to_select) FROM ztls015_varid
***        INTO CORRESPONDING FIELDS OF TABLE lt_varid
***      UP TO 1000 ROWS.
***
***    et_entityset[] = lt_varid[].
*
*""" step2 - simple
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*""" {step3 - $filter option - select specific fields
***    DATA lt_varid TYPE STANDARD TABLE OF ztls015_varid.
***    DATA lt_filter_select_options TYPE /iwbep/t_mgw_select_option.
***    DATA lr_filter_sel_option TYPE REF TO /iwbep/s_mgw_select_option.
***    DATA lr_sel_opt_line_common TYPE REF TO /iwbep/s_cod_select_option.
***    DATA lr_field_name TYPE REF TO fieldname.
***
***    DATA lt_range_var_type TYPE RANGE OF zels015_varid_type.
***    DATA lt_range_description TYPE RANGE OF zels015_varid_descr.
***
***    DATA lv_fields_to_select TYPE string.
***    DATA lv_do_normal_options_sel TYPE char1 VALUE abap_true.
***
***    " способ1 { через класс
***    lt_filter_select_options = io_tech_request_context->get_filter( )->get_filter_select_options( ).
***
***    LOOP AT lt_filter_select_options REFERENCE INTO lr_filter_sel_option.
***      CASE lr_filter_sel_option->property.
***        WHEN 'VAR_TYPE'.
***          CLEAR lt_range_var_type.
***          LOOP AT lr_filter_sel_option->select_options REFERENCE INTO lr_sel_opt_line_common.
***            APPEND INITIAL LINE TO lt_range_var_type ASSIGNING FIELD-SYMBOL(<fs_var_type>).
***            MOVE-CORRESPONDING lr_sel_opt_line_common->* TO <fs_var_type>.
***          ENDLOOP.
***        WHEN OTHERS.
***      ENDCASE.
***    ENDLOOP.
***    " способ1 }
***
***    " способ2{ - через прямый параметры
***    LOOP AT it_filter_select_options REFERENCE INTO lr_filter_sel_option.
***      CASE lr_filter_sel_option->property.
***        WHEN 'Description'.
***          CLEAR lt_range_description.
***          LOOP AT lr_filter_sel_option->select_options REFERENCE INTO lr_sel_opt_line_common.
***            APPEND INITIAL LINE TO lt_range_description ASSIGNING FIELD-SYMBOL(<fs_description>).
***            MOVE-CORRESPONDING lr_sel_opt_line_common->* TO <fs_description>.
***          ENDLOOP.
***        WHEN OTHERS.
***      ENDCASE.
***    ENDLOOP.
***    " способ2}
***
***
***    "" способ3 - парсинг IV_FILTER_STRING{
***    IF iv_filter_string IS NOT INITIAL AND it_filter_select_options[] IS INITIAL.
***
***      "" уже не совсем проработанный парсинг
***      lv_do_normal_options_sel = abap_false.
***
***      CLEAR lt_varid.
***      IF iv_filter_string CS '( VarType eq ''2'' )'.
***        lt_range_var_type = VALUE #(
***        ( sign = 'I' option = 'EQ' low = '2' high = '' )
***        ).
***
***        SELECT * FROM ztls015_varid
***        APPENDING CORRESPONDING FIELDS OF TABLE lt_varid
***        WHERE var_type IN lt_range_var_type
***        .
***
***      ENDIF.
***
***      IF iv_filter_string CS '( substringof ( ''FI'' , Description )'.
***        lt_range_description = VALUE #(
***        ( sign = 'I' option = 'CP' low = '*FI*' high = '' )
***        ).
***
***        SELECT * FROM ztls015_varid
***        APPENDING CORRESPONDING FIELDS OF TABLE lt_varid
***        WHERE description IN lt_range_description
***        .
***
***      ENDIF.
***
***    ELSE.
***
***    ENDIF.
***
***    "" способ3 - парсинг IV_FILTER_STRING}
***
***
***    IF lv_do_normal_options_sel EQ abap_true.
***      SELECT * FROM ztls015_varid
***        INTO CORRESPONDING FIELDS OF TABLE lt_varid
***      WHERE var_type IN lt_range_var_type
***        AND description IN lt_range_description
***      .
***    ELSE.
***
***    ENDIF.
***
***
***    et_entityset[] = lt_varid[].
***    IF et_entityset[] IS INITIAL.
***      es_response_context-count = 0.
***    ENDIF.
*******
*""" step3}
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*""" {step4 - client side paging: options $top, $skip, $inlinecount

 "    https://help.sap.com/doc/abapdocu_752_index_htm/7.52/en-US/abapselect_up_to_offset.htm
    DATA lt_varid TYPE STANDARD TABLE OF ztls015_varid.


    IF it_order IS NOT INITIAL.
      SELECT * FROM ztls015_varid
      ORDER BY description, var_type
      INTO TABLE @lt_varid
      OFFSET @is_paging-skip
      UP TO @is_paging-top ROWS
      .
    ELSE.
      SELECT * FROM ztls015_varid
    ORDER BY PRIMARY KEY
    INTO TABLE @lt_varid
    OFFSET @is_paging-skip
    UP TO @is_paging-top ROWS
    .
    ENDIF.




    IF io_tech_request_context->has_inlinecount( ) EQ abap_true.
      "  es_response_context-inlinecount = lines( lt_varid ).
      DATA lv_count_all_pages TYPE syindex.
      SELECT COUNT(*) FROM ztls015_varid
        INTO lv_count_all_pages.
      es_response_context-inlinecount = lv_count_all_pages.
    ENDIF.

    DATA lr_order_by_option TYPE REF TO /iwbep/s_mgw_sorting_order.

    LOOP AT it_order REFERENCE INTO lr_order_by_option .
      CASE lr_order_by_option->property.
        WHEN 'Description'.
          IF lr_order_by_option->order EQ 'desc'.
            SORT lt_varid BY description DESCENDING.
          ELSE.
            SORT lt_varid BY description ASCENDING.
          ENDIF.
        WHEN 'VarType'.
          IF lr_order_by_option->order EQ 'desc'.
            SORT lt_varid BY var_type DESCENDING.
          ELSE.
            SORT lt_varid BY var_type ASCENDING.
          ENDIF.
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.


    et_entityset[] = lt_varid[].
*""" step4}
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


  ENDMETHOD.


  METHOD variableidset_update_entity.
**TRY.
*CALL METHOD SUPER->VARIABLEIDSET_UPDATE_ENTITY
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



    DATA ls_new_var_id TYPE zcl_zls015_mpc=>ts_variableid.
    DATA ls_old_var_id TYPE zcl_zls015_mpc=>ts_variableid.
    DATA lt_new_var_id TYPE STANDARD TABLE OF ztls015_varid.
    DATA lt_old_var_id TYPE STANDARD TABLE OF ztls015_varid.

    io_data_provider->read_entry_data(
      IMPORTING
        es_data = ls_new_var_id
    ).
*    CATCH /iwbep/cx_mgw_tech_exception. " Technical Exception

    IF ls_new_var_id IS INITIAL.
      RETURN.
    ENDIF.



    SELECT * FROM ztls015_varid
      INTO TABLE lt_old_var_id
      WHERE name = ls_new_var_id-name.
    IF sy-subrc NE 0.
      " запись не существует
      DATA lv_msg TYPE string.
      MESSAGE e000(cl) WITH `запись НЕ существует` ls_new_var_id-name INTO lv_msg.
      mo_context->get_message_container( )->add_message(
        EXPORTING
          iv_msg_type               = sy-msgty                 " Message Type
          iv_msg_id                 = sy-msgid                 " Message Class
          iv_msg_number             = sy-msgno                 " Message Number
          iv_msg_text               = CONV #( lv_msg )                 " Message Text
          iv_msg_v1                 = sy-msgv1                 " Message Variable
          iv_msg_v2                 = sy-msgv2                  " Message Variable
          iv_msg_v3                 = sy-msgv3                  " Message Variable
          iv_msg_v4                 = sy-msgv4                  " Message Variable
*            iv_error_category         =                  " Error Category
*            iv_is_leading_message     = abap_true
            iv_entity_type            = iv_entity_name                 " Entity type/name
            it_key_tab                =  it_key_tab                " Entity key as name-value pair
*            iv_add_to_response_header = abap_false       " Flag for adding or not the message to the response header
*            iv_message_target         =                  " Target (reference) (e.g. Property ID) of a message
      ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid            = /iwbep/cx_mgw_busi_exception=>business_error
*         previous          =
          message_container = mo_context->get_message_container( )
*         http_status_code  = gcs_http_status_codes-bad_request
*         http_header_parameters =
*         sap_note_id       =
*         msg_code          =
*         entity_type       =
*         message           =
*         message_unlimited =
*         filter_param      =
*         operation_no      =
        .
    ELSE.
      ls_old_var_id = VALUE #( lt_old_var_id[ 1 ] OPTIONAL ).

      " определяем, что можно менять, а что нет

      ls_new_var_id-crd = ls_old_var_id-crd.
      ls_new_var_id-crt = ls_old_var_id-crt.
      ls_new_var_id-cru = ls_old_var_id-cru.
      ls_new_var_id-chd = sy-datum.
      ls_new_var_id-cht = sy-uzeit.
      ls_new_var_id-chu = cl_abap_syst=>get_user_name( ).

      APPEND ls_new_var_id TO lt_new_var_id.

    ENDIF.


    MODIFY ztls015_varid FROM TABLE lt_new_var_id.
    COMMIT WORK AND WAIT.

    MOVE-CORRESPONDING VALUE #( lt_new_var_id[ 1 ] OPTIONAL ) TO er_entity.

  ENDMETHOD.


  METHOD variablevalueset_get_entity.
**TRY.
*CALL METHOD SUPER->VARIABLEVALUESET_GET_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_request_object       =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**  IMPORTING
**    er_entity               =
**    es_response_context     =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.



    DATA lt_var_val TYPE STANDARD TABLE OF ztls015_varval.
    DATA ls_var_val TYPE ztls015_varval.
    DATA lr_key_line TYPE REF TO /iwbep/s_mgw_name_value_pair.

    LOOP AT it_key_tab REFERENCE INTO lr_key_line.
      CASE lr_key_line->name.
        WHEN 'Name'.
          ls_var_val-name = lr_key_line->value.
        WHEN 'Numb'.
          ls_var_val-numb = lr_key_line->value.
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.

    SELECT * FROM ztls015_varval
      UP TO 10000 ROWS
      INTO TABLE lt_var_val
      WHERE name = ls_var_val-name
        AND numb = ls_var_val-numb
      .


    er_entity = VALUE #( lt_var_val[ 1 ] OPTIONAL ).
    IF er_entity IS INITIAL.
      es_response_context-no_content = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD variablevalueset_get_entityset.
**TRY.
*CALL METHOD SUPER->VARIABLEVALUESET_GET_ENTITYSET
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

    DATA lt_var_val TYPE STANDARD TABLE OF ztls015_varval.
    DATA ls_var_val TYPE ztls015_varval.
    DATA lr_key_line TYPE REF TO /iwbep/s_mgw_name_value_pair.


    " способ 1 - различить{
    IF it_key_tab[] IS INITIAL.

      SELECT * FROM ztls015_varval
        INTO TABLE lt_var_val
        UP TO 10000 ROWS.
    ELSE.
      LOOP AT it_key_tab REFERENCE INTO lr_key_line.
        CASE lr_key_line->name.
          WHEN 'Name'.
            ls_var_val-name = lr_key_line->value.
          WHEN 'Numb'.
            ls_var_val-numb = lr_key_line->value.
          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.


      SELECT * FROM ztls015_varval
        UP TO 10000 ROWS
        INTO TABLE lt_var_val
        WHERE name = ls_var_val-name
        .


    ENDIF.
    """""""""}}}}}


    " способ 2 - различить{
*    IF iv_source_name EQ 'VariableValue'. " обычный запрос
*      SELECT * FROM ztls015_varval
*              INTO TABLE lt_var_val
*              UP TO 10000 ROWS.
*    ELSE.
*      "" IV_SOURCE_NAME eq 'VariableID'. " запрос через навигацию
*      LOOP AT it_key_tab REFERENCE INTO lr_key_line.
*        CASE lr_key_line->name.
*          WHEN 'Name'.
*            ls_var_val-name = lr_key_line->value.
*          WHEN OTHERS.
*        ENDCASE.
*      ENDLOOP.
*
*
*      SELECT * FROM ztls015_varval
*        UP TO 10000 ROWS
*        INTO TABLE lt_var_val
*        WHERE name = ls_var_val-name
*        .
*    ENDIF.
    " способ 2 - различить навигацию от обычного запроса}



    et_entityset[] = lt_var_val[].
    IF et_entityset[] IS INITIAL.
      es_response_context-count = 0.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
