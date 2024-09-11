exec [CLSA].[WMS_sp_getPedidosEntrega] 'WEB' , 'pruebapma', 'R' , '20240101' , '20240807','P51-10062827' , 'B-51' 
exec [CLSA].[WMS_sp_getPedidosEntrega] 'WEB' , 'pruebapma', 'FF' , '20240101' , '20240807','P51-10062827' , 'B-51' 
exec [CLSA].[WMS_sp_getPedidosEntrega] 'WEB' , 'pruebapma', 'EPK' , '20240101' , '20240807','P51-10062827' , 'B-51' 
EXEC [CLSA].[WMS_sp_getDetalle_ContEntrega] 'P01-19942419'; --Detalle de pedidos

SELECT  *  FROM [CLSA].[WMS_CONTROL_ENTREGA]
  where consecutivo ='P51-10062727'

exec [CLSA].[WMS_sp_InsertUpdate_ControlDeEntrega] 'W','pruebapma','N','WMS_PK','P51-10062656', 'B-51', '"[{"ARTICULO":"33390","CANT_CONSEC":1,"CANT_LEIDA":1},{"ARTICULO":"17801-3360P","CANT_CONSEC":1,"CANT_LEIDA":1},{"ARTICULO":"57080","CANT_CONSEC":1,"CANT_LEIDA":1}]"]','G';	
exec [CLSA].[WMS_sp_InsertUpdate_ControlDeEntrega] 'W','pruebapma','N','WMS_PK','P51-10062656', 'B-51', '"[{"ARTICULO":"33390","CANT_CONSEC":1,"CANT_LEIDA":1},{"ARTICULO":"17801-3360P","CANT_CONSEC":1,"CANT_LEIDA":1},{"ARTICULO":"57080","CANT_CONSEC":1,"CANT_LEIDA":1}]"]','A';	

SELECT  *  FROM [CLSA].[WMS_CONTROL_ENTREGA]
  where consecutivo ='P51-10062656'