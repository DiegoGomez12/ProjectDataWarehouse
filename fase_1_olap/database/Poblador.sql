CREATE OR ALTER PROCEDURE [dbo].[InsertarRegistrosNA]
AS
BEGIN
	INSERT INTO dbo.DimCliente (PK_ClienteId, Ciudad, Estado, Pais, CodigoPostal, ClienteTipo)
	SELECT 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A'
	WHERE NOT EXISTS (
		SELECT 1
		FROM dbo.DimCliente
		WHERE PK_ClienteId = 'N/A'
	);

	INSERT INTO dbo.DimVendedor (PK_VendedorId, Nombre)
	SELECT 'N/A', 'N/A'
	WHERE NOT EXISTS (
		SELECT 1
		FROM dbo.DimVendedor
		WHERE PK_VendedorId = 'N/A'
	);
END;
GO

-- Poblar todo

CREATE OR ALTER PROCEDURE [dbo].[PoblarDimTiempo]
AS
BEGIN
    INSERT INTO P26.dbo.DimTime
    SELECT DISTINCT
        CAST(CONVERT(varchar(8), X.Fecha, 112) AS bigint),
        YEAR(X.Fecha),
        MONTH(X.Fecha),
        DAY(X.Fecha),
        DATEPART(QUARTER, X.Fecha),
        ((MONTH(X.Fecha) - 1) / 4) + 1,
        ((MONTH(X.Fecha) - 1) / 6) + 1,
        DATENAME(WEEKDAY, X.Fecha),
        DATENAME(MONTH, X.Fecha),
        CAST(CONVERT(varchar(8), X.Fecha, 112) AS datetime)
    FROM
    (
        SELECT Fecha FROM AutopartesP26.dbo.SalidaEncabezado
        UNION
        SELECT Fecha FROM AutopartesP26.dbo.EntradaEncabezado
    ) X
    WHERE NOT EXISTS (
        SELECT 1
        FROM P26.dbo.DimTime F
        WHERE F.TiempoId = CAST(CONVERT(varchar(8), X.Fecha, 112) AS bigint)
    );
END;
GO

CREATE OR ALTER PROCEDURE [dbo].[PoblarDimVendedor]
As
Begin
	Insert INTO P26.dbo.DimVendedor
	SELECT
	Clave,
	Nombre
	From AutopartesP26.dbo.Vendedor AV
	Where not EXISTS(
	SELECT 1
	FROM	P26.dbo.DimVendedor V
	WHERE V.PK_VendedorId = AV.Clave COLLATE DATABASE_DEFAULT
	)
END;

GO

CREATE OR ALTER PROCEDURE [dbo].[PoblarDimCliente]
AS 
BEGIN 
	INSERT INTO P26.dbo.DimCliente
	SELECT 
	A.Clave,
	A.Ciudad as 'Ciudad',
	E.Descripcion as 'Estado',
	P.Descripcion as 'Pais',
	A.CodigoPostal,
	CT.Descripcion
	From AutopartesP26.dbo.Cliente A
	left join AutopartesP26.dbo.Estado E on A.Estado = E.Clave
	left join AutopartesP26.dbo.Pais P on P.Clave = A.Pais
	left join AutopartesP26.dbo.ClienteTipo CT on CT.Clave = A.ClienteTipo 
	Where NOT EXISTS(
		SELECT 1
		FROM P26.dbo.DimCliente D
		Where A.Clave = D.PK_ClienteId COLLATE DATABASE_DEFAULT
	)
END;

GO

CREATE OR ALTER PROCEDURE [dbo].[PoblarDimArticulo]
AS
BEGIN 
	INSERT INTO P26.dbo.DimArticulo
	SELECT 
	A.Clave,
	T.Descripcion as Tipo,
	G.Descripcion AS Grupo,
	C.Descripcion AS Clase,
	A.Precio,
	A.Descripcion
	From AutopartesP26.dbo.Articulo A
	left join AutopartesP26.dbo.ArticuloClase C on A.ArticuloClase = C.Clave
	left join AutopartesP26.dbo.ArticuloTipo T on A.ArticuloTipo = T.Clave
	left join AutopartesP26.dbo.ArticuloGrupo G on A.ArticuloGrupo = G.Clave
	Where not exists(
	SELECT 1
	From P26.dbo.DimArticulo DA
	WHERE DA.PK_ArticuloId = A.clave COLLATE DATABASE_DEFAULT
	)
END;


GO

CREATE OR ALTER PROCEDURE [dbo].[PoblarDimSalida]
AS
BEGIN
	INSERT INTO P26.dbo.DimSalida
	SELECT 
	S.Folio,
	C.Descripcion,
	E.Descripcion,
	M.Descripcion,
	S.Empresa
	FROM AutopartesP26.dbo.SalidaEncabezado S
	left join AutopartesP26.dbo.CondicionPago C on S.CondicionPago = C.Clave
	left join AutopartesP26.dbo.MedioEmbarque E on S.MedioEmbarque = E.Clave
	left join AutopartesP26.dbo.Moneda M on S.Moneda = M.Clave
	Where NOT EXISTS(
	SELECT 1
	FROM P26.dbo.DimSalida DS
	WHERE DS.Folio = S.Folio COLLATE DATABASE_DEFAULT
	)
END;
GO

CREATE OR ALTER PROCEDURE [dbo].[PoblarDimEntrada]
AS
BEGIN
    INSERT INTO P26.dbo.DimEntrada
    (
        ClaveEntrada,
        Empresa,
        Moneda,
        Operacion
    )
    SELECT
        EC.Folio COLLATE DATABASE_DEFAULT,
        EC.Empresa,
        M.Descripcion,
        EC.Operacion
    FROM AutopartesP26.dbo.EntradaEncabezado EC
    LEFT JOIN AutopartesP26.dbo.Moneda M 
        ON EC.Moneda = M.Clave
    WHERE NOT EXISTS (
        SELECT 1
        FROM P26.dbo.DimEntrada E
        WHERE E.ClaveEntrada = EC.Folio COLLATE DATABASE_DEFAULT
    );
END;
GO

CREATE OR ALTER PROCEDURE [dbo].[PoblarFactEntrada]
AS
BEGIN
    INSERT INTO P26.dbo.FactEntrada
    SELECT
        D.Folio COLLATE DATABASE_DEFAULT AS ClaveEntrada,
        D.Partida,
        CAST(CONVERT(varchar(8), E.Fecha, 112) AS bigint) AS FK_TiempoId,
        D.Articulo AS FK_ArticuloId,
        ISNULL(NULLIF(E.Vendedor, ''), 'N/A'),
        ISNULL(NULLIF(E.Cliente, ''), 'N/A'),
        D.Precio,
        D.Cantidad,
        D.TotalImporte,
        D.TotalDescuento,
        D.TotalImpuesto,
		D.Total,
        E.TotalImporte,
        E.TotalDescuento,
        E.TotalImpuesto,
        E.Total,
        1.0 / COUNT(*) OVER (PARTITION BY D.Folio)
    FROM AutopartesP26.dbo.EntradaDetalle D
    LEFT JOIN AutopartesP26.dbo.EntradaEncabezado E
        ON D.Folio = E.Folio
       AND D.Empresa = E.Empresa
    WHERE NOT EXISTS(
        SELECT 1
        FROM P26.dbo.FactEntrada F
        WHERE F.ClaveEntrada = D.Folio COLLATE DATABASE_DEFAULT
    );
END;
GO

CREATE OR ALTER PROCEDURE [dbo].[PoblarFactSalida]
AS
BEGIN
	INSERT INTO P26.dbo.FactSalida
	SELECT 
	D.Folio,
	D.Partida,
	CAST(CONVERT(varchar(8),E.Fecha, 112)	AS int),
	D.Articulo,
	ISNULL(NULLIF(E.Vendedor, ''), 'N/A'),
	ISNULL(NULLIF(E.Cliente, ''), 'N/A'),
	Precio,
	Cantidad,
	D.TotalImporte,
	D.TotalDescuento,
	D.TotalImpuesto,
	D.Total,
	E.TotalImporte,
	E.TotalDescuento,
	E.TotalImpuesto,
	E.Total,
	1.0 / COUNT(*) OVER (PARTITION BY D.Folio)
	FROM AutopartesP26.dbo.SalidaDetalle D
	left join AutopartesP26.dbo.SalidaEncabezado E on D.Folio = E.Folio
	WHERE NOT EXISTS(
	SELECT 1
	FROM P26.dbo.FactSalida F
	WHERE F.PK_Folio = D.Folio COLLATE DATABASE_DEFAULT
	)
END;
GO

CREATE OR ALTER PROCEDURE [dbo].[PoblarModeloConstelacion]
AS
BEGIN
	EXEC InsertarRegistrosNA
	EXEC PoblarDimVendedor
	EXEC PoblarDimCliente
	EXEC PoblarDimArticulo
	EXEC PoblarDimTiempo
	EXEC PoblarDimSalida
	EXEC PoblarDimEntrada
	EXEC PoblarFactSalida
	EXEC PoblarFactEntrada
END;
GO

EXEC PoblarModeloConstelacion;
GO
