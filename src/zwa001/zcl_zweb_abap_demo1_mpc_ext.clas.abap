CLASS zcl_zweb_abap_demo1_mpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zweb_abap_demo1_mpc
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS define
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.

    METHODS display_as_date
      RAISING
        /iwbep/cx_mgw_med_exception .
    METHODS display_with_value_list
      RAISING
        /iwbep/cx_mgw_med_exception .
ENDCLASS.



CLASS zcl_zweb_abap_demo1_mpc_ext IMPLEMENTATION.


  METHOD define.

    super->define( ).

    display_as_date( ).
    display_with_value_list( ).

  ENDMETHOD.


  METHOD display_as_date.
    DATA lo_entity_type TYPE REF TO /iwbep/if_mgw_odata_entity_typ.
    DATA lo_property    TYPE REF TO /iwbep/cl_mgw_odata_property.
    DATA lo_annotation  TYPE REF TO /iwbep/if_mgw_odata_annotation.

    lo_entity_type = model->get_entity_type( iv_entity_name = 'VarHead').
    lo_property ?= lo_entity_type->get_property( iv_property_name = 'Chd').

    CALL METHOD lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation
      EXPORTING
        iv_annotation_namespace = /iwbep/if_mgw_med_odata_types=>gc_sap_namespace
      RECEIVING
        ro_annotation           = lo_annotation.

    lo_annotation->add( iv_key = 'display-format' iv_value = 'Date' ).


  ENDMETHOD.


  METHOD display_with_value_list.
    DATA lo_entity_type TYPE REF TO /iwbep/if_mgw_odata_entity_typ.
    DATA lo_property    TYPE REF TO /iwbep/cl_mgw_odata_property.
    DATA lo_annotation  TYPE REF TO /iwbep/if_mgw_odata_annotation.

    lo_entity_type = model->get_entity_type( iv_entity_name = 'VarHead').
    lo_property ?= lo_entity_type->get_property( iv_property_name = 'VarType').
    lo_annotation ?= lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation(
        iv_annotation_namespace = /iwbep/if_mgw_med_odata_types=>gc_sap_namespace ).

    lo_annotation->add( iv_key = 'display-format' iv_value = 'value-list' ).
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    lo_property ?= lo_entity_type->get_property( iv_property_name = 'VarTypeTx').
    lo_annotation ?= lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation(
        iv_annotation_namespace = /iwbep/if_mgw_med_odata_types=>gc_sap_namespace ).
    lo_annotation->add( iv_key = 'text-for' iv_value = 'VarType' ).

  ENDMETHOD.
ENDCLASS.
