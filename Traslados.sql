ALTER PROCEDURE [CLSA].[WMS_sp_getTrasladoMercancia]
	-- Add the parameters for the stored procedure here
	  @pOpcion		as varchar(1) --Tipo de consulta E:Entrada, S:Salida
	, @typeRpt		as char(1)	  --E:Encabezado/Resumido, D:Detallado, TP: Traslados Procesados
	, @fechaIni		as datetime  
	, @fechaFin		as datetime 
	, @BodegaOrigen as varchar(5) = null 
	, @Aplicacion	as varchar(100)=null
AS
BEGIN
  
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------										VERIFICACION DE PREPARACION DE TRASLADOS
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
  --ENCABEZADO--
  
	EXEC CLSA.WMS_sp_getTrasladoMercancia 'WMS_VP','S','R','20240101','20240911','B-01'; --ENCABEZADO-- 

	EXEC CLSA.WMS_sp_getTrasladoMercancia 'WMS_TP','S','R','20240101','20240911','B-01';   --ENCABEZADO--PREPARADOS

-- DETALLADO--
    EXEC CLSA.WMS_sp_getTrasladoMercancia 'WMS_VP','S','D','20210101','20240919','B-01','TRAS01-00059401';

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
------			INSERT PARA PICKING GUARDADO Y PREPARADO ESTADOS(G,A)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

    exec [CLSA].[WMS_sp_InsertUpdate_ControlEntrega_Traslado] 'W','PRUEBAPMA','B','WMS_PK','TRAS01-00059409', 'B-01', '[{"ARTICULO":"WL-10457A","CANT_CONSEC":12,"CANT_LEIDA":4}]','G','S','B-04','TRAS04-00039362';

 
 -------------------------------------------------------------------------------------------------------------------------------------------------------------------
 -------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------									VERIFICACION DE TRASLADOS ENTRADA Y SALIDA-PREPARADOS
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

					--PREPARADOS POR VERIFICAR, PREPARADOS GUARDADOS

  EXEC CLSA.WMS_sp_getTrasladoMercancia 'WMS_VT','E','R','20240101','20240919','B-01'; --ENCABEZADO DE ENTRADA
  EXEC CLSA.WMS_sp_getTrasladoMercancia 'WMS_VP','E','D','20210101','20240919','B-01','TRAS01-00059403';--DETALLADO ENTRADA

  EXEC CLSA.WMS_sp_getTrasladoMercancia 'WMS_VT','S','R','20240101','20240919','B-01'; --ENCABEZADO DE SALIDA
  EXEC CLSA.WMS_sp_getTrasladoMercancia 'WMS_VP','S','D','20210101','20240919','B-01','TRAS01-00059403';--DETALLADO SALIDA

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
									--PREPARADOS VERIFICADOS PROCESADOS
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
  EXEC CLSA.WMS_sp_getTrasladoMercancia 'WMS_TP','E','R','20240101','20240919','B-01'; --ENCABEZADO DE ENTRADA
  EXEC CLSA.WMS_sp_getTrasladoMercancia 'WMS_TP','E','D','20210101','20240919','B-01','TRAS01-00059408';--DETALLADO ENTRADA

  EXEC CLSA.WMS_sp_getTrasladoMercancia 'WMS_TP','S','R','20240101','20240919','B-01'; --ENCABEZADO DE SALIDA
  EXEC CLSA.WMS_sp_getTrasladoMercancia 'WMS_TP','S','D','20210101','20240919+','B-01','TRAS01-00059403';--DETALLADO SALIDA

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
------			INSERT PARA GUARDADO Y PRPROCESADO DE TRASLADOS DE ENTRADA Y SALIDA CON ESTADOS(G,A,P)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
--ALTER PROCEDURE [CLSA].[WMS_sp_InsertUpdate_ControlEntrega_Traslado]
--	--// Los datos de salidas son: 1: Registros Guardados  ;  2: Registros Actualizados   ;  3: Registros Procesados/Validados
--	 @pSistema			varchar(5)				--// W: sistema web, WMS
--	,@pUsuario			varchar(10)				--// Usuario de Sistema logeado //--
--	,@pOpcion			varchar(5)				--// B:Bremen, N:Norwing //--
--	--
--	,@pModulo			varchar(6)				--// WMS_VT: Verificación de Traslado ; WMS_VP:  Verificación de Picking; WMS_OC:  Verificación de Ordenes de Compra
--	,@pConsecutivo		varchar(50)             --// Consecutivos de Pedido
--	,@pBodega			varchar(5)              --// Bodega de Origen // --
--  ,@jsonDetalles		nvarchar(max)       	--// Se envia la trama de json con una lista de referencias del pedido
--	,@pEstado			varchar(5)    			--// G: GUARDADO ; P: PROCESADO ; E: Eliminación de Registro, A:Arreglado--//
--	,@pTipoConsecutivo	varchar(1)				--// E:Entrada de mercancia, S:Salida de mercancia
--	,@pBodegaDestino	varchar(5)  			--//Bodega de Destino 
--	,@pAplicacion		varchar(50) = null		--//Consecutivo de traslado de recepcion o de Entrada(E)	
--AS
    
exec [CLSA].[WMS_sp_InsertUpdate_ControlEntrega_Traslado] 'WMS','PRUEBAPMA','B','WMS_VT','TRAS01-00059409', 'B-01', '[{"ARTICULO":"WL-10457A","CANT_CONSEC":12,"CANT_LEIDA":4}]','G','S','B-04','TRAS04-00039362';



 
Select * from CLSA.WMS_ERRORES order By 1 desc

Select * FROM CLSA.WMS_CONTROL_ENTREGA_TRAS where CONSECUTIVO='TRAS01-00059408'


EXEC CLSA.WMS_sp_getTrasladoMercancia 'WMS_TP','E','R','20240101','20240912','B-01';
EXEC CLSA.WMS_sp_getTrasladoMercancia 'WMS_TP','S','R','20240101','20240912','B-01';

select * from  dbo.ADMIN_NOTIFICACION where USUARIO = 'pruebapma';