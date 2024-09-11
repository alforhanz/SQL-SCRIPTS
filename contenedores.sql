USE [Prueba3]
GO
/****** Object:  StoredProcedure [CLSA].[WMS_sp_getTrasladoContenedorWeb]    Script Date: 03/11/2024 4:51:15 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
************ Procedimiento que se encarga de mostrar los contenedores/Muelles que son creados, para que el personal de bodega, busque y revise las líneas que debe verificar.

exec [CLSA].[WMS_sp_getTrasladoContenedorWeb] 'W', 'PDT03', 'E', NULL, NULL, NULL, NULL, '20230901', '20231010'		---// Muestra el resumen de los contenedores según el usuario y el rango de fecha

exec [CLSA].[WMS_sp_getTrasladoContenedorWeb] 'W', 'PDT03', 'L', NULL, NULL, 'M81-0000013079', NULL, NULL, NULL		---// Muestra el Detalle o las líneas que tiene el contenedor seleccionado


*/



ALTER PROCEDURE [CLSA].[WMS_sp_getTrasladoContenedorWeb]
	-- Add the parameters for the stored procedure here
	 @pSistema			varchar(5)
	,@pUsuario			varchar(50)
	,@pOpcion			varchar(5)				--// E: Muestra el Encabezado o Resumen de los Contenedores ; L: Muestra el Detalle o las líneas del contenedor
	,@pBodegaEnvia		varchar(5)		= null
	,@pBodegaSolicita	varchar(5)		= null
	,@pTraslado			varchar(50)		= null
	--////////////////////////////////--
	,@pEstado			VARchar(5)		= null
	,@pFechaDesde		datetime		= null
	,@pFechaHasta		datetime		= null
	--/////////////////////////////////--
AS
BEGIN
	SET NOCOUNT ON;    
	--//// busca contenedores guardadas que no se han creados documentos o paquetes ////--	
	declare @vCountContenedorabierto as int=(select Count(distinct m.Muelle) from clsa.TRASLADO_MUELLE m with(nolock) 
											 inner join clsa.traslado_muelle_linea ml with(nolock) on (m.Muelle=ml.Id_Muelle)
											 where  m.Estado in ('L')  ----,'A','P'	
											 and ml.Bodega_CEDI=isnull(@pBodegaEnvia,ml.Bodega_CEDI)
											 and m.Bodega_Solicita=isnull(@pBodegaSolicita,m.Bodega_Solicita)											 
											 )		
	if @pOpcion='D' --Delete
	begin
	    select @vCountContenedorabierto as total, 'Hay ' + cast(@vCountContenedorabierto as varchar) + ' contenedores guardados, para crear documentos o paquetes.' as mensaje;
	end
	if @pOpcion='E' --RESUMIDO|ENCABEZADO
	begin
	    --///////// CONTENEDORES NUEVOS Y SIN CANTIDADES CARGADAS ///////////////--
	    if (@pEstado is null or @pEstado = 'N') 
		begin
		select t.* 		
		, (Select distinct te.nombre from CLSA.TRASLADO_ESTADO te with(nolock) Where te.estado=
		  (case when t.estado ='SC' then 'A' 
				when t.estado ='DP' then 'TR' 
				when t.estado ='E' then 'F' 
				when t.Cargada='S' then 'L'				
		   else t.ESTADO end)) as Estado_Pedido
		, (case when t.estado ='N' then 'SA' else 'SC' end) as Estado_Sistema
	    , (Select distinct te.nombre from CLSA.TRASLADO_ESTADO te with(nolock) where te.estado=
		  (case when t.estado ='N' then 'SA' 
				when t.estado ='DP' then 'P' 
				when t.estado in ('E','F') then 'E' 
				when t.estado ='C' then 'SF' 
				else 'SC' end)) as Estado_Lineas
		from ( 
				SELECT distinct t.Muelle as Traslado, t.Bodega_Solicita 
				,tl.Bodega_CEDI as Bodega_Envia
				, t.Estado
				, t.Usuario
				,t.CreateDate as Fecha_Creacion
				,t.CreatedBy as Usuario_Creacion
				,0 as Porc_Preparacion 
				,case when PL.ESTADO is not null then 'S' else 'N' end as Cargada			
				FROM CLSA.TRASLADO_MUELLE t with(nolock)
				Inner join CLSA.TRASLADO_MUELLE_LINEA tl with(nolock) on (t.Muelle=tl.Id_Muelle)
				left  join 
				  (
					select distinct pl.Contenedor, pl.usuario, ml.Bodega as Bodega_Solicita, ml.Bodega_CEDI, PL.ESTADO
					from clsa.traslado_pdt_linea pl with(nolock)
					inner join clsa.TRASLADO_MUELLE_LINEA ml with(nolock) on (pl.Contenedor=ml.Id_Muelle and pl.Contenedor_Linea=ml.Muelle_Linea)
					where (ml.id_Muelle=ISNULL(@pTraslado,ml.id_Muelle)) 
					and convert(varchar(10),ml.CreatedDate,112) between CONVERT(varchar(10),isnull(@pFechaDesde,getdate()-300),112) AND CONVERT(varchar(10),isnull(@pFechaHasta,getdate()),112)
					and (ml.Bodega=ISNULL(@pBodegaSolicita,ml.Bodega))
					and (ml.Bodega_CEDI=ISNULL(@pBodegaEnvia,ml.Bodega_CEDI) )				
					--			
				   ) pl on (pl.Contenedor=tl.Id_Muelle and pl.Bodega_Solicita=tl.Bodega and pl.Bodega_CEDI=tl.Bodega_CEDI and pl.Usuario=@pUsuario)
				where tl.Bodega_CEDI<>''-- is not null
				and (t.Muelle=ISNULL(@pTraslado,t.Muelle) or 
					 tl.Id_Traslado=ISNULL(@pTraslado,tl.id_Traslado) )		
				and convert(varchar(10),t.CreateDate,112) between CONVERT(varchar(10),isnull(@pFechaDesde,getdate()-300),112) AND CONVERT(varchar(10),isnull(@pFechaHasta,getdate()),112)
				and (t.Bodega_Solicita=ISNULL(@pBodegaSolicita,t.Bodega_Solicita))
				and (tl.Bodega_CEDI=ISNULL(@pBodegaEnvia,tl.Bodega_CEDI) )		
				and (t.Usuario=@pUsuario)
				--Validacion de estados--por defecto-N,A,L--		
				and ( (@pEstado is null and t.Estado in ('N','A','L'))
				  OR  (@pEstado is not null and t.Estado in (@pEstado,'N') ) )
				--
				and isnull(pl.estado,'N') not in ('A','V') --EXCEPTO LOS APLICADOS(A) Y VERIFICADOS(V)
		
		) t inner join CLSA.TRASLADO_ESTADO e with(nolock) on (t.Estado=e.estado)						
		order by t.Traslado asc
		;
	--	select 'Estado,Estado_Sistema,Usuario,Bodega_Envia,Usuario_Creacion,Porc_Preparacion,Cargada' as hidecolumn,'' as showcolumn
		;
		end
	
	--///////// CONTENEDORES LEIDOS Y CON CANTIDADES CARGADAS ///////////////--
		if (@pEstado is not null AND @pEstado <> 'N')
		begin
		    select t.* 		
		, (Select distinct te.nombre from CLSA.TRASLADO_ESTADO te with(nolock) Where te.estado=
		  (case when t.estado ='SC' then 'A' 
				when t.estado ='DP' then 'TR' 
				when t.estado ='E' then 'F' 
		   else t.ESTADO end)) as Estado_Pedido
		, (case when t.estado ='N' then 'SA' else 'SC' end) as Estado_Sistema
	    , (Select distinct te.nombre from CLSA.TRASLADO_ESTADO te with(nolock) where te.estado=
		  (case when t.estado ='N' then 'SA' 
				when t.estado ='DP' then 'P' 
				when t.estado in ('E','F') then 'E' 
				when t.estado ='C' then 'SF' 
				else 'SC' end)) as Estado_Lineas
		from ( 
				SELECT distinct t.Muelle as Traslado, t.Bodega_Solicita 
				,tl.Bodega_CEDI as Bodega_Envia
				, t.Estado
				, t.Usuario
				,t.CreateDate as Fecha_Creacion
				,t.CreatedBy as Usuario_Creacion
				,0 as Porc_Preparacion 
				,case when pl.contenedor is not null then 'S' else 'N' end as Cargada
		
				FROM CLSA.TRASLADO_MUELLE t with(nolock)
				Inner join CLSA.TRASLADO_MUELLE_LINEA tl with(nolock) on (t.Muelle=tl.Id_Muelle)
				INNER  join (
					select distinct pl.Contenedor, pl.usuario, pl.estado, ml.Bodega as Bodega_Solicita, ml.Bodega_CEDI
					from clsa.traslado_pdt_linea pl with(nolock)
					inner join clsa.TRASLADO_MUELLE_LINEA ml with(nolock)
					on (pl.Contenedor=ml.Id_Muelle and pl.Contenedor_Linea=ml.Muelle_Linea)
					where (ml.id_Muelle=ISNULL(@pTraslado,ml.id_Muelle)) 
					and convert(varchar(10),pl.Fecha_Aprobacion,112) between CONVERT(varchar(10),isnull(@pFechaDesde,getdate()-5),112) AND CONVERT(varchar(10),isnull(@pFechaHasta,getdate()),112)
					and (ml.Bodega=ISNULL(@pBodegaSolicita,ml.Bodega))
					and (ml.Bodega_CEDI=ISNULL(@pBodegaEnvia,ml.Bodega_CEDI) )				
				) pl on (pl.Contenedor=tl.Id_Muelle and pl.Bodega_Solicita=tl.Bodega and pl.Bodega_CEDI=tl.Bodega_CEDI)
				where tl.Bodega_CEDI<>''-- is not null
				and (t.Muelle=ISNULL(@pTraslado,t.Muelle) or 
					 tl.Id_Traslado=ISNULL(@pTraslado,tl.id_Traslado) )		
			--	and convert(varchar(10),t.CreateDate,112) between CONVERT(varchar(10),isnull(@pFechaDesde,getdate()-300),112) AND CONVERT(varchar(10),isnull(@pFechaHasta,getdate()),112)
				and (t.Bodega_Solicita=ISNULL(@pBodegaSolicita,t.Bodega_Solicita))
				and (tl.Bodega_CEDI=ISNULL(@pBodegaEnvia,tl.Bodega_CEDI) )				
				--Validacion de estados--por defecto-N,A,L--		
				and ( (@pEstado is null and t.Estado in ('N','A','L'))
				       OR  (@pEstado is not null and t.Estado in (@pEstado,'N') ) )	        
				--
				and pl.estado in ('A','V')
		) t inner join CLSA.TRASLADO_ESTADO e with(nolock) on (t.Estado=e.estado)		
		order by t.Traslado asc
		;
	--	select 'Estado,Estado_Sistema,Usuario,Bodega_Envia,Usuario_Creacion,Porc_Preparacion,Cargada' as hidecolumn,'' as showcolumn
		;
		end
	end
	if @pOpcion='L' --DETALLADO|LINEA
	begin	   		
	   select tl.*	   
	   --, e.nombre as Estado_Pedido
	   --, b.NOMBRE as Nombre_Bodega
	   --, (case when tl.E_M  ='N' then 'SA' else 'SC' end) as Estado_Sistema
	   --, (Select te.nombre from CLSA.TRASLADO_ESTADO te with(nolock) 
	   --   where te.estado=(case when tl.E_M ='N' then 'SA' else 'SC' end)
	   --) as Estado_Lineas
	   from(
		SELECT distinct ml.Id_Traslado as Traslado
		, a.Articulo, a.DESCRIPCION as Descripcion			
		,(ml.Cantidad_Enviada) as Cantidad		
		,ceiling(eb.CANT_DISPONIBLE) as total_cedi		
		,'' as Codigo_Barra
		,'' as Cantidad_Despachar
		,'' as Cant_Dif		
		,ml.Muelle_Linea		
		,m.Bodega_Solicita, tm.Estado as Estado
		--,m.Muelle		
		--, ml.Bodega_CEDI as Bodega_Envia
		--, ml.Estado as E_ML, m.Estado as E_M		
		--, ml.Cantidad_Pedida, ml.Cantidad_Enviada as Cantidad_Pendiente	
		--, m.CreateDate as Fecha_Creacion	
		from CLSA.TRASLADO_MUELLE m with(nolock)
		Inner join CLSA.TRASLADO_MUELLE_LINEA ml with(nolock) on (m.Muelle=ml.Id_Muelle)		
		inner join CLSA.TRASLADO_LINEA tl with(nolock) on (ml.Id_Traslado=tl.traslado and ml.Articulo=tl.Articulo)
		inner join CLSA.TRASLADO_MOVIMIENTO tm with(nolock) on (ml.Id_Muelle=tm.Contenedor and isnull(ml.id_movimiento,tm.ID_MOVIMIENTO)=tm.ID_MOVIMIENTO and ml.Id_Traslado= tm.Traslado and tm.Estado not in('O')) AND tl.Traslado_Linea=tm.Traslado_Linea
		inner join BREMEN.ARTICULO a with(nolock) on (tl.Articulo=a.ARTICULO)	
		left join BREMEN.EXISTENCIA_BODEGA eb with(nolock) on (tl.Articulo=eb.ARTICULO AND tl.Bodega_Envia=eb.BODEGA)
		where  (m.Muelle=ISNULL(@pTraslado,m.Muelle))
		and (m.Bodega_Solicita=ISNULL(@pBodegaSolicita,m.Bodega_Solicita)) 
		and (tm.Bodega_CEDI=ISNULL(@pBodegaEnvia,tm.Bodega_CEDI))
		and (tm.Consecutivo is not null and tm.Contenedor is not null)
		and (tm.Estado<>'PE')
		--
		and (isnumeric(tm.Consecutivo)>0)
		and ml.Consecutivo is null
		--and (ml.Estado='N')
	  ) tl		
		inner join CLSA.TRASLADO_ESTADO e with(nolock) on (tl.Estado=e.estado)		
		inner join bremen.bodega b with(nolock) on (b.BODEGA=tl.Bodega_Solicita)
		order by Articulo asc
		;
	end
	
	if @pOpcion='M' --LINEA CON MOVIMIENTOS
	begin
	   select tl.*	   	  
	   from(
		SELECT distinct ml.Id_Traslado as Traslado
		, a.Articulo, a.DESCRIPCION as Descripcion			
		,(ml.Cantidad_Enviada) as Cantidad		
		,ceiling(eb.CANT_DISPONIBLE) as total_cedi		
		,pl.codigo_barra as Codigo_Barra
		,pl.Cantidad_Cargada as Cantidad_Despachar
		,(ml.Cantidad_Enviada-pl.Cantidad_Cargada) as Cant_Dif		
		,ml.Muelle_Linea		
		,m.Bodega_Solicita, tm.Estado as Estado
		from CLSA.TRASLADO_MUELLE m with(nolock)
		Inner join CLSA.TRASLADO_MUELLE_LINEA ml with(nolock) on (m.Muelle=ml.Id_Muelle)		
		inner join CLSA.TRASLADO_LINEA tl with(nolock) on (ml.Id_Traslado=tl.traslado and ml.Articulo=tl.Articulo)
		inner join CLSA.TRASLADO_MOVIMIENTO tm with(nolock) on (ml.Id_Muelle=tm.Contenedor and isnull(ml.id_movimiento,tm.ID_MOVIMIENTO)=tm.ID_MOVIMIENTO and ml.Id_Traslado= tm.Traslado and tm.Estado not in('O')) AND tl.Traslado_Linea=tm.Traslado_Linea
		inner join BREMEN.ARTICULO a with(nolock) on (tl.Articulo=a.ARTICULO)	
		left  join BREMEN.EXISTENCIA_BODEGA eb with(nolock) on (tl.Articulo=eb.ARTICULO AND tl.Bodega_Envia=eb.BODEGA)
		left  join CLSA.TRASLADO_PDT_LINEA pl with(nolock) on (pl.Contenedor=ml.Id_Muelle and pl.Contenedor_Linea=ml.Muelle_Linea and pl.Articulo = ml.Articulo)
		where  (m.Muelle=ISNULL(@pTraslado,m.Muelle))
		and (m.Bodega_Solicita=ISNULL(@pBodegaSolicita,m.Bodega_Solicita)) 
		and (tm.Bodega_CEDI=ISNULL(@pBodegaEnvia,tm.Bodega_CEDI))
		and (tm.Consecutivo is not null and tm.Contenedor is not null)
		and (tm.Estado<>'PE')
		--
		and (isnumeric(tm.Consecutivo)>0)
		and ml.Consecutivo is null		
	  ) tl		
		inner join CLSA.TRASLADO_ESTADO e with(nolock) on (tl.Estado=e.estado)		
		inner join bremen.bodega b with(nolock) on (b.BODEGA=tl.Bodega_Solicita)
		order by Articulo asc
		;
	end
	--
	if @pOpcion='LW' --LINEA CON MOVIMIENTOS Y APROVADOS
	begin
	   select tl.*	   	  
	   from(
		SELECT distinct ml.Id_Traslado as Traslado
		, a.Articulo, a.DESCRIPCION as Descripcion			
		,(pl.Cantidad_Cargada) as Cantidad		
		,ceiling(eb.CANT_DISPONIBLE) as total_cedi		
		,pl.codigo_barra as Codigo_Barra
		,(case when pl.estado='V' then pl.Cantidad_Aprobada else '' end) as Cantidad_Despachar
		,(ml.Cantidad_Enviada-pl.Cantidad_Cargada) as Cant_Dif		
		,ml.Muelle_Linea		
		,m.Bodega_Solicita, tm.Estado as Estado
		from CLSA.TRASLADO_MUELLE m with(nolock)
		Inner join CLSA.TRASLADO_MUELLE_LINEA ml with(nolock) on (m.Muelle=ml.Id_Muelle)		
		inner join CLSA.TRASLADO_LINEA tl with(nolock) on (ml.Id_Traslado=tl.traslado and ml.Articulo=tl.Articulo)
		inner join CLSA.TRASLADO_MOVIMIENTO tm with(nolock) on (ml.Id_Muelle=tm.Contenedor and isnull(ml.id_movimiento,tm.ID_MOVIMIENTO)=tm.ID_MOVIMIENTO and ml.Id_Traslado= tm.Traslado and tm.Estado not in('O')) AND tl.Traslado_Linea=tm.Traslado_Linea
		inner join BREMEN.ARTICULO a with(nolock) on (tl.Articulo=a.ARTICULO)	
		inner join CLSA.TRASLADO_PDT_LINEA pl with(nolock) on (pl.Contenedor=ml.Id_Muelle and pl.Contenedor_Linea=ml.Muelle_Linea and pl.Articulo = ml.Articulo)
		left  join BREMEN.EXISTENCIA_BODEGA eb with(nolock) on (tl.Articulo=eb.ARTICULO AND tl.Bodega_Envia=eb.BODEGA)		
		where  (m.Muelle=ISNULL(@pTraslado,m.Muelle))
		and (m.Bodega_Solicita=ISNULL(@pBodegaSolicita,m.Bodega_Solicita)) 
		and (tm.Bodega_CEDI=ISNULL(@pBodegaEnvia,tm.Bodega_CEDI))
		and (tm.Consecutivo is not null and tm.Contenedor is not null)
		and (tm.Estado<>'PE')
		--
		and (isnumeric(tm.Consecutivo)>0)
		and ml.Consecutivo is null
		--
		and pl.Estado IN (@pEstado,'V')
	  ) tl		
		inner join CLSA.TRASLADO_ESTADO e with(nolock) on (tl.Estado=e.estado)		
		inner join bremen.bodega b with(nolock) on (b.BODEGA=tl.Bodega_Solicita)
		order by Articulo asc
		;
		select 'Estado,Estado_Sistema,Estado_Lineas,E_ML,E_M,Cantidad_Pedida,Volumen,Peso,Nombre_Bodega,Muelle,Bodega_Envia,Cantidad_Pendiente,Cantidad_Despachada,Bodega_Solicita,Fecha_Creacion,Estado_Pedido,Muelle_Linea,Traslado,Articulo,Descripcion,Cant_Dif,Cantidad,Total_Cedi' as hidecolumn,'' as showcolumn;
	end

	--los campos para ocultar en el gridview--
	if @pOpcion in ('L','M') --DETALLADO|LINEA|MOVIMIENTOS
	begin   
	   select 'Estado,Estado_Sistema,Estado_Lineas,E_ML,E_M,Cantidad_Pedida,Volumen,Peso,Nombre_Bodega,Muelle,Bodega_Envia,Cantidad_Pendiente,Cantidad_Despachada,Bodega_Solicita,Fecha_Creacion,Estado_Pedido,Muelle_Linea,Traslado,Articulo,Descripcion,Cant_Dif,Cantidad,Total_Cedi' as hidecolumn,'' as showcolumn;
	end
    	
END
