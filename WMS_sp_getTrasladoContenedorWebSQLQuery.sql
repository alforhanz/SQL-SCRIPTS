/*
ALTER PROCEDURE [CLSA].[WMS_sp_getTrasladoContenedorWeb]
	-- Add the parameters for the stored procedure here	
     @pSistema		varchar(5) --WMS
	,@pUsuario		varchar(50) --PRUEBAPMA
	,@pOpcion		varchar(5)	--// E: Muestra el Encabezado o Resumen de los Contenedores ;L: Muestra el Detalle o las líneas del contenedor
	,@pBodegaEnvia		varchar(5)		= null --Bodega quien lo envia
	,@pBodegaSolicita	varchar(5)		= null --Bodega/tienda quien lo solicita
	,@pConsecutivo		varchar(50)		= null --Consecutivo del contenedor o de traslados
	--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////--
	,@pEstado			VARchar(5)		= null --Estado de contenedor
	,@pFechaDesde		datetime		= null --fecha inicio de la consulta
	,@pFechaHasta		datetime		= null --fecha final de la consulta
	--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////--
AS
BEGIN
*/--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////--

exec [CLSA].[WMS_sp_getTrasladoContenedorWeb] 'WMS', 'PRUEBAPMA', 'E', NULL, NULL, NULL, NULL, '20230101', '20241120'		---// Muestra el resumen de los contenedores según el usuario y el rango de fecha

exec [CLSA].[WMS_sp_getTrasladoContenedorWeb] 'WMS', 'PRUEBAPMA', 'L', NULL, NULL, 'M81-0000015402', NULL, NULL, NULL		---// Muestra el Detalle o las líneas que tiene el contenedor seleccionado

select * from CLSA.WMS_CONTROL_ENTREGA_CONTENEDOR 
where Contenedor = 'M81-0000015402';