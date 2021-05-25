FUNCTION z_wa001_var_file_upd.
*"----------------------------------------------------------------------
*"*"Update Function Module:
*"
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_ACTION) TYPE  CHAR1 DEFAULT 'M'
*"     VALUE(IT_VAR_FILE) TYPE  ZTWA001_VARFILE_TAB
*"----------------------------------------------------------------------


  CASE iv_action.
    WHEN 'Z'.
      DELETE FROM ztwa001_varfile.
    WHEN 'M'.

      MODIFY ztwa001_varfile FROM TABLE it_var_file.

    WHEN OTHERS.
  ENDCASE.


ENDFUNCTION.
