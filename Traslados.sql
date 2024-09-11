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
  
  
  --ENCABEZADO--

    EXEC CLSA.WMS_sp_getTrasladoMercancia  'S','R','20240101','20240905','B-01';
	EXEC CLSA.WMS_sp_getTrasladoMercancia  'E','R','20240101','20240905','B-01';

	EXEC CLSA.WMS_sp_getTrasladoMercancia 'S','E','20240101','20240903','B-01';
	EXEC CLSA.WMS_sp_getTrasladoMercancia 'E','E','20240101','20240903','B-01';

-- DETALLADO--
    EXEC CLSA.WMS_sp_getTrasladoMercancia 'E','D','20210101','20240903','B-01','TRAS01-00059408';

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
--		INSERT PARA GUARDADO PARCIAL Y PROCESADO DE LOS TRASLADOS
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
exec [CLSA].[WMS_sp_InsertUpdate_ControlEntrega_Traslado] 'WMS','PDT51NOR','N','WMS_VT','TRAS52-0028875', 'B-52', '[{"ARTICULO":"265/70R16 KHM","CANT_CONSEC":16,"CANT_LEIDA":15}]','G';

Select * FROM CLSA.WMS_CONTROL_ENTREGA_TRAS
