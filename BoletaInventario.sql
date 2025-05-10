-- ///////////////////Presentar Boleta /////////////////////////////////////
EXEC clsa.sp_getArticulos_Inventario_boleta 'WMS',--pSistema
											'pruebapma',--pUsuario
											'D', --TipoConsulta
											'2025-01-27',--FechaProceso
											'B-81',--Bodega
											'S',--SoloDiferencia
											'N'; --SoloConteoCero

-- ///////////////////////   VALIDAR BOLETA ///////////// 
EXEC clsa.sp_getArticulos_Inventario_boleta 'WMS',--pSistema
											'pruebapma',--pUsuario
											'R', --TipoConsulta
											'2025-01-27',--FechaProceso
											'B-81',--Bodega
											'S',--SoloDiferencia
											'N'; --SoloConteoCero

exec CLSA.sp_update_costueps_inventory 'WMS','pruebapma', 'S', null, null, null;--Se ejecuta el sp de costos, que permite actualizar los costos y cantidades antes de crear el paquete
--Respuesta: Costos actualizados, 111 registros.
EXEC CLSA.sp_Generar_InventarioFisico_Boleta	'WMS',
												'pruebapma',
												'I',
												'2025-01-27',
												'B-81', 
												'S',
												null,
												null;-- sigue la ejecucion de la creacion de BOLETA
exec clsa.sp_getInventario_Actual_Bodega 'WMS','pruebapma', 'U', 'N','B-81','2025-01-27',NULL,NULL; --Si se fallo al inicio, en la actualizacion de costos, debe ejecutarse el proceso de busqueda de errores
exec CLSA.sp_Generar_InventarioFisico_Boleta_ERRORES 'WMS','PRUEBAPMA','I','20180106','B-81','S',NULL, NULL;--si por alguna razon falla la actualizacion de costos, se ejecutara otro proceso que es de los errores



sELECT * FROM clsa.WMS_INVENTARIO_DETALLE
WHERE CONSECUTIVO IS NOT NULL; 

UPDATE A SET A.CONSECUTIVO = NULL
FROM clsa.WMS_INVENTARIO_DETALLE A
WHERE CONSECUTIVO IS NOT NULL;


select * from CLSA.INVENTARIO_DET_ERRORES

select * from CLSA.wms_errores order by 1 desc

select * from  BREMEN.BOLETA_INV_FISICO order by 1 desc

delete from  BREMEN.BOLETA_INV_FISICO
where FECHA_HORA = '2025-02-13 00:00:00.000'

select * from BREMEN.PISTA_EXISTEN_DET order by 1 desc

delete from BREMEN.PISTA_EXISTEN_DET
where FECHA = '2025-02-15 23:59:59.000'