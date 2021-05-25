*&---------------------------------------------------------------------*
*& Include          LZFGWA001_SCRND01
*&---------------------------------------------------------------------*

TABLES  sscrfields.
DATA gs_varid TYPE ztwa001_varid.

SELECTION-SCREEN BEGIN OF SCREEN 4100 TITLE TEXT-t41.

SELECTION-SCREEN BEGIN OF BLOCK b00 WITH FRAME TITLE TEXT-b00.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS r01 TYPE char1 RADIOBUTTON GROUP rg1 DEFAULT 'X' MODIF ID m0 USER-COMMAND rg1e.
SELECTION-SCREEN COMMENT 10(25) TEXT-0r1 FOR FIELD r01 MODIF ID m0.

PARAMETERS r02 TYPE char1 RADIOBUTTON GROUP rg1 MODIF ID m0.
SELECTION-SCREEN COMMENT 40(30) TEXT-0r2 FOR FIELD r02 MODIF ID m0.

SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK b00.


SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.
PARAMETERS: p_recnum TYPE syindex MODIF ID m01 OBLIGATORY DEFAULT 50.
SELECTION-SCREEN END OF BLOCK b01.

SELECTION-SCREEN BEGIN OF BLOCK b02 WITH FRAME TITLE TEXT-b02.
SELECT-OPTIONS: s_varid FOR gs_varid-var_name MODIF ID m02.
SELECTION-SCREEN END OF BLOCK b02.

SELECTION-SCREEN FUNCTION KEY 1 .
SELECTION-SCREEN END OF SCREEN 4100.









"""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""
DATA gs_varval TYPE ztwa001_varval.

SELECTION-SCREEN BEGIN OF SCREEN 4200 TITLE TEXT-t42.

PARAMETERS:   p_vname TYPE zewa001_var_name MODIF ID m0
            , p_desc TYPE zewa001_var_desc MODIF ID m0
            , p_type TYPE zewa001_var_type MODIF ID m0
            , del AS CHECKBOX  MODIF ID m0
            , debug_on AS CHECKBOX  MODIF ID m0
            , fast_val TYPE zewa001_var_fast_val  MODIF ID m0
            .

SELECT-OPTIONS: s_varval FOR gs_varval-low MODIF ID m0.

SELECTION-SCREEN END OF SCREEN 4200.
"""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""






"""""""""""""""""""""""""""""""""""""""""""""""

LOAD-OF-PROGRAM.
  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name                  = icon_test
      text                  = 'Demo'
*     INFO                  = ' '
*     ADD_STDINF            = 'X'
    IMPORTING
      result                = sscrfields-functxt_01
    EXCEPTIONS
      icon_not_found        = 1
      outputfield_too_short = 2
      OTHERS                = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

INITIALIZATION.
  BREAK-POINT.
  """""""""""""""""""""""""""""""""""""""""""""""

AT SELECTION-SCREEN.
  CASE sy-ucomm.
    WHEN 'FC01'.
      SUBMIT zweb_abap_demo_var_using VIA SELECTION-SCREEN
     AND RETURN.
    WHEN OTHERS.
  ENDCASE.


AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 EQ 'M0'.
      CONTINUE.
    ENDIF.


    IF screen-group3 EQ 'BLK'.
      CONTINUE.
    ENDIF.

    IF r01 EQ abap_true.
      IF screen-group1 EQ 'M01'.
        screen-active = 1.
      ELSE.
        screen-active = 0.
      ENDIF.
    ENDIF.

    IF r02 EQ abap_true.
      IF screen-group1 EQ 'M02'.
        screen-active = 1.
      ELSE.
        screen-active = 0.
      ENDIF.
    ENDIF.

    """"""""""""""""""""""""""""""""""""
    MODIFY SCREEN.
  ENDLOOP.
