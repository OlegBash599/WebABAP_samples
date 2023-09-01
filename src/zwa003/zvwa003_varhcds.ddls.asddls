@AbapCatalog.sqlViewName: 'ZVWA003_VARH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS fro VarH'
@OData.publish: true
define view ZVWA003_VARHCDS
  as select from    ztwa001_varid  as h
    left outer join ztwa001_varval as i on h.var_name = i.var_name
{
  key h.var_name    as VAR_NAME,
      h.var_desc    as VAR_DESC,
      h.var_type    as VAR_TYPE,
      h.is_del      as IS_DEL,
      h.is_debug_on as IS_DEBUG_ON,
      h.fast_val    as FAST_VAL,
      h.cru         as CRU,
      h.crd         as crd,
      h.crt         as crt,
      h.chu         as chu,
      h.chd         as chd,
      h.cht         as cht,
      count(*) as NUM_OF_VALUES
} group by h.var_name, h.var_desc, h.var_type, 
        h.is_del, h.is_debug_on, h.fast_val,
        h.cru, h.crd, h.crt, h.chu, h.chd, h.cht
 
        
        
