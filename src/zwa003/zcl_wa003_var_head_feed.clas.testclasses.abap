*"* use this source file for your ABAP unit test classes
CLASS ltc_get_entity_set DEFINITION DEFERRED.
CLASS zcl_wa003_var_head_feed DEFINITION LOCAL FRIENDS ltc_get_entity_set.
CLASS ltc_get_entity_set DEFINITION FOR TESTING
    RISK LEVEL HARMLESS
    DURATION SHORT
    INHERITING FROM cl_aunit_assert.

  PUBLIC SECTION.
    METHODS read_no_filter FOR TESTING.
    METHODS read_no_filter_with_odata_dbl FOR TESTING.
    METHODS read_entry_with_numfiles FOR TESTING.

  PROTECTED SECTION.

  PRIVATE SECTION.
    METHODS get_odata_double_with_filter3
      RETURNING VALUE(ro_obj) TYPE REF TO zif_wa003_odata_in.

    METHODS get_odata_double_with_filter4
      RETURNING VALUE(ro_obj) TYPE REF TO zif_wa003_odata_in.

    METHODS get_odata_double_with_filter5
      RETURNING VALUE(ro_obj) TYPE REF TO zif_wa003_odata_in.

    METHODS prepare_filter_sep.
ENDCLASS.

CLASS ltc_get_entity_set IMPLEMENTATION.
  METHOD read_no_filter.
    RETURN.

    DATA lo_cut TYPE REF TO zcl_wa003_var_head_feed.
    CREATE OBJECT lo_cut.

    TRY.
        lo_cut->zif_wa003_entity_feeder~q(
*      IMPORTING
*        et_set              =
*        es_response_context =
        ).
      CATCH /iwbep/cx_mgw_busi_exception. " Business Exception
        fail(
          EXPORTING
            msg    = 'Business Exception: /iwbep/cx_mgw_busi_exception'                 " Error Message
*           level  = critical         " Error Severity
*           quit   = method           " Flow Control in Case of Error
*           detail =                  " Detailed Message
        ).
      CATCH /iwbep/cx_mgw_tech_exception. " Technical Exception
        fail(
      EXPORTING
        msg    = 'Business Exception: /iwbep/cx_mgw_tech_exception'                 " Error Message
*           level  = critical         " Error Severity
*           quit   = method           " Flow Control in Case of Error
*           detail =                  " Detailed Message
    ).
    ENDTRY.
  ENDMETHOD.

  METHOD read_no_filter_with_odata_dbl.
    DATA lo_cut TYPE REF TO zcl_wa003_var_head_feed.
    DATA lo_odata_in TYPE REF TO zif_wa003_odata_in.

    DATA lt_set TYPE zcl_zweb_abap_demo3_mpc=>tt_varh.
    DATA ls_response_context TYPE /iwbep/if_mgw_appl_srv_runtime=>ty_s_mgw_response_context.

    CREATE OBJECT lo_cut.

    TRY.
        lo_odata_in = get_odata_double_with_filter4(  ).
        lo_cut->zif_wa003_entity_feeder~set_odata_in( io_odata_in = lo_odata_in ).
        lo_cut->ms_sel_opt-var_type_rng = VALUE #( ( sign = 'I' option = 'EQ' low = '3' ) ).
        "prepare_filter_sep(  ).

        lo_cut->zif_wa003_entity_feeder~q( IMPORTING
        et_set              = lt_set
        es_response_context = ls_response_context ).

        LOOP AT lt_set TRANSPORTING NO FIELDS WHERE var_type NE '3'.
          fail(
            EXPORTING
              msg    = 'Фильтр на SWITCH не корректный'                 " Error Message
*                level  = critical         " Error Severity
*                quit   = method           " Flow Control in Case of Error
*                detail =                  " Detailed Message
          ).
        ENDLOOP.

      CATCH /iwbep/cx_mgw_busi_exception. " Business Exception
        fail(
          EXPORTING
            msg    = 'Business Exception: /iwbep/cx_mgw_busi_exception'                 " Error Message
*           level  = critical         " Error Severity
*           quit   = method           " Flow Control in Case of Error
*           detail =                  " Detailed Message
        ).
      CATCH /iwbep/cx_mgw_tech_exception. " Technical Exception
        fail(
      EXPORTING
        msg    = 'Business Exception: /iwbep/cx_mgw_tech_exception'                 " Error Message
*           level  = critical         " Error Severity
*           quit   = method           " Flow Control in Case of Error
*           detail =                  " Detailed Message
    ).
    ENDTRY.
  ENDMETHOD.

  METHOD get_odata_double_with_filter3.

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """ select options for returning (формируем значения фильтра)
    " а потом присвоим им значению для возврата через DOUBLE
    DATA lt_select_option_list TYPE /iwbep/t_mgw_select_option.
    FIELD-SYMBOLS <fs_select_property> TYPE /iwbep/s_mgw_select_option.
    FIELD-SYMBOLS <fs_select_option_line> TYPE /iwbep/s_cod_select_option.

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    APPEND INITIAL LINE TO lt_select_option_list ASSIGNING <fs_select_property>.
    <fs_select_property>-property = 'VAR_TYPE'.
    APPEND INITIAL LINE TO <fs_select_property>-select_options ASSIGNING <fs_select_option_line>.
    <fs_select_option_line>-sign = 'I'.
    <fs_select_option_line>-option = 'EQ'.
    <fs_select_option_line>-low = '3'.
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " req filter - класс-фильтр, который возвращает tech_context
    DATA lo_odata_req_filter TYPE REF TO /iwbep/if_mgw_req_filter.
    lo_odata_req_filter ?= cl_abap_testdouble=>create( '/IWBEP/IF_MGW_REQ_FILTER' ).
    cl_abap_testdouble=>configure_call( double = lo_odata_req_filter )->returning( value = lt_select_option_list ).
    lo_odata_req_filter->get_filter_select_options( ).
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " tech context, который приходит из OData
    " вызов фильтров из нескольких частей на текущий момент =
    DATA lo_tech_context_q TYPE REF TO /iwbep/if_mgw_req_entityset.
    lo_tech_context_q ?= cl_abap_testdouble=>create( '/IWBEP/IF_MGW_REQ_ENTITYSET' ).
    cl_abap_testdouble=>configure_call( double = lo_tech_context_q )->returning( value = lo_odata_req_filter ).
    lo_tech_context_q->get_filter( ).
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


    ro_obj ?= cl_abap_testdouble=>create( 'ZIF_WA003_ODATA_IN' ).
    cl_abap_testdouble=>configure_call( double = ro_obj )->returning( value = lo_tech_context_q ).
    ro_obj->get_tech_context_q(  ).
  ENDMETHOD.

  METHOD get_odata_double_with_filter4.
    DATA lt_select_option_list TYPE /iwbep/t_mgw_select_option.
    FIELD-SYMBOLS <fs_select_property> TYPE /iwbep/s_mgw_select_option.
    FIELD-SYMBOLS <fs_select_option_line> TYPE /iwbep/s_cod_select_option.

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    APPEND INITIAL LINE TO lt_select_option_list ASSIGNING <fs_select_property>.
    <fs_select_property>-property = 'NOT_EXIST'.
    APPEND INITIAL LINE TO <fs_select_property>-select_options ASSIGNING <fs_select_option_line>.
    <fs_select_option_line>-sign = 'I'.
    <fs_select_option_line>-option = 'EQ'.
    <fs_select_option_line>-low = '3'.
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " req filter - класс-фильтр, который возвращает tech_context
    DATA lo_odata_req_filter TYPE REF TO /iwbep/if_mgw_req_filter.
    lo_odata_req_filter ?= cl_abap_testdouble=>create( '/IWBEP/IF_MGW_REQ_FILTER' ).
    cl_abap_testdouble=>configure_call( double = lo_odata_req_filter )->returning( value = lt_select_option_list ).
    lo_odata_req_filter->get_filter_select_options( ).
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " tech context, который приходит из OData
    " вызов фильтров из нескольких частей на текущий момент =
    DATA lo_tech_context_q TYPE REF TO /iwbep/if_mgw_req_entityset.
    lo_tech_context_q ?= cl_abap_testdouble=>create( '/IWBEP/IF_MGW_REQ_ENTITYSET' ).
    cl_abap_testdouble=>configure_call( double = lo_tech_context_q )->returning( value = lo_odata_req_filter ).
    lo_tech_context_q->get_filter( ).
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


    ro_obj ?= cl_abap_testdouble=>create( 'ZIF_WA003_ODATA_IN' ).
    cl_abap_testdouble=>configure_call( double = ro_obj )->returning( value = lo_tech_context_q ).
    ro_obj->get_tech_context_q(  ).
  ENDMETHOD.

  METHOD prepare_filter_sep.
    "RETURNING VALUE(ro_obj) TYPE REF TO zif_wa003_odata_in.
*    DATA lt_property_rng TYPE zcl_wa003_odata2range=>tt_property_rng.
*    FIELD-SYMBOLS <fs_property_rng> TYPE zcl_wa003_odata2range=>ts_property_rng.
*    data lt_var_type_rng TYPE RANGE OF ZEWA001_VAR_TYPE.
*    FIELD-SYMBOLS <fs_var_type> like LINE OF lt_var_type_rng.
*
*    APPEND INITIAL LINE TO lt_var_type_rng ASSIGNING <fs_var_type>.
*    <fs_var_type> = 'IEQ3'.
*
*    APPEND INITIAL LINE TO lt_property_rng ASSIGNING <fs_property_rng>.
*    "<fs_property_rng>-prop_in = 'VAR_TYPE'.
*    <fs_property_rng>-prop_in = 'NOT_EXIST'.
*    GET REFERENCE OF lt_var_type_rng INTO <fs_property_rng>-range.
*
*
*    DATA lo_odata2range TYPE REF TO zcl_wa003_odata2range.
*    lo_odata2range ?= cl_abap_testdouble=>create( 'ZCL_WA003_ODATA2RANGE' ).
*    cl_abap_testdouble=>configure_call( double = lo_odata2range )->set_parameter(
*      EXPORTING
*        name          = 'CT_PROPERTY_RNG'
*        value         = lt_property_rng
**      RECEIVING
**        configuration =
*    ).
*    lo_odata2range->filter2sel_opt(
*      CHANGING
*        ct_property_rng = lt_property_rng
*    ).
*    CATCH /iwbep/cx_mgw_tech_exception. " Technical Exception
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

  ENDMETHOD.

  METHOD read_entry_with_numfiles.
    DATA lo_cut TYPE REF TO zcl_wa003_var_head_feed.
    DATA lo_odata_in TYPE REF TO zif_wa003_odata_in.

    DATA lt_set TYPE zcl_zweb_abap_demo3_mpc=>tt_varh.
    DATA ls_response_context TYPE /iwbep/if_mgw_appl_srv_runtime=>ty_s_mgw_response_context.

    CREATE OBJECT lo_cut.

    TRY.
        lo_odata_in = get_odata_double_with_filter5(  ).
        lo_cut->zif_wa003_entity_feeder~set_odata_in( io_odata_in = lo_odata_in ).
        lo_cut->ms_sel_opt-num_of_files_range = VALUE #( ( sign = 'I' option = 'EQ' low = '2' ) ).
        "prepare_filter_sep(  ).

        lo_cut->zif_wa003_entity_feeder~q( IMPORTING
        et_set              = lt_set
        es_response_context = ls_response_context ).



      CATCH /iwbep/cx_mgw_busi_exception. " Business Exception
        fail(
          EXPORTING
            msg    = 'Business Exception: /iwbep/cx_mgw_busi_exception'                 " Error Message
*           level  = critical         " Error Severity
*           quit   = method           " Flow Control in Case of Error
*           detail =                  " Detailed Message
        ).
      CATCH /iwbep/cx_mgw_tech_exception. " Technical Exception
        fail(
      EXPORTING
        msg    = 'Business Exception: /iwbep/cx_mgw_tech_exception'                 " Error Message
*           level  = critical         " Error Severity
*           quit   = method           " Flow Control in Case of Error
*           detail =                  " Detailed Message
    ).
    ENDTRY.
  ENDMETHOD.

  METHOD get_odata_double_with_filter5.
    "RETURNING VALUE(ro_obj) TYPE REF TO zif_wa003_odata_in.
    DATA lt_select_option_list TYPE /iwbep/t_mgw_select_option.
    FIELD-SYMBOLS <fs_select_property> TYPE /iwbep/s_mgw_select_option.
    FIELD-SYMBOLS <fs_select_option_line> TYPE /iwbep/s_cod_select_option.

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    APPEND INITIAL LINE TO lt_select_option_list ASSIGNING <fs_select_property>.
    <fs_select_property>-property = 'NUM_OF_FILES'.
    APPEND INITIAL LINE TO <fs_select_property>-select_options ASSIGNING <fs_select_option_line>.
    <fs_select_option_line>-sign = 'I'.
    <fs_select_option_line>-option = 'EQ'.
    <fs_select_option_line>-low = '2'.
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " req filter - класс-фильтр, который возвращает tech_context
    DATA lo_odata_req_filter TYPE REF TO /iwbep/if_mgw_req_filter.
    lo_odata_req_filter ?= cl_abap_testdouble=>create( '/IWBEP/IF_MGW_REQ_FILTER' ).
    cl_abap_testdouble=>configure_call( double = lo_odata_req_filter )->returning( value = lt_select_option_list ).
    lo_odata_req_filter->get_filter_select_options( ).
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " tech context, который приходит из OData
    " вызов фильтров из нескольких частей на текущий момент =
    DATA lo_tech_context_q TYPE REF TO /iwbep/if_mgw_req_entityset.
    lo_tech_context_q ?= cl_abap_testdouble=>create( '/IWBEP/IF_MGW_REQ_ENTITYSET' ).
    cl_abap_testdouble=>configure_call( double = lo_tech_context_q )->returning( value = lo_odata_req_filter ).
    lo_tech_context_q->get_filter( ).
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


    ro_obj ?= cl_abap_testdouble=>create( 'ZIF_WA003_ODATA_IN' ).
    cl_abap_testdouble=>configure_call( double = ro_obj )->returning( value = lo_tech_context_q ).
    ro_obj->get_tech_context_q(  ).
  ENDMETHOD.
ENDCLASS.



CLASS ltc_get_entity DEFINITION FOR TESTING
    RISK LEVEL HARMLESS
    DURATION SHORT
    INHERITING FROM cl_aunit_assert.

  PUBLIC SECTION.
    METHODS read_entry FOR TESTING.

  PROTECTED SECTION.

  PRIVATE SECTION.
    METHODS get_odata_double_v1
      RETURNING VALUE(ro_obj) TYPE REF TO zif_wa003_odata_in.
ENDCLASS.

CLASS ltc_get_entity IMPLEMENTATION.
  METHOD read_entry.
    DATA lo_cut TYPE REF TO zcl_wa003_var_head_feed.
    DATA lo_odata_in TYPE REF TO zif_wa003_odata_in.

    DATA ls_entry4response TYPE zcl_zweb_abap_demo3_mpc=>ts_varh.
    DATA ls_response_context TYPE /iwbep/if_mgw_appl_srv_runtime=>ty_s_mgw_response_context.


    CREATE OBJECT lo_cut.

    TRY.
        lo_odata_in = get_odata_double_v1(  ).
        lo_cut->zif_wa003_entity_feeder~set_odata_in( io_odata_in = lo_odata_in ).

        lo_cut->zif_wa003_entity_feeder~r( IMPORTING es = ls_entry4response  ).

      CATCH /iwbep/cx_mgw_busi_exception. " Business Exception
        fail(
          EXPORTING
            msg    = 'Business Exception read_entry: /iwbep/cx_mgw_busi_exception'                 " Error Message
*           level  = critical         " Error Severity
*           quit   = method           " Flow Control in Case of Error
*           detail =                  " Detailed Message
        ).
      CATCH /iwbep/cx_mgw_tech_exception. " Technical Exception
        fail(
      EXPORTING
        msg    = 'Business Exception read_entry: /iwbep/cx_mgw_tech_exception'                 " Error Message
*           level  = critical         " Error Severity
*           quit   = method           " Flow Control in Case of Error
*           detail =                  " Detailed Message
    ).
    ENDTRY.
  ENDMETHOD.

  METHOD get_odata_double_v1.
    DATA lt_key_tab TYPE /iwbep/t_mgw_name_value_pair.
    DATA ls_key_tab TYPE /iwbep/s_mgw_name_value_pair.

    ls_key_tab-name = 'VarName'.
    ls_key_tab-value = 'ZZZZ1'.
    APPEND ls_key_tab TO lt_key_tab.

    ro_obj ?= cl_abap_testdouble=>create( 'ZIF_WA003_ODATA_IN' ).
    cl_abap_testdouble=>configure_call( double = ro_obj )->returning( value = lt_key_tab ).
    ro_obj->get_key_tab( ).
  ENDMETHOD.
ENDCLASS.



CLASS ltc_create_delete_entity DEFINITION FOR TESTING
    RISK LEVEL HARMLESS
    DURATION SHORT
    INHERITING FROM cl_aunit_assert.

  PUBLIC SECTION.

    METHODS create_delete_entry FOR TESTING.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA ms_entry_in TYPE zcl_zweb_abap_demo3_mpc=>ts_varh.

    METHODS create_entry.
    METHODS create_entry2.
    METHODS delete_entry.
    METHODS delete_entry2.

    METHODS update_entry.
    METHODS update_entry2.

    METHODS get_odata_double_create RETURNING VALUE(ro_obj) TYPE REF TO zif_wa003_odata_in.

    METHODS get_odata_double_delete RETURNING VALUE(ro_obj) TYPE REF TO zif_wa003_odata_in.

    METHODS get_odata_double_update RETURNING VALUE(ro_obj) TYPE REF TO zif_wa003_odata_in.
ENDCLASS.

CLASS ltc_create_delete_entity IMPLEMENTATION.
  METHOD create_delete_entry.

    BREAK-POINT.

    create_entry( ).
    create_entry2( ).
    update_entry( ).

    delete_entry( ).
    delete_entry2( ).
    update_entry2( ).

  ENDMETHOD.

  METHOD create_entry.
    DATA lo_cut TYPE REF TO zcl_wa003_var_head_feed.
    DATA lo_odata_in TYPE REF TO zif_wa003_odata_in.

    DATA ls_entry4response TYPE zcl_zweb_abap_demo3_mpc=>ts_varh.
    DATA ls_response_context TYPE /iwbep/if_mgw_appl_srv_runtime=>ty_s_mgw_response_context.


    CREATE OBJECT lo_cut.

    TRY.
        lo_odata_in = get_odata_double_create(  ).
        lo_cut->zif_wa003_entity_feeder~set_odata_in( io_odata_in = lo_odata_in ).

        lo_cut->zif_wa003_entity_feeder~c(
          IMPORTING
            es                           =  ls_entry4response
        ).
*          CATCH /iwbep/cx_mgw_busi_exception.    "
*          CATCH /iwbep/cx_mgw_tech_exception.    "

      CATCH /iwbep/cx_mgw_busi_exception. " Business Exception
        fail(
          EXPORTING
            msg    = 'Business Exception create_entry: /iwbep/cx_mgw_busi_exception'                 " Error Message
*           level  = critical         " Error Severity
*           quit   = method           " Flow Control in Case of Error
*           detail =                  " Detailed Message
        ).
      CATCH /iwbep/cx_mgw_tech_exception. " Technical Exception
        fail(
      EXPORTING
        msg    = 'Business Exception read_entry: /iwbep/cx_mgw_tech_exception'                 " Error Message
*           level  = critical         " Error Severity
*           quit   = method           " Flow Control in Case of Error
*           detail =                  " Detailed Message
    ).
    ENDTRY.
  ENDMETHOD.

  METHOD get_odata_double_create.

    ms_entry_in-name = 'ZVAR999'.
    ms_entry_in-description = 'added while unit testing ZVAR999'.


    DATA lo_data_entry_provider TYPE REF TO /iwbep/if_mgw_entry_provider.
    TRY.

        lo_data_entry_provider ?= cl_abap_testdouble=>create( '/IWBEP/IF_MGW_ENTRY_PROVIDER' ).
        cl_abap_testdouble=>configure_call( double = lo_data_entry_provider )->set_parameter(
          EXPORTING
            name          = 'ES_DATA'
            value         = ms_entry_in
*          RECEIVING
*            configuration =
        ).
        " lo_data_entry_provider->read_entry_data( IMPORTING es_data = ls_entry_in ).
        lo_data_entry_provider->read_entry_data(  ).
      CATCH /iwbep/cx_mgw_tech_exception.

    ENDTRY.


    """"""""""""""""""""""""""""""""""""""""""""
    DATA lo_msg_container TYPE REF TO /iwbep/if_message_container.
    lo_msg_container ?= cl_abap_testdouble=>create( '/IWBEP/IF_MESSAGE_CONTAINER' ).

    DATA lo_dpc_context TYPE REF TO /iwbep/if_mgw_context.
    lo_dpc_context ?= cl_abap_testdouble=>create( '/IWBEP/IF_MGW_CONTEXT' ).
    cl_abap_testdouble=>configure_call( double = lo_dpc_context )->returning( value = lo_msg_container ).
    lo_dpc_context->get_message_container( ).


    ro_obj ?= cl_abap_testdouble=>create( 'ZIF_WA003_ODATA_IN' ).
    cl_abap_testdouble=>configure_call( double = ro_obj )->returning( value = lo_data_entry_provider ).
    ro_obj->get_data_provider( ).

    cl_abap_testdouble=>configure_call( double = ro_obj )->returning( value = lo_dpc_context ).
    ro_obj->get_context( ).

  ENDMETHOD.

  METHOD create_entry2.
    DATA lo_cut TYPE REF TO zcl_wa003_var_head_feed.
    DATA lo_odata_in TYPE REF TO zif_wa003_odata_in.

    DATA ls_entry4response TYPE zcl_zweb_abap_demo3_mpc=>ts_varh.
    DATA ls_response_context TYPE /iwbep/if_mgw_appl_srv_runtime=>ty_s_mgw_response_context.

    DATA lx TYPE REF TO /iwbep/cx_mgw_busi_exception.

    """" если пропускает повторно запись без исключения - то это ошибка
    """ правильная работа - это выброс исключения

    CREATE OBJECT lo_cut.

    TRY.
        lo_odata_in = get_odata_double_create(  ).
        lo_cut->zif_wa003_entity_feeder~set_odata_in( io_odata_in = lo_odata_in ).

        lo_cut->zif_wa003_entity_feeder~c(
          IMPORTING
            es                           =  ls_entry4response
        ).

        fail(
          EXPORTING
            msg    = 'NOT Business Exception read_entry: /iwbep/cx_mgw_busi_exception'                 " Error Message
*           level  = critical         " Error Severity
*           quit   = method           " Flow Control in Case of Error
*           detail =                  " Detailed Message
        ).

      CATCH /iwbep/cx_mgw_busi_exception INTO lx. " Business Exception
        " ok
      CATCH /iwbep/cx_mgw_tech_exception. " Technical Exception
        fail(
      EXPORTING
        msg    = 'Business Exception read_entry: /iwbep/cx_mgw_tech_exception'                 " Error Message
*           level  = critical         " Error Severity
*           quit   = method           " Flow Control in Case of Error
*           detail =                  " Detailed Message
    ).
    ENDTRY.
  ENDMETHOD.

  METHOD delete_entry.


    DATA lo_cut TYPE REF TO zcl_wa003_var_head_feed.
    DATA lo_odata_in TYPE REF TO zif_wa003_odata_in.

    DATA ls_entry4response TYPE zcl_zweb_abap_demo3_mpc=>ts_varh.
    DATA ls_response_context TYPE /iwbep/if_mgw_appl_srv_runtime=>ty_s_mgw_response_context.

    """" если пропускает повторно запись без исключения - то это ошибка
    """ правильная работа - это выброс исключения

    CREATE OBJECT lo_cut.

    TRY.
        lo_odata_in = get_odata_double_delete(  ).
        lo_cut->zif_wa003_entity_feeder~set_odata_in( io_odata_in = lo_odata_in ).

        lo_cut->zif_wa003_entity_feeder~d( ).

      CATCH /iwbep/cx_mgw_busi_exception. " Business Exception
        fail(
          EXPORTING
            msg    = 'NOT Business Exception read_entry: /iwbep/cx_mgw_busi_exception'                 " Error Message
*                   level  = critical         " Error Severity
*                   quit   = method           " Flow Control in Case of Error
*                   detail =                  " Detailed Message
        ).

      CATCH /iwbep/cx_mgw_tech_exception. " Technical Exception
        fail(
      EXPORTING
        msg    = 'Business Exception read_entry: /iwbep/cx_mgw_tech_exception'                 " Error Message
*           level  = critical         " Error Severity
*           quit   = method           " Flow Control in Case of Error
*           detail =                  " Detailed Message
    ).
    ENDTRY.
  ENDMETHOD.

  METHOD get_odata_double_delete.
    DATA lt_key_tab TYPE /iwbep/t_mgw_name_value_pair.
    DATA ls_key_tab TYPE /iwbep/s_mgw_name_value_pair.

    ls_key_tab-name = 'Name'.
    ls_key_tab-value = ms_entry_in-name.

    APPEND ls_key_tab TO lt_key_tab.



    """"""""""""""""""""""""""""""""""""""""""""
    DATA lo_msg_container TYPE REF TO /iwbep/if_message_container.
    lo_msg_container ?= cl_abap_testdouble=>create( '/IWBEP/IF_MESSAGE_CONTAINER' ).

    DATA lo_dpc_context TYPE REF TO /iwbep/if_mgw_context.
    lo_dpc_context ?= cl_abap_testdouble=>create( '/IWBEP/IF_MGW_CONTEXT' ).
    cl_abap_testdouble=>configure_call( double = lo_dpc_context )->returning( value = lo_msg_container ).
    lo_dpc_context->get_message_container( ).


    "  ro_obj ?= cl_abap_testdouble=>create( 'ZIF_WA003_ODATA_IN' ).
    "  cl_abap_testdouble=>configure_call( double = ro_obj )->returning( value = lo_data_entry_provider ).
    "  ro_obj->get_data_provider( ).

    ro_obj ?= cl_abap_testdouble=>create( 'ZIF_WA003_ODATA_IN' ).
    cl_abap_testdouble=>configure_call( double = ro_obj )->returning( value = lt_key_tab ).
    ro_obj->get_key_tab( ).


    cl_abap_testdouble=>configure_call( double = ro_obj )->returning( value = lo_dpc_context ).
    ro_obj->get_context( ).

  ENDMETHOD.

  METHOD delete_entry2.
    DATA lo_cut TYPE REF TO zcl_wa003_var_head_feed.
    DATA lo_odata_in TYPE REF TO zif_wa003_odata_in.

    DATA ls_entry4response TYPE zcl_zweb_abap_demo3_mpc=>ts_varh.
    DATA ls_response_context TYPE /iwbep/if_mgw_appl_srv_runtime=>ty_s_mgw_response_context.

    """" если пропускает повторно запись без исключения - то это ошибка
    """ правильная работа - это выброс исключения

    CREATE OBJECT lo_cut.

    TRY.
        lo_odata_in = get_odata_double_delete(  ).
        lo_cut->zif_wa003_entity_feeder~set_odata_in( io_odata_in = lo_odata_in ).

        lo_cut->zif_wa003_entity_feeder~d( ).

        fail(
          EXPORTING
            msg    = 'NOT Business Exception read_entry: /iwbep/cx_mgw_busi_exception'                 " Error Message
*                   level  = critical         " Error Severity
*                   quit   = method           " Flow Control in Case of Error
*                   detail =                  " Detailed Message
        ).

      CATCH /iwbep/cx_mgw_busi_exception. " Business Exception
        " ok ok ok

      CATCH /iwbep/cx_mgw_tech_exception. " Technical Exception
        fail(
      EXPORTING
        msg    = 'Business Exception read_entry: /iwbep/cx_mgw_tech_exception'                 " Error Message
*           level  = critical         " Error Severity
*           quit   = method           " Flow Control in Case of Error
*           detail =                  " Detailed Message
    ).
    ENDTRY.
  ENDMETHOD.

  METHOD update_entry.
    DATA lo_cut TYPE REF TO zcl_wa003_var_head_feed.
    DATA lo_odata_in TYPE REF TO zif_wa003_odata_in.

    DATA ls_entry4response TYPE zcl_zweb_abap_demo3_mpc=>ts_varh.
    DATA ls_response_context TYPE /iwbep/if_mgw_appl_srv_runtime=>ty_s_mgw_response_context.

    CREATE OBJECT lo_cut.

    TRY.
        lo_odata_in = get_odata_double_update(  ).
        lo_cut->zif_wa003_entity_feeder~set_odata_in( io_odata_in = lo_odata_in ).

        lo_cut->zif_wa003_entity_feeder~u( IMPORTING es = ls_entry4response ).

      CATCH /iwbep/cx_mgw_busi_exception. " Business Exception
        fail(
          EXPORTING
            msg    = 'NOT Business Exception read_entry: /iwbep/cx_mgw_busi_exception'                 " Error Message
*                   level  = critical         " Error Severity
*                   quit   = method           " Flow Control in Case of Error
*                   detail =                  " Detailed Message
        ).

      CATCH /iwbep/cx_mgw_tech_exception. " Technical Exception
        fail(
      EXPORTING
        msg    = 'Business Exception read_entry: /iwbep/cx_mgw_tech_exception'                 " Error Message
*           level  = critical         " Error Severity
*           quit   = method           " Flow Control in Case of Error
*           detail =                  " Detailed Message
    ).
    ENDTRY.
  ENDMETHOD.

  METHOD update_entry2.

    DATA lo_cut TYPE REF TO zcl_wa003_var_head_feed.
    DATA lo_odata_in TYPE REF TO zif_wa003_odata_in.

    DATA ls_entry4response TYPE zcl_zweb_abap_demo3_mpc=>ts_varh.
    DATA ls_response_context TYPE /iwbep/if_mgw_appl_srv_runtime=>ty_s_mgw_response_context.

    """" если пропускает повторно запись без исключения - то это ошибка
    """ правильная работа - это выброс исключения

    CREATE OBJECT lo_cut.

    TRY.
        lo_odata_in = get_odata_double_update(  ).
        lo_cut->zif_wa003_entity_feeder~set_odata_in( io_odata_in = lo_odata_in ).

        lo_cut->zif_wa003_entity_feeder~u( IMPORTING es = ls_entry4response ).

        fail(
          EXPORTING
            msg    = 'NOT Business Exception read_entry: /iwbep/cx_mgw_busi_exception'                 " Error Message
*                   level  = critical         " Error Severity
*                   quit   = method           " Flow Control in Case of Error
*                   detail =                  " Detailed Message
        ).

      CATCH /iwbep/cx_mgw_busi_exception. " Business Exception
        " ok ok ok

      CATCH /iwbep/cx_mgw_tech_exception. " Technical Exception
        fail(
      EXPORTING
        msg    = 'Business Exception read_entry: /iwbep/cx_mgw_tech_exception'                 " Error Message
*           level  = critical         " Error Severity
*           quit   = method           " Flow Control in Case of Error
*           detail =                  " Detailed Message
    ).
    ENDTRY.

  ENDMETHOD.

  METHOD get_odata_double_update.

    ms_entry_in-name = 'ZVAR999'.
    ms_entry_in-description = 'added while unit testing ZVAR999'.
    ms_entry_in-fast_val = 'FASTVAL_ZVAR999'.


    DATA lo_data_entry_provider TYPE REF TO /iwbep/if_mgw_entry_provider.
    TRY.
        lo_data_entry_provider ?= cl_abap_testdouble=>create( '/IWBEP/IF_MGW_ENTRY_PROVIDER' ).
        cl_abap_testdouble=>configure_call( double = lo_data_entry_provider )->set_parameter(
          EXPORTING
            name          = 'ES_DATA'
            value         = ms_entry_in
*          RECEIVING
*            configuration =
        ).
        " lo_data_entry_provider->read_entry_data( IMPORTING es_data = ls_entry_in ).
        lo_data_entry_provider->read_entry_data(  ).
      CATCH /iwbep/cx_mgw_tech_exception.

    ENDTRY.


    """"""""""""""""""""""""""""""""""""""""""""
    DATA lo_msg_container TYPE REF TO /iwbep/if_message_container.
    lo_msg_container ?= cl_abap_testdouble=>create( '/IWBEP/IF_MESSAGE_CONTAINER' ).

    DATA lo_dpc_context TYPE REF TO /iwbep/if_mgw_context.
    lo_dpc_context ?= cl_abap_testdouble=>create( '/IWBEP/IF_MGW_CONTEXT' ).
    cl_abap_testdouble=>configure_call( double = lo_dpc_context )->returning( value = lo_msg_container ).
    lo_dpc_context->get_message_container( ).


    ro_obj ?= cl_abap_testdouble=>create( 'ZIF_WA003_ODATA_IN' ).
    cl_abap_testdouble=>configure_call( double = ro_obj )->returning( value = lo_data_entry_provider ).
    ro_obj->get_data_provider( ).

    cl_abap_testdouble=>configure_call( double = ro_obj )->returning( value = lo_dpc_context ).
    ro_obj->get_context( ).

  ENDMETHOD.

ENDCLASS.
