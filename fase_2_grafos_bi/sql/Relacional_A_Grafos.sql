-- nos aseguramos de estar en la correcta
USE AutopartesP26;
GO

-- SP para seleccionar con trim en las claves de Articulo
CREATE OR ALTER PROCEDURE dbo.SP_Articulo_ST
AS
BEGIN
    SELECT
        TRIM(clave) AS clave,
        Descripcion,
        TRIM(ArticuloTipo) AS ArticuloTipo,
        TRIM(ArticuloGrupo) AS ArticuloGrupo,
        TRIM(ArticuloClase) AS ArticuloClase,
        Almacenable,
        Identificacion,
        UMedInv,
        UMedVta,
        UMedCpa,
        TRIM(Moneda) AS Moneda,
        Precio,
        pctDescuento,
        UbicacionAlmacen,
        UbicacionClave
    FROM dbo.Articulo;
END;
GO

-- SP para seleccionar con trim en las claves de ArticuloClase
CREATE OR ALTER PROCEDURE dbo.SP_ArticuloClase_ST
AS
BEGIN
    SELECT
        TRIM(Clave) AS Clave,
        Descripcion
    FROM dbo.ArticuloClase;
END;
GO

-- SP para seleccionar con trim en las claves de ArticuloGrupo
CREATE OR ALTER PROCEDURE dbo.SP_ArticuloGrupo_ST
AS
BEGIN
    SELECT
        TRIM(Clave) AS Clave,
        Descripcion
    FROM dbo.ArticuloGrupo;
END;
GO

-- SP para seleccionar con trim en las claves de ArticuloTipo
CREATE OR ALTER PROCEDURE dbo.SP_ArticuloTipo_ST
AS
BEGIN
    SELECT
        TRIM(Clave) AS Clave,
        Descripcion
    FROM dbo.ArticuloTipo;
END;
GO

-- SP para seleccionar con trim en las claves de Cliente
CREATE OR ALTER PROCEDURE dbo.SP_Cliente_ST
AS
BEGIN
    SELECT
        TRIM(Clave) AS Clave,
        RazonSocial,
        CalleNumero,
        Colonia,
        Ciudad,
        Estado,
        Pais,
        CodigoPostal,
        ClienteTipo,
        ClienteGrupo,
        TRIM(Vendedor) AS Vendedor,
        TRIM(Moneda) AS Moneda,
        TRIM(CondicionPago) AS CondicionPago,
        ZonaVenta
    FROM dbo.Cliente;
END;
GO

-- SP para seleccionar con trim en las claves de Vendedor
CREATE OR ALTER PROCEDURE dbo.SP_Vendedor_ST
AS
BEGIN
    SELECT
        TRIM(Clave) AS Clave,
        Nombre
    FROM dbo.Vendedor;
END;
GO

-- SP para seleccionar con trim en las claves de Moneda
CREATE OR ALTER PROCEDURE dbo.SP_Moneda_ST
AS
BEGIN
    SELECT
        TRIM(Clave) AS Clave,
        Descripcion,
        Tipo
    FROM dbo.Moneda;
END;
GO

-- SP para seleccionar con trim en las claves de CondicionPago
CREATE OR ALTER PROCEDURE dbo.SP_CondicionPago_ST
AS
BEGIN
    SELECT
        TRIM(Clave) AS Clave,
        Descripcion
    FROM dbo.CondicionPago;
END;
GO

-- SP para seleccionar con trim en las claves de MedioEmbarque
CREATE OR ALTER PROCEDURE dbo.SP_MedioEmbarque_ST
AS
BEGIN
    SELECT
        TRIM(Clave) AS Clave,
        Descripcion
    FROM dbo.MedioEmbarque;
END;
GO

-- SP para seleccionar con trim en las claves de EntradaEncabezado
CREATE OR ALTER PROCEDURE dbo.SP_EntradaEncabezado_ST
AS
BEGIN
    SELECT
        Empresa,
        TRIM(Folio) AS Folio,
        Fecha,
        Operacion,
        TRIM(Cliente) AS Cliente,
        TRIM(Moneda) AS Moneda,
        TRIM(Vendedor) AS Vendedor,
        pctDescuentoGlobal,
        TotalImporte,
        TotalDescuento,
        TotalImpuesto,
        Total
    FROM dbo.EntradaEncabezado;
END;
GO

-- SP para seleccionar con trim en las claves de EntradaDetalle
CREATE OR ALTER PROCEDURE dbo.SP_EntradaDetalle_ST
AS
BEGIN
    SELECT
        Empresa,
        TRIM(Folio) AS Folio,
        Partida,
        TRIM(Articulo) AS Articulo,
        Almacen,
        Ubicacion,
        DescripcionArticulo,
        CodigoAlternoArticulo,
        Cantidad,
        UMedPartida,
        CantidadUMedInv,
        Precio,
        pctDescuento,
        pctImpuesto,
        TotalImporte,
        TotalDescuento,
        TotalImpuesto,
        Total
    FROM dbo.EntradaDetalle;
END;
GO

-- SP para seleccionar con trim en las claves de SalidaEncabezado
CREATE OR ALTER PROCEDURE dbo.SP_SalidaEncabezado_ST
AS
BEGIN
    SELECT
        Empresa,
        TRIM(Folio) AS Folio,
        Fecha,
        TRIM(Cliente) AS Cliente,
        TRIM(Moneda) AS Moneda,
        TRIM(CondicionPago) AS CondicionPago,
        TRIM(MedioEmbarque) AS MedioEmbarque,
        TRIM(Vendedor) AS Vendedor,
        pctDescuentoGlobal,
        TotalImporte,
        TotalDescuento,
        TotalImpuesto,
        Total
    FROM dbo.SalidaEncabezado;
END;
GO

-- SP para seleccionar con trim en las claves de SalidaDetalle
CREATE OR ALTER PROCEDURE dbo.SP_SalidaDetalle_ST
AS
BEGIN
    SELECT
        Empresa,
        TRIM(Folio) AS Folio,
        Partida,
        TRIM(Articulo) AS Articulo,
        Almacen,
        Ubicacion,
        DescripcionArticulo,
        Cantidad,
        UMedPartida,
        CantidadUMedInv,
        Precio,
        pctDescuento,
        pctImpuesto,
        TotalImporte,
        TotalDescuento,
        TotalImpuesto,
        Total
    FROM dbo.SalidaDetalle;
END;
GO