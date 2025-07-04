USE [Prueba2]
GO
/****** Object:  StoredProcedure [CLSA].[sp_update_Bodegas_Embarque]    Script Date: 01/11/2025 11:00:22 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [CLSA].[sp_update_Bodegas_Embarque]
	-- Add the parameters for the stored procedure here	
	@Bodega			VARCHAR(5),  --nueva bodega asignada
	@Embarque		VARCHAR(20), --El consecutivo de embarque
	@OrdenCompra	VARCHAR(20)= null -- orden de compra seleccionado
AS
BEGIN	
	-- =============================================
	-- Author:		<Author,VG,Vitalio Garcia>
	-- Create date: <Create Date,2018.09.10,>
	-- Last date:	<2024.09.17 01:20 pm, 2024.10.19 10:27 pm, 2025.01.08 02:35 PM>
	-- Description:	<Description, Procedimiento que se actualiza bodegas de embarques y de orden de compra,>
	-- =============================================
	/*
	select * from clsa.wms_control_entrega_observacion;
	select * from clsa.wms_control_entrega_emb where bodega is not null;
	select * from bremen.embarque e with(nolock) where e.embarque = 'EM00035348';
	SELECT L.BODEGA, OL.BODEGA from bremen.orden_COMPRA l with(nolock)
	INNER JOIN bremen.orden_COMPRA_linea ol with(nolock) ON (l.orden_compra=ol.orden_compra)
	where l.orden_compra='OC-0036157';
	exec clsa.sp_getEmbarques 's','EM00035348'
	EXEC clsa.sp_update_Bodegas_Embarque 'B-81','EM00017184','OC-0017283'; 
	*/
	SET NOCOUNT ON;
	DECLARE	@OC	VARCHAR(20)=null, @vProcesados char(1) = 'S' ;
	DECLARE @countOC int=1, @vTotalArtOC int=0, @vTotalArtEB int = 0;
	DECLARE @tblOC as table (ID int, OC varchar(50));	
	-- --------------------------------------------------------------------------
	declare @v_paramin   varchar(5000) = null, -- parametros de entrada
			@v_sqlspfn   varchar(200)  = null, -- nombre del store procedure
		    @v_sqlcode   varchar(200)  = null, -- atrapa el c?digo de error
		    @v_sqltext   varchar(200)  = null, -- obtiene el mensaje del error
			@v_sqlstac   varchar(200)  = null, -- obtiene la pila del error
			@v_sqltrac   varchar(200)  = null, -- obtiene el rastro del error  
			@v_respuesta VARCHAR(10);
    -- --------------------------------------------------------------------------	
    BEGIN TRY	        
 	-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- registramos todos los parametros de entrada			
			set @v_paramin = 'Bodega: ' + cast(isnull(@Bodega,'') as varchar);
			set @v_paramin = @v_paramin + ' | Embarque: ' + cast(isnull(@Embarque,'') as varchar);	
			set @v_paramin = @v_paramin + ' | OrdenCompra: ' + cast(isnull(@OrdenCompra,'') as varchar);					
 	-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	if (select count(*) from bremen.embarque e with(nolock) where e.embarque=@Embarque AND e.ESTADO<>'R') > 0 	   
	begin
	    INSERT INTO @tblOC
		SELECT distinct row_number() over(order by el.orden_compra asc) as ID, el.orden_compra
		from bremen.embarque e with(nolock)
		inner join bremen.EMBARQUE_LINEA el with(nolock) on (e.embarque=el.EMBARQUE)
		where e.estado<>'R'
		and e.embarque = @Embarque
		and el.ORDEN_COMPRA = isnull(@OrdenCompra, el.ORDEN_COMPRA) --new line added by vg 2024.09.17 03:24 pm--
		group by el.embarque, el.orden_compra
		ORDER BY el.orden_compra asc
		;
		--select * from @tblOC;
		WHILE(@countOC<=(SELECT COUNT(*) FROM @tblOC))
		BEGIN		    			
			SET @vProcesados = 'S';
			select @OC= t.OC from @tblOC t where t.ID=@countOC;		
			--Se obtiene la cantidad total de lineas/items de un orden de compra--
			select @vTotalArtOC = count(*) 
			from bremen.orden_COMPRA_linea ol with(nolock) 				
			where ol.ORDEN_COMPRA=@OC;
			--Se obtiene la cantidad total de lineas/items de un orden de compra--
			select @vTotalArtEB = count(@Bodega) 
			from bremen.orden_COMPRA_linea ol with(nolock) 
			inner join bremen.existencia_bodega eb  with(nolock) ON (ol.articulo=eb.articulo and eb.bodega=@Bodega)
			where ol.ORDEN_COMPRA = @OC;
			--validamos la bodega a aplicar esta asociada a todos los articulos de la Orden de Compra--
			IF(@vTotalArtOC	<> @vTotalArtEB)	
			begin
				set @vProcesados = 'N';
				--select 'Hay ' + cast( (@vTotalArtOC-@vTotalArtEB) as varchar) + ', referencias de articulos que no están asociadas a la bodega de destino ' + @Bodega as mensaje;
					select ROW_NUMBER() over(order by ol.ARTICULO ASC) AS ITEM, ol.ARTICULO, ol.DESCRIPCION
					from bremen.orden_COMPRA_linea ol with(nolock) 				
					where ol.ORDEN_COMPRA = @OC
					and OL.ARTICULO NOT IN (
						--Se obtiene la cantidad total de lineas/items de un orden de compra--
						select ol.ARTICULO
						from bremen.orden_COMPRA_linea ol with(nolock) 
						inner join bremen.existencia_bodega eb  with(nolock) ON (ol.articulo=eb.articulo) 
						where ol.ORDEN_COMPRA = @OC
						and eb.bodega=@Bodega )
					order by 1 asc
					;	
				break;
			end
            ELSE
			begin				
				--/////* ACTUALIZANDO ARTICULOS EN EXISTENCIA DE BODEGAS, CON SUS RESPECTIVAS CANTIDADES BODEGA TRANSITO*////--			
				--SELECT T.*, et.bodega, et.cant_transito,				
				UPDATE ET SET ET.CANT_TRANSITO = 
				(T.CANT_TRAN_TOTAL - T.CANT_ORDEN_BODEGA) --as BODEGA_TRAN			
				FROM(													
					select ol.orden_compra, ol.articulo, ol.bodega, ol.estado
					,sum(ol.cantidad_ordenada) AS CANT_ORDEN_BODEGA			
					, (select sum(o.cantidad_ordenada) from bremen.orden_compra_linea o with(nolock) where o.estado='E' AND o.BODEGA='TRAN' AND o.ARTICULO=ol.ARTICULO) as CANT_ORDEN_TOTAL
					,sum(distinct eb.cant_transito) AS CANT_TRAN_BODEGA					
					, (select sum(e.cant_transito) from bremen.existencia_bodega e with(nolock) where e.articulo=eb.articulo and e.bodega=@Bodega) AS CANT_TRAN_DESTINO
					, (select sum(e.cant_transito) from bremen.existencia_bodega e with(nolock) where e.articulo=eb.articulo and e.bodega='TRAN')  AS CANT_TRAN_TOTAL
					from bremen.orden_COMPRA l with(nolock)
					INNER JOIN bremen.orden_COMPRA_linea ol with(nolock) ON (l.orden_compra=ol.orden_compra)
					INNER JOIN bremen.existencia_bodega eb  with(nolock) ON (ol.articulo=eb.articulo and ol.bodega=eb.bodega)
					where l.orden_compra=isnull(@OrdenCompra, @OC)
					group by ol.orden_compra, ol.articulo, ol.bodega, ol.estado, eb.ARTICULO							   				 			  			  			 		   			
				) T INNER JOIN bremen.existencia_bodega et  with(nolock) ON (t.articulo = et.articulo and t.BODEGA = et.BODEGA)
				WHERE et.bodega='TRAN'
				;			
				--/////* ACTUALIZANDO ARTICULOS EN EXISTENCIA DE BODEGAS, CON SUS RESPECTIVAS CANTIDADES DE LA BODEGA NUEVA*////--			
				--SELECT T.*, eb.bodega, eb.cant_transito,
				UPDATE EB SET  EB.CANT_TRANSITO = 
				(EB.CANT_TRANSITO + T.CANT_ORDEN_BODEGA) --as BODEGA_NUEVA
				FROM(
					select ol.orden_compra, ol.articulo, ol.estado, @Bodega as bodega --ol.bodega 
					, sum(ol.cantidad_ordenada) AS CANT_ORDEN_BODEGA			
					, (select sum(o.cantidad_ordenada) from bremen.orden_compra_linea o with(nolock) where o.estado='E' AND o.BODEGA='TRAN' AND o.ARTICULO=ol.ARTICULO) as CANT_ORDEN_TOTAL
					, sum(distinct eb.cant_transito) AS CANT_TRAN_BODEGA					
					, (select sum(e.cant_transito) from bremen.existencia_bodega e with(nolock) where e.articulo=eb.articulo and e.bodega=@Bodega) AS CANT_TRAN_DESTINO
					, (select sum(e.cant_transito) from bremen.existencia_bodega e with(nolock) where e.articulo=eb.articulo and e.bodega='TRAN')  AS CANT_TRAN_TOTAL
					from bremen.orden_COMPRA l with(nolock)
					INNER JOIN bremen.orden_COMPRA_linea ol with(nolock) ON (l.orden_compra=ol.orden_compra)
					INNER JOIN bremen.existencia_bodega eb  with(nolock) ON (ol.articulo=eb.articulo and ol.bodega=eb.bodega)
					where l.orden_compra=isnull(@OrdenCompra, @OC)
					group by ol.orden_compra, ol.articulo, ol.estado, ol.bodega, eb.ARTICULO	
				) T INNER JOIN bremen.existencia_bodega eb  with(nolock) ON (eb.articulo=t.articulo and eb.bodega=t.bodega)	
				WHERE eb.bodega=@Bodega 
				;
				--/////* ACTUALIZANDO BODEGA TRAN A BODEGA NUEVA DEL EMBARQUE*////--
				begin tran;				
				--select el.bodega, @Bodega, @OC as embarque
				UPDATE el set el.bodega=@Bodega
				from bremen.embarque e with(nolock)
				INNER JOIN bremen.embarque_linea el with(nolock) ON (e.EMBARQUE=el.embarque)
				where e.embarque=@Embarque
				and el.orden_compra=isnull(@Ordencompra,@OC)
				;
				--/////* ACTUALIZANDO BODEGA TRAN A BODEGA NUEVA DEL ORDEN DE COMPRA ENCABEZADO*////--
				--select l.bodega, @Bodega, @OC as OC
				UPDATE l set l.bodega=@Bodega		
				from bremen.orden_COMPRA l with(nolock)
				INNER JOIN bremen.orden_COMPRA_linea ol with(nolock) ON (l.orden_compra=ol.orden_compra)
				where l.orden_compra=isnull(@OrdenCompra, @OC)
				;
				--/////* ACTUALIZANDO BODEGA TRAN A BODEGA NUEVA DEL ORDEN DE COMPRA LINEA*////--
				--select ol.bodega, @Bodega, @OC as OL
				UPDATE ol set ol.bodega=@Bodega		
				from bremen.orden_COMPRA l with(nolock)
				INNER JOIN bremen.orden_COMPRA_linea ol with(nolock) ON (l.orden_compra=ol.orden_compra)
				where l.orden_compra=isnull(@OrdenCompra, @OC)
				;			
				--////// new ACTUALIZANDO BODEGA ASIGNADO AL CONTROL DE ENTREGA DE EMBARQUE ///////--
				if exists(select top 1 e.EMBARQUE from clsa.WMS_CONTROL_ENTREGA_EMB e with(nolock) where e.EMBARQUE = isnull(@OrdenCompra, @OC))
				begin
					 --select e.*
					 update e set e.BODEGA = @Bodega, e.RecordDate = GETDATE()
					 from clsa.WMS_CONTROL_ENTREGA_EMB e with(nolock) 
					 INNER JOIN bremen.orden_COMPRA_linea o with(nolock) ON (o.orden_compra=e.EMBARQUE and e.ARTICULO = o.ARTICULO)
					 where e.EMBARQUE = isnull(@OrdenCompra, @OC)
				end
				commit tran;
			end	

			SET @countOC= @countOC + 1;

		END --END WHILE		
		-- Mensaje de éxito        
		if(@vProcesados='S') 
        SELECT 'OK'  AS mensaje;
	end
	else
	select 'El embarque, ya ha sido aplicado al inventario' as mensaje

	END TRY
	BEGIN CATCH
	begin
		rollback tran;
     	-- -------------------------------------------------------------------------------------------------------------------
		select @v_sqlspfn = cast(ERROR_PROCEDURE() as varchar(200)),
				@v_sqlcode = cast(ERROR_NUMBER() as varchar),
				@v_sqltext = cast(ERROR_MESSAGE() as varchar(200)),
				@v_sqlstac = cast(ERROR_SEVERITY() as varchar)+ ' | ' + cast(ERROR_STATE() as varchar),
				@v_sqltrac = cast(ERROR_LINE()as varchar);
		set @v_sqlspfn = substring(ISNULL(@v_sqlspfn,isnull(ERROR_PROCEDURE(),'CLSA.sp_update_Bodegas_Embarque')), 1, 200);						
		-- ejecutamos el procedimiento almacenado
		EXEC [CLSA].[sp_insert_error_log] @v_sqlspfn, @v_sqlcode, @v_sqltext, @v_sqlstac, @v_sqltrac, @v_paramin, @v_respuesta out;
		-- -------------------------------------------------------------------------------------------------------------------	        		
		SELECT 'Ha ocurrido un error inesperado en la actualizacion de bodega del embarque:' + char(13) + @v_sqlcode + ': '+ @v_sqltext;  
   end
   END CATCH

END
