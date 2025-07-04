USE [Prueba2]
GO
/****** Object:  StoredProcedure [CLSA].[sp_getEmbarques]    Script Date: 09/18/2024 9:11:22 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
EXEC [CLSA].[sp_getEmbarques] 'E','EM00035306';
*/
ALTER PROCEDURE [CLSA].[sp_getEmbarques] 
	-- Add the parameters for the stored procedure here
	 @pOpcion      char(1)  -- s:select o consulta, <>s: insert|update|delete 	
	,@pEmbarque    varchar(20) 
	,@pEstado      char(1)=null
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    -- Insert statements for procedure here
	if (select count(*) from bremen.embarque e with(nolock) where e.embarque=@pEmbarque)>0  
	select e.embarque, e.proveedor, e.estado, e.liquidado, e.referencia
	, el.EMBARQUE_LINEA, el.ORDEN_COMPRA, el.ARTICULO, el.BODEGA
	, el.CANTIDAD_EMBARCADA, el.CANTIDAD_RECIBIDA, el.CANTIDAD_RECHAZADA
	, el.COST_UN_FISC_LOCAL, el.COST_UN_ESTI_COMP_LOCAL, el.COST_UN_ESTI_LOCAL
	, el.PRECIO_UNITARIO, el.SUBTOTAL, el.IMPUESTO1, e.FECHA_EMBARQUE	
	, b.NOMBRE as NOMBRE_BODEGA
	from bremen.embarque e with(nolock)
	inner join bremen.EMBARQUE_LINEA el with(nolock) on (e.embarque=el.EMBARQUE)
	inner join BREMEN.BODEGA b with(nolock) on (el.BODEGA=b.BODEGA)
	where e.embarque =@pEmbarque	
	and ( ( @pOpcion='S' and e.ESTADO =isnull(@pEstado, e.ESTADO)) 
	or    ( @pOpcion<>'S' and e.ESTADO not in ('R') )
	)
	else
	select 'No existe consecutivo de embarque' as mensaje
END
