*"* use this source file for your ABAP unit test classes
CLASS ltc_prepare_range DEFINITION DEFERRED.
CLASS zcl_wa003_odata2range DEFINITION LOCAL FRIENDS ltc_prepare_range.
CLASS ltc_prepare_range DEFINITION FOR TESTING
    RISK LEVEL HARMLESS
    DURATION SHORT
    INHERITING FROM cl_aunit_assert.

  PUBLIC SECTION.
    METHODS simple_prepare FOR TESTING.

  PROTECTED SECTION.

  PRIVATE SECTION.
    METHODS get_odata_double_with_filter
      RETURNING VALUE(ro_obj) TYPE REF TO zif_wa003_odata_in.
ENDCLASS.

CLASS ltc_prepare_range IMPLEMENTATION.
  METHOD simple_prepare.
    DATA lo_cut TYPE REF TO zcl_wa003_odata2range.
    DATA lt_var_type_rng TYPE RANGE OF ztwa001_varid-var_type.

    TYPES: BEGIN OF ts_property_rng
                , prop_in TYPE string
                , range TYPE REF TO data
           , END OF ts_property_rng
           , tt_property_rng TYPE STANDARD TABLE OF ts_property_rng
           .

    DATA lt_property_rng TYPE tt_property_rng.
    FIELD-SYMBOLS <fs_property_rng> TYPE ts_property_rng.


    APPEND INITIAL LINE TO lt_property_rng ASSIGNING <fs_property_rng>.
    <fs_property_rng>-prop_in = 'VAR_TYPE'.
    GET REFERENCE OF lt_var_type_rng INTO <fs_property_rng>-range.

    CREATE OBJECT lo_cut.

    lo_cut->set_odata_in( io_odata_in = get_odata_double_with_filter( ) ).
    lo_cut->filter2sel_opt(
      CHANGING
        ct_property_rng = lt_property_rng
    ).

  ENDMETHOD.

  METHOD get_odata_double_with_filter.
    "RETURNING VALUE(ro_obj) TYPE REF TO zif_wa003_odata_in.
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """ select options for returning (формируем значения фильтра)
    " а потом присвоим им значению для возврата через DOUBLE
    DATA lt_range_var_type TYPE RANGE OF zewa001_var_type.
    DATA ls_select_option TYPE /iwbep/s_mgw_select_option.
    FIELD-SYMBOLS <fs_var_type> LIKE LINE OF lt_range_var_type.
    APPEND INITIAL LINE TO lt_range_var_type ASSIGNING <fs_var_type>.
    <fs_var_type> = 'IEQ3'.


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

    """""*****
    cl_abap_testdouble=>configure_call( double = lo_odata_req_filter
        )->ignore_parameter( name = 'IS_SELECT_OPTION'
            )->set_parameter(
      EXPORTING
        name          = 'ET_SELECT_OPTION'
        value         = lt_range_var_type
    ).
    lo_odata_req_filter->convert_select_option(
      EXPORTING is_select_option = ls_select_option                 " Key name
      "IMPORTING et_select_option =                  " Ranges table
    ).


    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " tech context, который приходит из OData
    " вызов фильтров из нескольких частей на текущий момент =
    DATA lo_tech_context_q TYPE REF TO /iwbep/if_mgw_req_entityset.
    lo_tech_context_q ?= cl_abap_testdouble=>create( '/IWBEP/IF_MGW_REQ_ENTITYSET' ).
    cl_abap_testdouble=>configure_call( double = lo_tech_context_q )->returning( value = lo_odata_req_filter ).
    lo_tech_context_q->get_filter( ).



    ro_obj ?= cl_abap_testdouble=>create( 'ZIF_WA003_ODATA_IN' ).
    cl_abap_testdouble=>configure_call( double = ro_obj )->returning( value = lo_tech_context_q ).
    ro_obj->get_tech_context_q(  ).
  ENDMETHOD.
ENDCLASS.
