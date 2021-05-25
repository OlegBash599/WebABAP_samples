class ZCL_WA001_MNGVAR_SCR_DTO definition
  public
  final
  create public .

public section.

  data mv_mode_init_data TYPE char1 .
  data mv_mode_mng_var TYPE char1 .

  data mv_num_records TYPE syindex .

  data mt_var_name_rng TYPE RANGE OF ZEWA001_VAR_NAME .

  methods CONSTRUCTOR .
protected section.
private section.
ENDCLASS.



CLASS ZCL_WA001_MNGVAR_SCR_DTO IMPLEMENTATION.


  method CONSTRUCTOR.

  endmethod.
ENDCLASS.
