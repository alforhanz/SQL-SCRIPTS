SELECT * 
FROM CLSA.WMS_CONTROL_ENTREGA
WHERE CONSECUTIVO = 'P01-19942415'

UPDATE CLSA.WMS_CONTROL_ENTREGA
SET ESTADO = 'G'
WHERE CONSECUTIVO = 'P01-19942421';