@AbapCatalog.sqlViewName: 'ZVWA003_VARH2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'ZVWA003_VARHCDS2'
@OData.publish: true
define view ZVWA003_VARHCDS2 as select from ztwa001_varid as var_id
left outer join ztwa001_varval as var_val
    on var_id.var_name = var_val.var_name {
  key var_id.var_name    as VAR_NAME,
      var_id.var_desc    as VAR_DESC,
      count(*) as NUM_OF_VALUES        
} group by var_id.var_name,  var_id.var_desc
