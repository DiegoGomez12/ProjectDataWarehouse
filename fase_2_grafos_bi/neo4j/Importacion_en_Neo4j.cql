// CREAMOS LOS NODOS

LOAD CSV WITH HEADERS FROM 'file:///Articulo.csv' AS row
CREATE (n:Articulo)
SET n = row;

LOAD CSV WITH HEADERS FROM 'file:///ArticuloClase.csv' AS row
CREATE (n:ArticuloClase)
SET n = row;

LOAD CSV WITH HEADERS FROM 'file:///ArticuloGrupo.csv' AS row
CREATE (n:ArticuloGrupo)
SET n = row;

LOAD CSV WITH HEADERS FROM 'file:///ArticuloTipo.csv' AS row
CREATE (n:ArticuloTipo)
SET n = row;

LOAD CSV WITH HEADERS FROM 'file:///Cliente.csv' AS row
CREATE (n:Cliente)
SET n = row;

LOAD CSV WITH HEADERS FROM 'file:///Vendedor.csv' AS row
CREATE (n:Vendedor)
SET n = row;

LOAD CSV WITH HEADERS FROM 'file:///Moneda.csv' AS row
CREATE (n:Moneda)
SET n = row;

LOAD CSV WITH HEADERS FROM 'file:///CondicionPago.csv' AS row
CREATE (n:CondicionPago)
SET n = row;

LOAD CSV WITH HEADERS FROM 'file:///MedioEmbarque.csv' AS row
CREATE (n:MedioEmbarque)
SET n = row;

// Como son muchos se usa apoc

CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///EntradaEncabezado.csv" AS row RETURN row',
'CREATE (n:EntradaEncabezado) SET n = row',
{ batchSize:10000, parallel:true }
);

CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///EntradaDetalle.csv" AS row RETURN row',
'CREATE (n:EntradaDetalle) SET n = row',
{ batchSize:10000, parallel:true }
);

CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///SalidaEncabezado.csv" AS row RETURN row',
'CREATE (n:SalidaEncabezado) SET n = row',
{ batchSize:10000, parallel:true }
);

CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///SalidaDetalle.csv" AS row RETURN row',
'CREATE (n:SalidaDetalle) SET n = row',
{ batchSize:10000, parallel:true }
);


// CREACION DE INDICES

CREATE INDEX idx_articulo_clave IF NOT EXISTS
FOR (n:Articulo) ON (n.clave);

CREATE INDEX idx_articuloclase_clave IF NOT EXISTS
FOR (n:ArticuloClase) ON (n.Clave);

CREATE INDEX idx_articulogrupo_clave IF NOT EXISTS
FOR (n:ArticuloGrupo) ON (n.Clave);

CREATE INDEX idx_articulotipo_clave IF NOT EXISTS
FOR (n:ArticuloTipo) ON (n.Clave);

CREATE INDEX idx_cliente_clave IF NOT EXISTS
FOR (n:Cliente) ON (n.Clave);

CREATE INDEX idx_vendedor_clave IF NOT EXISTS
FOR (n:Vendedor) ON (n.Clave);

CREATE INDEX idx_moneda_clave IF NOT EXISTS
FOR (n:Moneda) ON (n.Clave);

CREATE INDEX idx_condicionpago_clave IF NOT EXISTS
FOR (n:CondicionPago) ON (n.Clave);

CREATE INDEX idx_medioembarque_clave IF NOT EXISTS
FOR (n:MedioEmbarque) ON (n.Clave);

CREATE INDEX idx_entradaencabezado_folio IF NOT EXISTS
FOR (n:EntradaEncabezado) ON (n.Folio);

CREATE INDEX idx_entradadetalle_folio IF NOT EXISTS
FOR (n:EntradaDetalle) ON (n.Folio);

CREATE INDEX idx_entradadetalle_articulo IF NOT EXISTS
FOR (n:EntradaDetalle) ON (n.Articulo);

CREATE INDEX idx_salidaencabezado_folio IF NOT EXISTS
FOR (n:SalidaEncabezado) ON (n.Folio);

CREATE INDEX idx_salidadetalle_folio IF NOT EXISTS
FOR (n:SalidaDetalle) ON (n.Folio);

CREATE INDEX idx_salidadetalle_articulo IF NOT EXISTS
FOR (n:SalidaDetalle) ON (n.Articulo);


// CREACION DE RELACIONES

// MedioEmbarque - SalidaEncabezado
CALL apoc.periodic.iterate(
'MATCH (me:MedioEmbarque), (s:SalidaEncabezado)
 WHERE me.Clave = s.MedioEmbarque
 RETURN me, s',
'MERGE (me)-[:SE_USA_EN_SALIDA]->(s)',
{ batchSize:10000, parallel:false }
);

// Vendedor - SalidaEncabezado
CALL apoc.periodic.iterate(
'MATCH (v:Vendedor), (s:SalidaEncabezado)
 WHERE v.Clave = s.Vendedor
 RETURN v, s',
'MERGE (v)-[:ATIENDE_SALIDA]->(s)',
{ batchSize:10000, parallel:false }
);

// Vendedor - Cliente
CALL apoc.periodic.iterate(
'MATCH (v:Vendedor), (c:Cliente)
 WHERE v.Clave = c.Vendedor
 RETURN v, c',
'MERGE (v)-[:ATIENDE_CLIENTE]->(c)',
{ batchSize:10000, parallel:false }
);

// Cliente - SalidaEncabezado
CALL apoc.periodic.iterate(
'MATCH (c:Cliente), (s:SalidaEncabezado)
 WHERE c.Clave = s.Cliente
 RETURN c, s',
'MERGE (c)-[:REALIZA_SALIDA]->(s)',
{ batchSize:10000, parallel:false }
);

// CondicionPago - SalidaEncabezado
CALL apoc.periodic.iterate(
'MATCH (cp:CondicionPago), (s:SalidaEncabezado)
 WHERE cp.Clave = s.CondicionPago
 RETURN cp, s',
'MERGE (cp)-[:SE_APLICA_EN_SALIDA]->(s)',
{ batchSize:10000, parallel:false }
);

// CondicionPago - Cliente
CALL apoc.periodic.iterate(
'MATCH (cp:CondicionPago), (c:Cliente)
 WHERE cp.Clave = c.CondicionPago
 RETURN cp, c',
'MERGE (cp)-[:APLICA_A_CLIENTE]->(c)',
{ batchSize:10000, parallel:false }
);

// Moneda - SalidaEncabezado
CALL apoc.periodic.iterate(
'MATCH (m:Moneda), (s:SalidaEncabezado)
 WHERE m.Clave = s.Moneda
 RETURN m, s',
'MERGE (m)-[:USA_MONEDA_EN_SALIDA]->(s)',
{ batchSize:10000, parallel:false }
);

// Moneda - EntradaEncabezado
CALL apoc.periodic.iterate(
'MATCH (m:Moneda), (e:EntradaEncabezado)
 WHERE m.Clave = e.Moneda
 RETURN m, e',
'MERGE (m)-[:USA_MONEDA_EN_ENTRADA]->(e)',
{ batchSize:10000, parallel:false }
);

// Moneda - Articulo
CALL apoc.periodic.iterate(
'MATCH (m:Moneda), (a:Articulo)
 WHERE m.Clave = a.Moneda
 RETURN m, a',
'MERGE (m)-[:USA_MONEDA_EN_ARTICULO]->(a)',
{ batchSize:10000, parallel:false }
);

// Moneda - Cliente
CALL apoc.periodic.iterate(
'MATCH (m:Moneda), (c:Cliente)
 WHERE m.Clave = c.Moneda
 RETURN m, c',
'MERGE (m)-[:USA_MONEDA_EN_CLIENTE]->(c)',
{ batchSize:10000, parallel:false }
);

// Cliente - EntradaEncabezado
CALL apoc.periodic.iterate(
'MATCH (c:Cliente), (e:EntradaEncabezado)
 WHERE c.Clave = e.Cliente
 RETURN c, e',
'MERGE (c)-[:REALIZA_ENTRADA]->(e)',
{ batchSize:10000, parallel:false }
);

// SalidaEncabezado - SalidaDetalle
CALL apoc.periodic.iterate(
'MATCH (s:SalidaEncabezado), (sd:SalidaDetalle)
 WHERE s.Folio = sd.Folio
 RETURN s, sd',
'MERGE (s)-[:TIENE_DETALLE_SALIDA]->(sd)',
{ batchSize:10000, parallel:false }
);

// EntradaEncabezado - EntradaDetalle
CALL apoc.periodic.iterate(
'MATCH (e:EntradaEncabezado), (ed:EntradaDetalle)
 WHERE e.Folio = ed.Folio
 RETURN e, ed',
'MERGE (e)-[:TIENE_DETALLE_ENTRADA]->(ed)',
{ batchSize:10000, parallel:false }
);

// Articulo - SalidaDetalle
CALL apoc.periodic.iterate(
'MATCH (a:Articulo), (sd:SalidaDetalle)
 WHERE a.clave = sd.Articulo
 RETURN a, sd',
'MERGE (a)-[:APARECE_EN_SALIDA_DETALLE]->(sd)',
{ batchSize:10000, parallel:false }
);

// Articulo - EntradaDetalle
CALL apoc.periodic.iterate(
'MATCH (a:Articulo), (ed:EntradaDetalle)
 WHERE a.clave = ed.Articulo
 RETURN a, ed',
'MERGE (a)-[:APARECE_EN_ENTRADA_DETALLE]->(ed)',
{ batchSize:10000, parallel:false }
);

// ArticuloClase - Articulo
CALL apoc.periodic.iterate(
'MATCH (ac:ArticuloClase), (a:Articulo)
 WHERE ac.Clave = a.ArticuloClase
 RETURN ac, a',
'MERGE (ac)-[:CLASIFICA_ARTICULO]->(a)',
{ batchSize:10000, parallel:false }
);

// ArticuloGrupo - Articulo
CALL apoc.periodic.iterate(
'MATCH (ag:ArticuloGrupo), (a:Articulo)
 WHERE ag.Clave = a.ArticuloGrupo
 RETURN ag, a',
'MERGE (ag)-[:AGRUPA_ARTICULO]->(a)',
{ batchSize:10000, parallel:false }
);

// ArticuloTipo - Articulo
CALL apoc.periodic.iterate(
'MATCH (at:ArticuloTipo), (a:Articulo)
 WHERE at.Clave = a.ArticuloTipo
 RETURN at, a',
'MERGE (at)-[:TIPIFICA_ARTICULO]->(a)',
{ batchSize:10000, parallel:false }
);