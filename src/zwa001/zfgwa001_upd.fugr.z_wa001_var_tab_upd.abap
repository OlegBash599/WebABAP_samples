FUNCTION z_wa001_var_tab_upd.
*"----------------------------------------------------------------------
*"*"Update Function Module:
*"
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_ACTION) TYPE  CHAR1 DEFAULT 'M'
*"     VALUE(IT_VARID) TYPE  ZTWA001_VARID_TAB OPTIONAL
*"     VALUE(IT_VARVAL) TYPE  ZTWA001_VARVAL_TAB OPTIONAL
*"     VALUE(IT_VARLOG) TYPE  ZTWA001_VARLOG_TAB OPTIONAL
*"----------------------------------------------------------------------



  CASE iv_action.
    WHEN 'Z'.
      DELETE FROM ztwa001_varid.
      DELETE FROM ztwa001_varval.
      DELETE FROM ztwa001_varlog.
    WHEN 'M'.

      MODIFY ztwa001_varid FROM TABLE it_varid.
      MODIFY ztwa001_varval FROM TABLE it_varval.
      MODIFY ztwa001_varlog FROM TABLE it_varlog.

    WHEN OTHERS.
  ENDCASE.


ENDFUNCTION.
