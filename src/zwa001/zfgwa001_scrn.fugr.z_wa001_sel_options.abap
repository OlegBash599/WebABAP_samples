FUNCTION z_wa001_sel_options.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  CHANGING
*"     REFERENCE(CS_VAR_HEAD) TYPE  ZTWA001_VARID
*"     REFERENCE(CT_RANGE_CHAR) TYPE  ZTTWA001_VARVALUES_RNG
*"     REFERENCE(SCREEN_SYSUBRC) TYPE  SYSUBRC
*"----------------------------------------------------------------------

  FIELD-SYMBOLS <fs_varval_char> TYPE zswa001_varvalues_rng.
  FIELD-SYMBOLS <fs_varval_scr> LIKE LINE OF s_varval.

  CLEAR s_varval[].
  LOOP AT ct_range_char ASSIGNING <fs_varval_char>.
    APPEND INITIAL LINE TO s_varval ASSIGNING <fs_varval_scr>.
    <fs_varval_scr>-sign = <fs_varval_char>-sign.
    <fs_varval_scr>-option = <fs_varval_char>-opti.
    <fs_varval_scr>-low = <fs_varval_char>-low.
    <fs_varval_scr>-high = <fs_varval_char>-high.
  ENDLOOP.

  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  p_vname = cs_var_head-var_name.
  p_desc = cs_var_head-var_desc.
  p_type = cs_var_head-var_type.
  del = cs_var_head-is_del.
  debug_on = cs_var_head-is_debug_on.
  fast_val = cs_var_head-fast_val.
  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


  CLEAR screen_sysubrc.
  CALL SELECTION-SCREEN 4200 STARTING AT 5 5.
  screen_sysubrc = sy-subrc.
  IF screen_sysubrc EQ 0.
    CLEAR ct_range_char.
    LOOP AT s_varval ASSIGNING <fs_varval_scr>.
      APPEND INITIAL LINE TO ct_range_char ASSIGNING <fs_varval_char>.
      <fs_varval_char>-sign = <fs_varval_scr>-sign.
      <fs_varval_char>-opti = <fs_varval_scr>-option.
      <fs_varval_char>-low = <fs_varval_scr>-low.
      <fs_varval_char>-high = <fs_varval_scr>-high.
    ENDLOOP.
    """""""""""""""""""""""""""""""""""""""""""""
    cs_var_head-var_name = p_vname.
    cs_var_head-var_desc = p_desc.
    cs_var_head-var_type = p_type.
    cs_var_head-is_del = del.
    cs_var_head-is_debug_on = debug_on.
    cs_var_head-fast_val = fast_val.
    """""""""""""""""""""""""""""""""""""""""""""

  ENDIF.


ENDFUNCTION.
