  EXEC CLSA.WMS_sp_getTrasladoMercancia 'WMS_VT','E','R','20240101','20240919','B-01'; --ENCABEZADO DE ENTRADA
  EXEC CLSA.WMS_sp_getTrasladoMercancia 'WMS_VT','E','TP','20240101','20240919','B-01'; --ENCABEZADO DE ENTRADA PROCESADOS
  EXEC CLSA.WMS_sp_getTrasladoMercancia 'WMS_VT','E','D','20210101','20240919','B-01','TRAS01-00059389';--DETALLADO ENTRADA

    exec [CLSA].[WMS_sp_InsertUpdate_ControlEntrega_Traslado] 'WMS','PRUEBAPMA',
																'B',
																'WMS_VT',
																'TRAS01-00059403', 
																'B-01', 
																'[{"ARTICULO":"195/65R15 M","CANTIDAD_LEIDA":3}]',
																'G',
																'E',
																'B-04',
																'TRAS04-00039362';


  Select * FROM CLSA.WMS_CONTROL_ENTREGA_TRAS where CONSECUTIVO='TRAS01-00059408'

  exec [CLSA].[WMS_sp_InsertUpdate_ControlEntrega_Traslado] 'WMS',
															'PRUEBAPMA',
															'B','WMS_VT',
															'TRAS01-00059403',
															'B-01', 
															'[{"ARTICULO":"195/65R15 M","CANTIDAD_LEIDA":3}]',
															'P',
															'E',
															'B-04',
															'TRAS04-00039362';

  ----------Verificacion de picking de traslados----------------------------------------------------------------------------------------------------------------------------------------------

  EXEC CLSA.WMS_sp_getTrasladoMercancia 'WMS_VT','S','R','20240101','20241114','B-04'; --ENCABEZADO DE SALIDA
  EXEC CLSA.WMS_sp_getTrasladoMercancia 'WMS_VP',--DETALLADO SALIDA
										'S',
										'D',
										'20210101',
										'20241114',
										'B-04',
										'TRAS04-00042374';

  exec [CLSA].[WMS_sp_InsertUpdate_ControlEntrega_Traslado] 'WMS','PRUEBAPMA',
								'B',
								'WMS_VT',
								'TRAS04-00042374', 
								'B-04', 
								'[{"ARTICULO":"BAT RECI 2","CANT_CONSEC":"1.00","CANT_LEIDA":"1"},
									{"ARTICULO":"BAT RECI 3","CANT_CONSEC":"3.00","CANT_LEIDA":"3"},
									{"ARTICULO":"BAT RECI 5","CANT_CONSEC":"1.00","CANT_LEIDA":"1"},
									{"ARTICULO":"BAT RECI 7","CANT_CONSEC":"1.00","CANT_LEIDA":"1"}]',
								'G','S','B-81','TRAS81-0000028466';


 exec [CLSA].[WMS_sp_InsertUpdate_ControlEntrega_Traslado] 'WMS','PRUEBAPMA','B','WMS_VT','TRAS01-00059403', 'B-01', '[{"ARTICULO":"195/65R15 M","CANTIDAD_LEIDA":3}]','P','S','B-04','TRAS04-00039362';

  Select * FROM CLSA.WMS_CONTROL_ENTREGA_TRAS where CONSECUTIVO='TRAS04-00042374'


  UPDATE CLSA.WMS_CONTROL_ENTREGA_TRAS 
SET ESTADO = 'G' 
WHERE CONSECUTIVO = 'TRAS04-00042374' AND ESTADO = 'A';
