ALTER PROCEDURE [CLSA].[WMS_sp_getCodigoBarraArticulo]
    @pCodigoLectura VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el parámetro es nulo
    IF @pCodigoLectura IS NULL
    BEGIN
        SELECT 'No hay parámetros' AS Respuesta;
        RETURN;
    END;

    -- Verificar si el parámetro coincide con un artículo o un código de barra
    IF NOT EXISTS (
        SELECT 1
        FROM BREMEN.ARTICULO A WITH (NOLOCK) 
        WHERE A.ARTICULO = @pCodigoLectura
           OR A.CODIGO_BARRAS_INVT = @pCodigoLectura
           OR A.CODIGO_BARRAS_VENT = @pCodigoLectura
    )
    BEGIN
        -- Validar si el código de barra está en ARTICULO_CODIGOBARRA
        IF EXISTS (
            SELECT 1
            FROM CLSA.ARTICULO_CODIGOBARRA C WITH (NOLOCK)
            WHERE C.CODIGO_BARRA = @pCodigoLectura
        )
        BEGIN
            -- Código de barra existe, devolver si está asociado a un artículo
            SELECT CASE 
                       WHEN C.ARTICULO IS NULL THEN 'ND'
                       ELSE 'AE'
                   END AS Respuesta
            FROM CLSA.ARTICULO_CODIGOBARRA C WITH (NOLOCK)
            WHERE C.CODIGO_BARRA = @pCodigoLectura;
        END
        ELSE
        BEGIN
            -- Si no existe en ARTICULO_CODIGOBARRA, devolver 'ND'
            SELECT 'ND' AS Respuesta;
        END
    END
    ELSE
    BEGIN
        -- Devuelve los detalles del artículo encontrado
        SELECT 
            ISNULL(A.ARTICULO, '') + ';' +
            ISNULL(A.CODIGO_BARRAS_INVT, '') + ';' +
            ISNULL(A.CODIGO_BARRAS_VENT, '') AS CADENA_CODIGO
        FROM BREMEN.ARTICULO A WITH (NOLOCK)
        WHERE A.ARTICULO = @pCodigoLectura
           OR A.CODIGO_BARRAS_INVT = @pCodigoLectura
           OR A.CODIGO_BARRAS_VENT = @pCodigoLectura;
    END;
END;
