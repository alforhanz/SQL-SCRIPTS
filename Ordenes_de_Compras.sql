------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
--											MODULOS DE ORDENES DE COMPRA													--
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------

--ALTER PROCEDURE [CLSA].[WMS_sp_getOrdenesCompras]
--	-- Add the parameters for the stored procedure here
--  @pSistema		 varchar(5) --D:Desktop CLSA, W:CLSAWEB, ECO, WMS 
-- ,@pUsuario      varchar(10)
-- ,@pOpcion		 varchar(5) --E:Encabezado, D:detallado, P:Procesados 
-- ,@pBodega       varchar(5) = null --Codigo de bodega de usuario
-- ,@pEstado       varchar(20)= 'E'--tipo de estados: 'A: PLANEADA', 'R: RECIBIDA', 'E: TRANSITO', 'I: BackOrder' 
-- ,@pOrden        varchar(50)=null --consecutivo de orden de compra, nombre de proveedor 
-- ,@pFechaDesde	 datetime = null 
-- ,@pFechaHasta	 datetime = null
--AS

--EXEC [CLSA].[WMS_sp_getOrdenesCompras] 'WMS','pruebapma','E','B-54',null,null,null,null;
--EXEC [CLSA].[WMS_sp_getOrdenesCompras] 'WMS','PRUEBAPMA','P','B-81','E',null,null,null;
--EXEC [CLSA].[WMS_sp_getOrdenesCompras] 'WMS','pruebapma','D','B-54',null,'OC-0036910',null,null;;
--EXEC [CLSA].[WMS_sp_getOrdenesCompras] 'WMS',null,'D',null,null,'OC-0036910',null,null;;

------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
--										GUARDADO Y PROCESADO DE ORDENES DE COMPRA											--
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------

--ALTER PROCEDURE [CLSA].[WMS_sp_InsertUpdate_ControlEntrega_OrdenCompra]
--	--// Los datos de salidas son: 1: Registros Guardados  ;  2: Registros Actualizados   ;  3: Registros Procesados/Validados
--	 @pSistema			varchar(5)				--// W: sistema web
--	,@pUsuario			varchar(10)
--	,@pOpcion			varchar(5)				--// G: GUARDADO ; P: PROCESADO ; E: Eliminación de Registro
--	--
--	,@pModulo			varchar(6)				--// WMS_VC: Verificación de Pedidos ; WMS_TR:  Verificación de Traslados; WMS_OC:  Verificación de Ordenes de Compra
--	,@pConsecutivo		varchar(50)             --// Consecutivos de Embarque
--	,@pArticulo			varchar(20)				--// Artículo 
--	,@pLineaConsec		DECIMAL (8,2) = 0					--// Se envía la cantidades del pedido
--	,@pLineaConteo		DECIMAL (8,2) =0					--// Se envia la cantidades de Verificadas
--	,@pEstado			varchar(5) = null	     --// Estado del Pedido   N: Sin Facturar aun está en Pedido de tipo de documento = P  ; F: Facturado
--	,@pBodega			varchar(5)=null		
--AS
--BEGIN


--EXEC [CLSA].[WMS_sp_InsertUpdate_ControlEntrega_OrdenCompra] 'WMS','pruebapma','G','WMS_BC','OC-0036957','AMA 5W-30 QT',24,1,NULL,'B-01';

------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
--										PRUEBAS DE ORDENES DE COMPRA											--
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
/****** Script for SelectTopNRows command from SSMS  ******/
--SELECT TOP (10) [MODULO]
--      ,[EMBARQUE]
--      ,[ARTICULO]
--      ,[BODEGA]
--      ,[ESTADO]
--      ,[COMENTARIO]
--      ,[USUARIO]
--      ,[REVISADOPOR]
--      ,[APROBADOPOR]
--      ,[LINEA_CONTADAS]
--      ,[LINEA_CONSEC_CONTADOS]
--      ,[CreatedBy]
--      ,[CreatedDate]
--      ,[RecordDate]
--  FROM [Prueba2].[CLSA].[WMS_CONTROL_ENTREGA_EMB]



--EXEC [CLSA].[WMS_sp_getOrdenesCompras] 'WMS','pruebapma','E','B-01',null;
--EXEC [CLSA].[WMS_sp_getOrdenesCompras] 'WMS','pruebapma','P',null,null;
--EXEC [CLSA].[WMS_sp_getOrdenesCompras] 'WMS','pruebapma','D','B-01','OC-0036959';
--SELECT *
--  FROM [Prueba2].[CLSA].[WMS_CONTROL_ENTREGA_EMB];
