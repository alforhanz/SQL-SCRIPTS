Select ol.* from bremen.orden_compra_linea ol 
inner join bremen.articulo ar on
ol.ARTICULO = ar.ARTICULO
left join bremen.articulo_ensamble ae on
ae.ARTICULO_HIJO = ar.ARTICULO
where ae.ARTICULO_PADRE is not null order by FECHA desc



EXEC [CLSA].[WMS_sp_getOrdenesCompras] 'WMS',null,'D',null,null,'OC-0036776';
select * from clsa.ARTICULO_CODIGOBARRA
select * from clsa.WMS_CONTROL_ENTREGA_EMB 

select articulo,  CODIGO_BARRAS_INVT, CODIGO_BARRAS_VENT from BREMEN.ARTICULO 
where ARTICULO in ('AMA 10W30 GL','AMA 10W30 GLS')

select * from clsa.ARTICULO_CODIGOBARRA