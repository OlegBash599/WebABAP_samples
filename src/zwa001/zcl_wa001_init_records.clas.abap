CLASS zcl_wa001_init_records DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor.

    METHODS set_dto
      IMPORTING io_scr TYPE REF TO zcl_wa001_mngvar_scr_dto.

    METHODS sh.

  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES: BEGIN OF ts_bus_area
                , bus_area TYPE char10
            , END OF ts_bus_area
            , tt_bus_area TYPE STANDARD TABLE OF ts_bus_area WITH DEFAULT KEY
            .

    TYPES: ts_varid TYPE ztwa001_varid.
    TYPES: tt_varid TYPE STANDARD TABLE OF ts_varid WITH DEFAULT KEY.
    TYPES: tt_varval TYPE STANDARD TABLE OF ztwa001_varval WITH DEFAULT KEY.

    DATA mo_dto_scr TYPE REF TO zcl_wa001_mngvar_scr_dto.
    DATA mt_bus_area TYPE tt_bus_area.


    METHODS get_num_of_records
      RETURNING VALUE(rv_val) TYPE syindex.

    METHODS fill_varid
      IMPORTING iv_num_rec TYPE syindex
      CHANGING  cs_varid   TYPE ts_varid.

    METHODS fill_varval
      IMPORTING iv_num_rec TYPE syindex
                is_varid   TYPE ts_varid
      CHANGING  ct_varval  TYPE tt_varval.

    METHODS clear_all_tabs.
    METHODS save2tab
      IMPORTING it_varid_all  TYPE tt_varid
                it_varval_all TYPE tt_varval  .

ENDCLASS.



CLASS zcl_wa001_init_records IMPLEMENTATION.
  METHOD constructor.
    CLEAR mt_bus_area.

    mt_bus_area = VALUE tt_bus_area(
    ( bus_area = 'MM' )
    ( bus_area = 'SD' )
    ( bus_area = 'FI' )
    ( bus_area = 'DMS' )
    ( bus_area = 'PM' )
    ( bus_area = 'CO' )
    ( bus_area = 'APO' )
    ( bus_area = 'EWM' )
    ( bus_area = 'TM' )
    ).

  ENDMETHOD.

  METHOD set_dto.
    "IMPORTING io_scr TYPE REF TO ZCL_WA001_MNGVAR_SCR_DTO.
    mo_dto_scr ?= io_scr.
  ENDMETHOD.

  METHOD sh.
    DATA lv_num_of_records TYPE syindex.
    DATA lv_current_index TYPE syindex.

    DATA ls_varid TYPE ztwa001_varid.
    DATA lt_varid_all TYPE STANDARD TABLE OF ztwa001_varid.
    DATA lt_varval_one TYPE tt_varval.
    DATA lt_varval_all TYPE tt_varval.

    data lv_lines_varid TYPE char5.
    data lv_lines_varval TYPE char5.

    lv_num_of_records = get_num_of_records(  ).

    DO lv_num_of_records TIMES.

      lv_current_index = sy-index.

      CLEAR ls_varid.
      CLEAR lt_varval_one.

      fill_varid( EXPORTING iv_num_rec = lv_current_index
                  CHANGING cs_varid =  ls_varid ).


      fill_varval( EXPORTING iv_num_rec = lv_current_index
                             is_varid   = ls_varid
                    CHANGING ct_varval  = lt_varval_one ).

      APPEND ls_varid TO lt_varid_all.
      APPEND LINES OF lt_varval_one TO lt_varval_all.

    ENDDO.

    clear_all_tabs(  ).

    save2tab( EXPORTING it_varid_all = lt_varid_all
                        it_varval_all = lt_varval_all ).

    lv_lines_varid = lines( lt_varid_all ).
    lv_lines_varval = lines( lt_varval_all ).

    MESSAGE s000(cl) WITH 'Added for VARID: ' lv_lines_varid '; added for VarVal' lv_lines_varval.

  ENDMETHOD.

  METHOD fill_varid.
*      IMPORTING iv_num_rec TYPE syindex
*      CHANGING cs_varid TYPE ztwa001_varid.

    DATA lv_rec_mod TYPE sytabix.
    DATA lv_var_type_count TYPE sytabix.
    DATA lv_do_switch TYPE abap_bool.
    FIELD-SYMBOLS <fs_bus_area> TYPE ts_bus_area.

    lv_rec_mod = ( iv_num_rec MOD lines( mt_bus_area ) ) + 1.
    lv_var_type_count = ( iv_num_rec DIV ( 2 * ( lines( mt_bus_area ) ) ) ).

    GET TIME.

    READ TABLE mt_bus_area ASSIGNING <fs_bus_area> INDEX lv_rec_mod.
    IF sy-subrc EQ 0.
      cs_varid-mandt = cl_abap_syst=>get_client( ).
      cs_varid-var_name = |Z{ <fs_bus_area>-bus_area }_N{ iv_num_rec }|.
      cs_varid-var_desc = |Description for { cs_varid-var_name }|.
      IF lv_do_switch EQ abap_true.
        cs_varid-var_type = '2'.
      ELSE.
        cs_varid-var_type = '3'.
      ENDIF.

      cs_varid-is_del = abap_false.
      cs_varid-is_debug_on = abap_false.
      IF lv_do_switch EQ abap_true.
        cs_varid-fast_val = abap_true.
      ELSE.
        CLEAR cs_varid-fast_val.
      ENDIF.

      cs_varid-chu = cs_varid-cru = sy-uname.

      cs_varid-chd = cs_varid-crd = sy-datum.

      cs_varid-cht = cs_varid-crt = sy-uzeit.

    ENDIF.

  ENDMETHOD.

  METHOD fill_varval.
*      IMPORTING iv_num_rec TYPE syindex
*                is_varid   TYPE ztwa001_varid
*      changing ct_varval TYPE tt_varval.

    FIELD-SYMBOLS <fs_var_val> TYPE ztwa001_varval.

    IF is_varid-var_type EQ '2'.
      RETURN.
    ENDIF.

    DO 2 TIMES.
      APPEND INITIAL LINE TO ct_varval ASSIGNING <fs_var_val>.
      <fs_var_val>-mandt = is_varid-mandt.
      <fs_var_val>-var_name = is_varid-var_name.
      <fs_var_val>-var_numb = sy-index.
      <fs_var_val>-sign = 'I'.
      <fs_var_val>-opti = 'EQ'.
      <fs_var_val>-low = |SMPL { sy-index }|.
      CLEAR <fs_var_val>-high.
    ENDDO.

  ENDMETHOD.

  METHOD clear_all_tabs.
    CALL FUNCTION 'Z_WA001_VAR_TAB_UPD'
      IN UPDATE TASK
      EXPORTING
        iv_action = 'Z'.              " Single-Character Flag

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait   =  abap_true                  " Use of Command `COMMIT AND WAIT`
*      IMPORTING
*        return =                  " Return Messages
      .
  ENDMETHOD.

  METHOD save2tab.
*        IMPORTING it_varid_all TYPE tt_varid
*                  it_varval_all TYPE tt_varval  .
    data lo_save_var_n_range TYPE REF TO zcl_wa001_save_var_n_rng.

    lo_save_var_n_range = new #(  ).

    lo_save_var_n_range->sh(  EXPORTING it_varid = it_varid_all
                                        it_varval = it_varval_all ).

  ENDMETHOD.

  METHOD get_num_of_records.
    "RETURNING VALUE(rv_val) TYPE syindex.
    IF mo_dto_scr->mv_num_records IS INITIAL.
      rv_val = 30.
    ELSE.
      rv_val = mo_dto_scr->mv_num_records.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
