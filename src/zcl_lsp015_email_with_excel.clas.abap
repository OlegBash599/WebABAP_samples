class ZCL_LSP015_EMAIL_WITH_EXCEL definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !IV_EMAIL type AD_SMTPADR .
  methods MAIN .
protected section.
private section.

  data MV_EMAIL type AD_SMTPADR .
ENDCLASS.



CLASS ZCL_LSP015_EMAIL_WITH_EXCEL IMPLEMENTATION.


  METHOD constructor.
    mv_email = iv_email.
  ENDMETHOD.


  method MAIN.

  endmethod.
ENDCLASS.
