--PROCEDURE CLSA.WMS_Detalle_Traslados_Verificados
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

EXEC CLSA.WMS_Detalle_Traslados_Verificados 'WMS','Pruebapma','T','B-51','20240101','20250331','TRAS07-00013685',null,null,null,null,null,null,null;
EXEC CLSA.WMS_Detalle_Traslados_Verificados 'WMS','Pruebapma','T','B-51','20240101','20250331',null,null,null,null,null,null,null,null;
