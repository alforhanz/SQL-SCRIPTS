/*
exec [CLSA].[WMS_sp_getPedidosEntrega] 'WEB' , 'pruebapma', 'R' , '20240625' , '20240625',NULL , 'B-51' --pedidos normales
exec [CLSA].[WMS_sp_getPedidosEntrega] 'WEB' , 'sergmend', 'FF' , '20240617' , '20240617',NULL , 'B-02'  -- Pedidos finalizados y facturados
EXEC [CLSA].[WMS_sp_getDetalle_ContEntrega] 'P02-10248064'; --Detalle de pedidos
exec [CLSA].[WMS_sp_InsertUpdate_ControlEntrega] 'W','sergmend','G','WMS_VP','P02-10248063','AMA10W-S/S AG',4.50,4.50,'N','B-02'  --Guardado de pedidos
exec [CLSA].[WMS_sp_InsertUpdate_ControlEntrega] 'W','sergmend','p','WMS_VP','P02-10248063','AMA10W-S/S AG',3.50,3.50,'N','B-02'  --Procesado de pedidos


SELECT * FROM CLSA.WMS_CONTROL_ENTREGA WHERE CONSECUTIVO= 'P02-10257588';  -- muestra la tabla controll de entrega.

Select * from bremen.pedido_linea where pedido = 'P02-10257588' and articulo = '26300-35505'

Select * from bremen.FACTURA_LINEA where pedido = 'P02-10257588' and articulo = '26300-35505'

UPDATE [Exactus].[CLSA].[WMS_CONTROL_ENTREGA]
SET [LineaContada] = 4.00
WHERE [CONSECUTIVO] = 'P02-10257578' and [ARTICULO]='AMA S/SINT AG';

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [MODULO]
      ,[CONSECUTIVO]
      ,[TIPO_CONSECUTIVO]
      ,[ARTICULO]
      ,[BODEGA]
      ,[ESTADO]
      ,[COMENTARIO]
      ,[USUARIO]
      ,[REVISADOPOR]
      ,[APROBADOPOR]
      ,[LineaContada]
      ,[LineaConsecutivo]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[RecordDate]
  FROM [Exactus].[CLSA].[WMS_CONTROL_ENTREGA]
  where consecutivo ='P02-10257588'
  */
  --Select top 1000 a.*
  ----a.PEDIDO, a.ARTICULO, a.FECHA_ENTREGA
  --from BREMEN.PEDIDO_LINEA a inner join BREMEN.ARTICULO b  on a.ARTICULO = b.ARTICULO
  --where SUBSTRING(a.ARTICULO,len(a.ARTICULO)-0,1) = 'S' 
  --and b.CLASIFICACION_1 = 1020 
  ----and a.PEDIDO = 'P51-10062739'
  --order by a.FECHA_ENTREGA desc
  exec [CLSA].[WMS_sp_getPedidosEntrega] 'WEB' , 'pruebapma', 'R' , '20240819' , '20240831',NULL , 'B-51' --pedidos normales
  exec [CLSA].[WMS_sp_getPedidosEntrega] 'WEB' , 'sergmend', 'FF' , '20240101' , '20240823',NULL , 'B-51' 
  EXEC [CLSA].[WMS_sp_getDetalle_ContEntrega] 'P51-10062798'; --Detalle de pedidos

  select * from clsa.WMS_ERRORES order by 1 desc

  pSistema: WEB | pUsuario: pruebapma | pOpcion: R | pFechaDesde: 20240819 | pFechaHasta: 20240831 | pPedido:  | pBodega: B-51 | pCliente:  | pEstado: N


AMBIENTE DE PRUEBA DE DESARROLLO--
  OPCION: R O E
  declare @PEDIDO varchar(20) = 'P04-1249688'
Select * from bremen.factura_linea CE with(nolock) where (CE.pedido=@PEDIDO);
Select * from CLSA.WMS_CONTROL_ENTREGA CE with(nolock) where (CE.CONSECUTIVO=@PEDIDO);
				select --top 20 
				ROW_NUMBER() OVER(ORDER BY T1.FECHA_FACTURA DESC) AS ITEM				
				, CASE WHEN  T1.ORDEN_TALLER IS NOT NULL THEN  T1.ORDEN_TALLER ELSE  T1.DOCUMENTO END DOCUMENTO
				, T1.PEDIDO
				, T1.DESCRIPCION 
				, T1.CLIENTE
				, SUM (CASE WHEN AR.TIPO IN ('T', 'K') THEN PL.CANTIDAD_PEDIDA  ELSE 0 END ) TOTAL_UNIDADES
				, T1.Lineas_Verificado LINEAS_VERIFICADAS
				, T1.ESTADO_PEDIDO , T1.USUARIO 
				, T1.FECHA_FACTURA
				, T1.FECHA_PEDIDO
				, T1.MODULO 
				, T1.NUM_PLACA placa
				, CLSA.fn_getTieneServicios (T1.PEDIDO ) tiene_servicio
				,(	SELECT CASE WHEN COUNT(PEDIDO) = 0 THEN 'N' ELSE 'S' END  
					FROM BREMEN.PEDIDO_LINEA PL INNER JOIN BREMEN.ARTICULO AR ON  (AR.ARTICULO = PL.ARTICULO )
					WHERE AR.CLASIFICACION_1 = '1040' AND AR.TIPO = 'V'
					AND PL.PEDIDO = T1.PEDIDO
				) as tiene_servicio --added by vg 2024.07.17 02:03 pm
				, T1.SOLICITA
				, T1.ATENDIDO_POR
				, ISNULL(T1.FECHA_FACTURA, FECHA_CREACION_PEDIDO) FECHA
				FROM (
					 SELECT 					
					 CASE WHEN F.FACTURA IS NOT NULL AND F.TIPO_DOCUMENTO='F' THEN F.FACTURA ELSE P.PEDIDO END AS DOCUMENTO --ADDED BY VG 2024.02.28 12:24 PM
					, OT.ORDEN_TALLER 
					, P.PEDIDO 
					, CASE WHEN p.RUBRO1 IS NULL OR p.RUBRO1 = '' THEN p.EMBARCAR_A ELSE p.RUBRO1 END + ' .... ' + convert(varchar, p.createdate, 22) + ' ' as DESCRIPCION 	
					, ISNULL((Select SUM(LineaContada ) from CLSA.WMS_CONTROL_ENTREGA CE with(nolock) where ((CE.CONSECUTIVO = p.PEDIDO or  CE.CONSECUTIVO = OT.ORDEN_TALLER) AND (CE.BODEGA = p.BODEGA) AND CE.ESTADO not in ('E') ) group by CE.CONSECUTIVO), 0) as  Lineas_Verificado --Cantidad de Lineas Verificadas					
					, ISNULL((Select  ESTADO from CLSA.WMS_CONTROL_ENTREGA CE with(nolock) where ((CE.CONSECUTIVO = p.PEDIDO or  CE.CONSECUTIVO = OT.ORDEN_TALLER) AND (CE.BODEGA = p.BODEGA) AND CE.ESTADO not in ('P', 'E') ) group by ESTADO ), 0) as  ESTADO_VERIFICACION 					
					, p.embarcar_a as CLIENTE
					, P.Estado ESTADO_PEDIDO
					, p.USUARIO
					, p.fecha_pedido
					, P.RecordDate FECHA_CREACION_PEDIDO
					, F.FECHA FECHA_FACTURA
					, 'P' as MODULO
					, OT.NUM_PLACA 
					, (select SOLICITA from CLSA.CONTROL_ENTREGA_SOLICITADO X WHERE X.CONSECUTIVO = OT.ORDEN_TALLER ) solicita
					, (SELECT NOMBRE FROM BREMEN.VENDEDOR V WHERE V.VENDEDOR = P.RUBRO2 ) ATENDIDO_POR
					----------------------------
					FROM BREMEN.PEDIDO p with(nolock) 
					LEFT JOIN CLSA.ORDEN_TALLER OT with(nolock) ON  (P.PEDIDO = OT.PEDIDO AND P.BODEGA = OT.BODEGA) 
					LEFT JOIN BREMEN.FACTURA F with(nolock) ON (F.PEDIDO = P.PEDIDO)
					WHERE 0=0  and p.BODEGA   = 'B-04' and ( p.PEDIDO  = @PEDIDO OR F.FACTURA = @PEDIDO ) ) T1
			LEFT JOIN BREMEN.PEDIDO_LINEA PL with(nolock) ON (T1.PEDIDO = PL.PEDIDO )
			LEFT JOIN BREMEN.ARTICULO AR with(nolock) ON (AR.ARTICULO = PL.ARTICULO  AND AR.TIPO <> 'V' ) 
				GROUP BY T1.DOCUMENTO, T1.ORDEN_TALLER , T1.PEDIDO , T1.DESCRIPCION 
				, T1.CLIENTE , T1.ESTADO_PEDIDO , ESTADO_VERIFICACION
				, T1.USUARIO , T1.FECHA_PEDIDO, T1.FECHA_FACTURA , T1.MODULO,  T1.Lineas_Verificado , T1.NUM_PLACA , T1.SOLICITA, T1.ATENDIDO_POR, T1.FECHA_CREACION_PEDIDO
				
				HAVING 				
				T1.Lineas_Verificado < SUM (CASE WHEN AR.TIPO IN ('T', 'K') THEN PL.CANTIDAD_PEDIDA  ELSE 0 END )  OR ESTADO_VERIFICACION = 'G'
				ORDER BY  ISNULL(T1.FECHA_FACTURA, FECHA_CREACION_PEDIDO) DESC     



