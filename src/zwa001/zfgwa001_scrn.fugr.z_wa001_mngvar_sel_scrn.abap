FUNCTION z_wa001_mngvar_sel_scrn.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  CHANGING
*"     REFERENCE(CO_SCR) TYPE REF TO  ZCL_WA001_MNGVAR_SCR_DTO
*"     REFERENCE(CV_RC) TYPE  SYSUBRC
*"----------------------------------------------------------------------

  IF co_scr IS BOUND.
  ELSE.
    CREATE OBJECT co_scr.
  ENDIF.

  CLEAR cv_rc.

  CALL SELECTION-SCREEN 4100.
  IF sy-subrc EQ 0.
    co_scr->mv_mode_init_data = r01.
    co_scr->mv_mode_mng_var = r02.
    co_scr->mv_num_records = p_recnum.
    co_scr->mt_var_name_rng[] = s_varid[].
  ENDIF.
  cv_rc = sy-subrc.

ENDFUNCTION.
