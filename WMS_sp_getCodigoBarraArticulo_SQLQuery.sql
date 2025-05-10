exec CLSA.WMS_sp_getCodigoBarraArticulo 'AMA 10W30 GL';
exec CLSA.WMS_sp_getCodigoBarraArticulo '657699710774';
exec CLSA.WMS_sp_getCodigoBarraArticulo 'GRODSON 68 BAL';
exec CLSA.WMS_sp_getCodigoBarraArticulo null;


EXEC [CLSA].[WMS_sp_InsertUpdate_DatosInventario_Web] 
'PRUEBAPMA',
'I',
'B-01',
'G',
'20241119',
'[{"ARTICULO":"AMA 10W30 GL","CODIGO_BARRA":"657699710774","CANTIDAD_LEIDA":16}]',
NULL;



EXEC clsa.WMS_sp_getInventario_web 'WEB','PRUEBAPMA','B-81','20241204',NULL,'S',null;

EXEC clsa.WMS_sp_getInventario_web 'WEB','PRUEBAPMA','B-81','20221112',NULL,'S',null;

SELECT *
FROM CLSA.WMS_INVENTARIO_DETALLE


 exec [CLSA].[WMS_sp_getFechas_Inventario] 'B-04', NULL

