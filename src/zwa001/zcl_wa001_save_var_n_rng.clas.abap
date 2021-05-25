CLASS zcl_wa001_save_var_n_rng DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor.
    METHODS sh
      IMPORTING it_varid     TYPE ztwa001_varid_tab
                it_varval    TYPE ztwa001_varval_tab
                iv_do_commit TYPE abap_bool DEFAULT abap_true.

    METHODS save_vals
      IMPORTING it_varval    TYPE ztwa001_varval_tab
                iv_do_commit TYPE abap_bool DEFAULT abap_true.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_wa001_save_var_n_rng IMPLEMENTATION.
  METHOD constructor.

  ENDMETHOD.

  METHOD sh.
*        IMPORTING it_varid TYPE ztwa001_varid_tab
*                  it_varval TYPE ztwa001_varval_tab.
    DATA lo_var_prepare_logs TYPE REF TO zcl_wa001_var_logs_prepare.
    DATA lt_varlog TYPE ztwa001_varlog_tab.

    lo_var_prepare_logs = NEW #(  ).

    lo_var_prepare_logs->sh( EXPORTING it_varid = it_varid
                                       it_varval = it_varval
                             IMPORTING et_varlog = lt_varlog ).

    CALL FUNCTION 'Z_WA001_VAR_TAB_UPD'
      IN UPDATE TASK
      EXPORTING
*       iv_action = 'M'              " Single-Character Flag
        it_varid  = it_varid                " ZTWA001_VARID -> tab
        it_varval = it_varval                " ZTWA001_VARVAL -> tab
        it_varlog = lt_varlog.                " ZTWA001_VARLOG -> tab

    IF iv_do_commit EQ abap_true.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true                " Use of Command `COMMIT AND WAIT`
*      IMPORTING
*         return =                  " Return Messages
        .

    ENDIF.
  ENDMETHOD.

  METHOD save_vals.
*      IMPORTING it_varval    TYPE ztwa001_varval_tab
*                iv_do_commit TYPE abap_bool DEFAULT abap_true.
    CALL FUNCTION 'Z_WA001_VAR_TAB_UPD'
      IN UPDATE TASK
      EXPORTING
*       iv_action = 'M'              " Single-Character Flag
*       it_varid  = it_varid                " ZTWA001_VARID -> tab
        it_varval = it_varval                " ZTWA001_VARVAL -> tab
*       it_varlog = lt_varlog                " ZTWA001_VARLOG -> tab
      .
    IF iv_do_commit EQ abap_true.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true                " Use of Command `COMMIT AND WAIT`
*      IMPORTING
*         return =                  " Return Messages
        .

    ENDIF.
  ENDMETHOD.
ENDCLASS.
