

exec [CLSA].[SP_valores_Dashboard] null,'sergmend'; 	--// Usuario de verificador de Pedidos General
exec [CLSA].[SP_valores_Dashboard] 'D','sergmend';	--// Usuario de verificador de Pedidos Detallado

exec [CLSA].[SP_valores_Dashboard_OrdenCompra] null,'sergmend';	--// Usuario de verificador de ORdenes de compras General
exec [CLSA].[SP_valores_Dashboard_OrdenCompra] 'D','sergmend';	--// Usuario de verificador de ORdenes de compras Detallado

exec [CLSA].[SP_valores_Dashboard_Contenedor] null,'sergmend'; --// Usuario de verificador de Contenedores  general
exec [CLSA].[SP_valores_Dashboard_Contenedor] 'D','sergmend';	--// Usuario de verificador de Contenedores detallado




