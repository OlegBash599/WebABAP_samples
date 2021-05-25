CLASS zcl_wa003_odata2range DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF ts_property_rng
            , prop_in TYPE string
            , range TYPE REF TO data
       , END OF ts_property_rng
       , tt_property_rng TYPE STANDARD TABLE OF ts_property_rng WITH DEFAULT KEY
       .

    METHODS set_odata_in
      IMPORTING !io_odata_in TYPE REF TO zif_wa003_odata_in.

    METHODS filter2sel_opt
      CHANGING !ct_property_rng TYPE tt_property_rng
      RAISING  /iwbep/cx_mgw_tech_exception.


  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA mo_odata_in TYPE REF TO zif_wa003_odata_in.
ENDCLASS.



CLASS zcl_wa003_odata2range IMPLEMENTATION.
  METHOD set_odata_in.
    "IMPORTING !io_odata_in TYPE REF TO ZIF_WA003_ODATA_IN.
    mo_odata_in ?= io_odata_in.
  ENDMETHOD.

  METHOD filter2sel_opt.
    "changing !ct_property_rng TYPE tt_property_rng.

    DATA lo_odata_req_filter TYPE REF TO /iwbep/if_mgw_req_filter.
    DATA lo_select_option_list TYPE /iwbep/t_mgw_select_option.

    FIELD-SYMBOLS <fs_select_option> TYPE /iwbep/s_mgw_select_option.
    FIELD-SYMBOLS <fs_property_rng> TYPE ts_property_rng.

    FIELD-SYMBOLS <fs_tab> TYPE STANDARD TABLE.

    lo_odata_req_filter ?= mo_odata_in->get_tech_context_q( )->get_filter( ).
    lo_select_option_list = lo_odata_req_filter->get_filter_select_options( ).
    LOOP AT ct_property_rng ASSIGNING <fs_property_rng>.
      LOOP AT lo_select_option_list ASSIGNING <fs_select_option> WHERE property = <fs_property_rng>-prop_in.
        ASSIGN <fs_property_rng>-range->* TO <fs_tab>.
*        CASE <fs_select_option>-property.
*          WHEN 'VarType' OR 'VAR_TYPE'.
        lo_odata_req_filter->convert_select_option(
                  EXPORTING is_select_option = <fs_select_option>
                  IMPORTING et_select_option = <fs_tab> ).

*          WHEN OTHERS.
*
*        ENDCASE.

        UNASSIGN <fs_tab>.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
