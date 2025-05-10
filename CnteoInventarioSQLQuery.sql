--Verifica el codigo de barra o articulo
exec CLSA.WMS_sp_getCodigoBarraArticulo 'AMA 10W30 GL';
exec CLSA.WMS_sp_getCodigoBarraArticulo '657699710774';
exec CLSA.WMS_sp_getCodigoBarraArticulo 'GRODSON 68 BAL';
exec CLSA.WMS_sp_getCodigoBarraArticulo null;

--Guarda las lecturas
EXEC [CLSA].[WMS_sp_InsertUpdate_DatosInventario_Web] 
'PRUEBAPMA',
'I',
'B-01',
'G',
'20241119',
'[{"ARTICULO":"AMA 10W30 GL","CODIGO_BARRA":"657699710774","CANTIDAD_LEIDA":16}]',
NULL;



EXEC clsa.WMS_sp_getInventario_web 'WMS','PRUEBAPMA','D','B-81','20241204',NULL,'S',null;
EXEC clsa.WMS_sp_getInventario_web 'WMS','PRUEBAPMA','R','B-81','20241204',NULL,'S',null;

EXEC clsa.WMS_sp_getInventario_web 'WEB','PRUEBAPMA','B-81','20221112',NULL,'S',null;

SELECT *
FROM CLSA.WMS_INVENTARIO_DETALLE
WHERE ESTADO = 'P'

UPDATE CLSA.WMS_INVENTARIO_DETALLE
SET ESTADO = 'G'
WHERE ESTADO = 'P';


DELETE FROM CLSA.WMS_INVENTARIO_DETALLE
WHERE UBICACION = '010103JF';



 exec [CLSA].[WMS_sp_getFechas_Inventario] 'B-81', NULL

 --Eliminar 
 
EXEC clsa.WMS_sp_getInventario_web 'WEB','PRUEBAPMA','B-81','20241204',NULL,'S',null;
EXEC [CLSA].[WMS_sp_Delete_DatosInventario_Web] 'PRUEBAPMA','B-81','20241204','{"articulo":"33224215001Zd","cantidad":24,"ubicacion":"01-05-03"}'

EXEC [CLSA].[WMS_sp_InsertUpdate_DatosInventario_Web] 
'PRUEBAPMA',
'I',
'B-81',
'P',
'20221112',
'[{"ARTICULO":"17.5R25 HIL","DESCRIPCION":"LLANTA HILO B01N **L-3/E-3**","BARCODEQR":"17.5R25 HIL","CONTEO":1,"UBICACION":"010103JF"},
{"ARTICULO":"235/65R16 FR","DESCRIPCION":"LLANTA FRONWAY VANPLUS 09 115/113R 8L","BARCODEQR":"235/65R16 FR","CONTEO":1,"UBICACION":"010103JF"},
{"ARTICULO":"AMA 10W30 GL","DESCRIPCION":"AMALIE IMPERIAL TURBO 10W30 UNI GALON SN,SM/CF","BARCODEQR":"657699710774","CONTEO":1,"UBICACION":"010103JF"}]',
NULL;


