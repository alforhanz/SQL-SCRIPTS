EXEC clsa.WMS_sp_getRptInventarioGeneral 'WMS','pruebapma', 'R','S','20241207','B-81','N','S', NULL,NULL, NULL, NULL,NULL,NULL;--Resumido-Marca-Contados
EXEC clsa.WMS_sp_getRptInventarioGeneral 'WMS','pruebapma', 'R','S','20241207','B-81','S','S', NULL,NULL, NULL, NULL,NULL,NULL;--Resumido-Clase y Marca-Contados
EXEC clsa.WMS_sp_getRptInventarioGeneral 'WMS','pruebapma', 'R','S','20241207','B-81','S','N', NULL,NULL, NULL, NULL,NULL,NULL;--Resumido-Clase-Contados

EXEC clsa.WMS_sp_getRptInventarioGeneral 'WMS','pruebapma', 'D','S','20241207','B-81','N','N', NULL,NULL, NULL, NULL,NULL,NULL;--Detallado-Contados-Todas las clasificaciones
EXEC clsa.WMS_sp_getRptInventarioGeneral 'WMS','pruebapma', 'D','S','20241207','B-81','N','N', '1010','2094', '3105', NULL,NULL,NULL;----Detallado-Contados-clasificaciones 1010 llantas
