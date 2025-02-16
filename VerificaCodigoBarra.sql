USE [Prueba2]
GO
/****** Object:  StoredProcedure [CLSA].[sp_getCodigoBarraArticulo]    Script Date: 07/09/2024 8:44:01 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [CLSA].[sp_getCodigoBarraArticulo] 
	-- Add the parameters for the stored procedure here
	 @pCodigoBarra varchar(50) ---// Codigo de barra o  Codigo de Artículo.
	,@pArticulo varchar(50)=null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	-- RESPUESTA:	CE:Codigo existe
	--				ND: Articulo no existe
	--				AE: Articulo existe
    -- Insert statements for procedure here
	if(select count(*) 
	from CLSA.ARTICULO_CODIGOBARRA c with(nolock)

	where c.codigo_barra=@pCodigoBarra)>0 --cuando hay codigo de barra creado del articulo	
			
			select 'CE' -- 'CE:Codigo existe'
			from CLSA.ARTICULO_CODIGOBARRA c with(nolock)
			where c.codigo_barra=@pCodigoBarra	

	else 

	begin --cuando no hay codigo de barra creado del articulo	
	if @pArticulo is not null  --valida el articulo si esta creado--
	
		 select case when (select count(*)
		 from CLSA.ARTICULO_CODIGOBARRA c with(nolock)
		 where c.articulo=@pArticulo)>0 then 'AE' else 'ND' end as Articulo
		 else --el articulo no existe en el sistema
	
	select 'ND' as Articulo;
	end
END
