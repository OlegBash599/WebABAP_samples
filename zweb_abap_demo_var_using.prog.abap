*&---------------------------------------------------------------------*
*& Report ZWEB_ABAP_DEMO_VAR_USING
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zweb_abap_demo_var_using.

DATA gs_varid TYPE ztwa001_varid.
DATA lo_demo_using TYPE REF TO zcl_wa001_demo_var_using.

SELECT-OPTIONS: s_var FOR gs_varid-var_name.


INITIALIZATION.
  lo_demo_using = NEW #( ).

START-OF-SELECTION.
  lo_demo_using->set_scrn( s_var[] ).
  lo_demo_using->start_of_sel( ).


END-OF-SELECTION.
  lo_demo_using->end_of_sel( ).
