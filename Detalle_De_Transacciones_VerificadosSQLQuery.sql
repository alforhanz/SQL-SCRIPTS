--PROCEDURE CLSA.WMS_sp_getDetalle_Traslados_Verificados
--    -- Add the parameters for the stored procedure here
--     @pSistema    varchar(6) --1:DALBOS, WEB, ECOBRE,ECONOR,WMS
--    ,@pUsuario    varchar(50)--2:USUARIO DE SISTEMA
--    ,@pOpcion    varchar(5) --3:T:Todos, E:Entrada, S:Salida de traslados
--    ,@pBodega    varchar(5) --4:
--    ,@pFechaDesde datetime --5:
--    ,@pFechaHasta datetime --6:
--    ,@pTraslado    varchar(20) = null --7:
--    ,@pArticulo    varchar(50) = null --8:
--    --clasificaciones--
--    ,@pClase         varchar(12)=null --9:
--    ,@pMarca         varchar(12)=null --10:    
--    ,@pTipo          varchar(12)=null --11:
--    ,@pEnvase        varchar(12)=null --12:
--    ,@pVentas        varchar(12)=null --13:
--    ,@pT6            varchar(12)=null --14:
--    --transacciones--
--    ,@pTipoTransaccion    varchar(5) = null --15: null todas, T|I:Traslado, P|V:Pedido, O|C:Compreas

 exec CLSA.WMS_sp_getDetalle_Traslados_Verificados 'WMS',
													'PRUEBAPMA',
													'T',
													'B-53',
													'20250401',
													'20250425',
													NULL, 
													NULL, 
													NULL, 
													NULL, 
													NULL, 
													NULL, 
													NULL, 
													NULL,
													NULL;