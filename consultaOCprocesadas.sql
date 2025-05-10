
exec [CLSA].[WMS_sp_ObtenerBodegas]; -- obtiene las bodegas

EXEC [CLSA].[sp_update_Bodegas_Embarque] 'B-81','EM00035306','OC-0036901';-- cambia la Bodega de destino en la OC

EXEC [CLSA].[sp_update_Bodegas_Embarque] 'TRAN','EM00035306','OC-0036901'; -- cambia la Bodega de destino en el Embarque


 EXEC [CLSA].[WMS_sp_getOrdenesCompras] 'WMS','pruebapma','P','B-01','E',null,'20200101','20240215'; --Emcabezado

 select * from bremen.ORDEN_COMPRA_LINEA where ORDEN_COMPRA = 'OC-0036901'

 EXEC [CLSA].[WMS_sp_getOrdenesCompras] 'WMS','pruebapma','D','B-81','E','OC-0017283','20231001','20241030';  --Detalle

 EXEC clsa.sp_getEmbarques 's','EM00035348' --para ver el detalle de ese embarque.

 select * from clsa.WMS_CONTROL_ENTREGA_EMB 
 where EMBARQUE = 'OC-0036901'

  update BODERA * from clsa.WMS_CONTROL_ENTREGA_EMB 
 where EMBARQUE = 'OC-0036901'



select ol.* from (
select ol.ORDEN_COMPRA, ol.ARTICULO, ol.bodega, count(*) as total_line_art
from bremen.orden_compra_linea ol
where ol.ESTADO = 'E'
group by ol.ORDEN_COMPRA, ol.ARTICULO, ol.BODEGA
) OC 
inner join bremen.orden_compra_linea ol on (oc.ORDEN_COMPRA=ol.ORDEN_COMPRA)
where oc.total_line_art>1
and ol.ORDEN_COMPRA = 'OC-0017283' --'OC-0036909'
;

UPDATE C SET C.BODEGA = 'TRAN' FROM bremen.orden_compra_linea C WHERE C.ORDEN_COMPRA = 'OC-0036901'



SELECT * FROM BREMEN.EXISTENCIA_BODEGA E WHERE E.ARTICULO = '13.6X24 BKT'

SELECT * FROM CLSA.WMS_CONTROL_ENTREGA_EMB WHERE EMBARQUE = 'OC-0017283'

--/////////////////////////////////////////////////////////////
select *
from bremen.orden_COMPRA_linea ol with(nolock)                 
where  0 = 0
AND OL.BODEGA='B-01'
AND ol.ORDEN_COMPRA = 'OC-0000067'
---AND OL.ARTICULO='11R-22.5 H K' 
and OL.ARTICULO NOT IN (
    --Se obtiene la cantidad total de lineas/items de un orden de compra--
    select ol.ARTICULO --@vTotalArtEB = count(@Bodega) 
    from bremen.orden_COMPRA_linea ol with(nolock) 
    inner join bremen.existencia_bodega eb  with(nolock) ON (ol.articulo=eb.articulo) and eb.bodega='B-01'
    where ol.ORDEN_COMPRA = 'OC-0000067'
)
order by 1 asc
;