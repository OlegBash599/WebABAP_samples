FUNCTION z_wa1002_soap_in.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IS_ENTRY) TYPE  ZSWA003_VAR_H2_SRV
*"     VALUE(IV_UPDKZ) TYPE  UPDKZ DEFAULT 'R'
*"  EXPORTING
*"     VALUE(ES_ENTRY) TYPE  ZSWA003_VAR_H2_SRV
*"     VALUE(ET_BAPIRET2) TYPE  BAPIRETTAB
*"----------------------------------------------------------------------

  CASE iv_updkz.
    WHEN 'R'.
      MOVE-CORRESPONDING is_entry TO es_entry.
      et_bapiret2 = VALUE #(
      ( message = 'OK OK OK read' )
      ).
    WHEN 'C'.
    WHEN OTHERS.
  ENDCASE.




ENDFUNCTION.
