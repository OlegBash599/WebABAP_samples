CLASS zcl_wa001_mngvar_util DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor.
    METHODS sh.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS process_sel
      IMPORTING io_scr_dto TYPE REF TO zcl_wa001_mngvar_scr_dto.

    METHODS proc_mode_init_data
      IMPORTING io_scr_dto TYPE REF TO zcl_wa001_mngvar_scr_dto.

    METHODS proc_mode_manage_vars
      IMPORTING io_scr_dto TYPE REF TO zcl_wa001_mngvar_scr_dto.
ENDCLASS.



CLASS zcl_wa001_mngvar_util IMPLEMENTATION.
  METHOD constructor.

  ENDMETHOD.

  METHOD sh.

    DATA lv_steps_before_reload TYPE syindex VALUE 25.
    DATA lo_scr_dto TYPE REF TO zcl_wa001_mngvar_scr_dto.
    DATA lv_sysubrc TYPE sysubrc.

    lo_scr_dto = NEW #(  ).

    DO lv_steps_before_reload TIMES.

      CALL FUNCTION 'Z_WA001_MNGVAR_SEL_SCRN'
        CHANGING
          co_scr = lo_scr_dto
          cv_rc  = lv_sysubrc.

      IF lv_sysubrc NE 0.
        EXIT.
      ENDIF.

      process_sel( lo_scr_dto ).

    ENDDO.

  ENDMETHOD.

  METHOD process_sel.
    " IMPORTING io_scr_dto TYPE REF TO zcl_wa001_mngvar_scr_dto.
    IF io_scr_dto->mv_mode_init_data EQ abap_true.
      proc_mode_init_data( io_scr_dto ).
    ENDIF.

    IF io_scr_dto->mv_mode_mng_var EQ abap_true.
      proc_mode_manage_vars( io_scr_dto ).
    ENDIF.

  ENDMETHOD.

  METHOD proc_mode_init_data.
    "      IMPORTING io_scr_dto TYPE REF TO zcl_wa001_mngvar_scr_dto.
    DATA lo_init_records TYPE REF TO zcl_wa001_init_records.

    lo_init_records = NEW #(  ).

    lo_init_records->set_dto( io_scr_dto ).
    lo_init_records->sh(  ).

  ENDMETHOD.


  METHOD proc_mode_manage_vars.
    "IMPORTING io_scr_dto TYPE REF TO zcl_wa001_mngvar_scr_dto.
    DATA lo_manage_vars TYPE REF TO zcl_wa001_manage_varid.

    lo_manage_vars = NEW #(  ).

    lo_manage_vars->set_dto( io_scr_dto ).
    lo_manage_vars->sh(  ).
  ENDMETHOD.
ENDCLASS.
