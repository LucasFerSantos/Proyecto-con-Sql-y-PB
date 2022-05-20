CREATE OR REPLACE VIEW v_venta_mes_empleado_sucursal AS
SELECT c.anio,
		c.mes,
        e.Apellido,
        e.Nombre,
        se.Sector,
        ca.Cargo,
        s.Sucursal,
        SUM(v.Precio * v.Cantidad * v.Outlier)		AS venta,
        SUM(v.Cantidad * v.Outlier)					AS venta_cantidad,
        SUM(v.Outlier)								AS venta_volumen,
        SUM(v.Precio * v.Cantidad)		AS venta_outlier,
        SUM(v.Cantidad)					AS venta_cantidad_outlier,
        COUNT(v.IdVenta)				AS venta_volumen_outlier
FROM venta v JOIN empleado e
		ON (v.IdEmpleado = e.IdEmpleado)
	JOIN sector se
    	ON (se.IdSector = e.IdSector)
    JOIN cargo ca
    	ON (ca.IdCargo = e.IdCargo)
	JOIN sucursal s
    	ON (v.IdSucursal = s.IdSucursal)
    JOIN calendario c
    	ON (v.Fecha = c.fecha)
GROUP BY c.anio,
		c.mes,
        e.Apellido,
        e.Nombre,
        se.Sector,
        ca.Cargo,
        s.Sucursal;
		
CREATE OR REPLACE VIEW v_venta_trimestre_cliente AS
SELECT 	ca.anio,
		ca.trimestre,
        c.Nombre_y_Apellido,
        c.Edad,
		c.Rango_Etario,
        l.Localidad,
        p.Provincia,
        cn.Canal,
        SUM(v.Precio * v.Cantidad * v.Outlier)		AS venta,
        SUM(v.Cantidad * v.Outlier)					AS venta_cantidad,
        SUM(v.Outlier)								AS venta_volumen,
        SUM(v.Precio * v.Cantidad)		AS venta_outlier,
        SUM(v.Cantidad)					AS venta_cantidad_outlier,
        COUNT(v.IdVenta)				AS venta_volumen_outlier
FROM venta v JOIN cliente c
		ON (v.IdCliente = c.IdCliente)
    JOIN localidad l
    	ON (c.IdLocalidad = l.IdLocalidad)
    JOIN provincia p
    	ON (l.IdProvincia = p.IdProvincia)
    JOIN calendario ca
    	ON (v.Fecha = ca.fecha)
	JOIN canal_venta cn
    	ON (v.IdCanal = cn.IdCanal)
GROUP BY ca.anio,
		ca.trimestre,
        c.Nombre_y_Apellido,
        c.Edad,
		c.Rango_Etario,
        l.Localidad,
        p.Provincia,
        cn.Canal;
		
CREATE OR REPLACE VIEW v_venta_mes_producto AS
SELECT 	c.anio,
		c.trimestre,
        c.mes,
        p.Producto,
        t.TipoProducto,
        SUM(v.Precio * v.Cantidad * v.Outlier)		AS venta,
        SUM(v.Cantidad * v.Outlier)					AS venta_cantidad,
        SUM(v.Outlier)								AS venta_volumen,
        SUM(v.Precio * v.Cantidad)		AS venta_outlier,
        SUM(v.Cantidad)					AS venta_cantidad_outlier,
        COUNT(v.IdVenta)				AS venta_volumen_outlier
FROM venta v JOIN producto p
		ON (v.IdProducto = p.IdProducto)
    JOIN tipo_producto t
    	ON (p.IdTipoProducto = t.IdTipoProducto)
    JOIN calendario c
    	ON (v.Fecha = c.fecha)
GROUP BY c.anio,
		c.trimestre,
        c.mes,
        p.Producto,
        t.TipoProducto;
		
CREATE OR REPLACE VIEW v_venta_trimestre_canal AS
SELECT 	c.anio,
		c.trimestre,
        ca.Canal,
        SUM(v.Precio * v.Cantidad * v.Outlier)		AS venta,
        SUM(v.Cantidad * v.Outlier)					AS venta_cantidad,
        SUM(v.Outlier)								AS venta_volumen,
        SUM(v.Precio * v.Cantidad)		AS venta_outlier,
        SUM(v.Cantidad)					AS venta_cantidad_outlier,
        COUNT(v.IdVenta)				AS venta_volumen_outlier
FROM venta v JOIN canal_venta ca
    	ON (v.IdCanal = ca.IdCanal)
    JOIN calendario c
    	ON (v.Fecha = c.fecha)
GROUP BY c.anio,
		c.trimestre,
        ca.Canal;
		
CREATE OR REPLACE VIEW v_gasto_mes_sucursal AS
SELECT 	c.anio,
		c.mes,
        s.Sucursal,
        t.Tipo_Gasto,
        l.Localidad,
        p.Provincia,
        SUM(g.Monto)		AS gasto,
        COUNT(g.IdGasto)	AS gasto_volumen
FROM gasto g JOIN sucursal s
    	ON (g.IdSucursal = s.IdSucursal)
    JOIN localidad l
    	ON (s.IdLocalidad = l.IdLocalidad)
    JOIN provincia p
    	ON (l.IdProvincia = p.IdProvincia)
    JOIN tipo_gasto t
    	ON (g.IdTipoGasto = t.IdTipoGasto)
    JOIN calendario c
    	ON (g.Fecha = c.fecha)
GROUP BY c.anio,
		c.mes,
        s.Sucursal,
        t.Tipo_Gasto,
        l.Localidad,
        p.Provincia;
		
CREATE OR REPLACE VIEW v_compra_mes_producto AS
SELECT 	c.anio,
		c.trimestre,
        c.mes,
        p.Producto,
        t.TipoProducto,
        SUM(co.Precio * co.Cantidad)	AS compra,
        SUM(co.Cantidad)				AS compra_cantidad,
        COUNT(co.IdCompra)				AS compra_volumen
FROM compra co JOIN producto p
		ON (co.IdProducto = p.IdProducto)
    JOIN tipo_producto t
    	ON (p.IdTipoProducto = t.IdTipoProducto)
    JOIN calendario c
    	ON (co.Fecha = c.fecha)
GROUP BY c.anio,
		c.trimestre,
        c.mes,
        p.Producto,
        t.TipoProducto;

CREATE OR REPLACE VIEW v_venta_dia AS
SELECT 	ca.anio,
		ca.trimestre,
		ca.mes,
		v.Fecha,
		v.Fecha_Entrega,
        DATEDIFF(v.Fecha_Entrega, v.Fecha) AS Demora_Entrega,
        c.Nombre_y_Apellido,
		c.Rango_Etario,
        l.Localidad,
        p.Provincia,
        cn.Canal,
        po.IdProducto,
        po.Producto,
        tpo.TipoProducto,
        s.IdSucursal,
        s.Sucursal,
        v.Precio,
        v.Cantidad
FROM venta v JOIN cliente c
		ON (v.IdCliente = c.IdCliente)
    JOIN localidad l
    	ON (c.IdLocalidad = l.IdLocalidad)
    JOIN provincia p
    	ON (l.IdProvincia = p.IdProvincia)
    JOIN calendario ca
    	ON (v.Fecha = ca.fecha)
	JOIN canal_venta cn
    	ON (v.IdCanal = cn.IdCanal)
    JOIN producto po
    	ON (v.IdProducto = po.IdProducto)
    JOIN tipo_producto tpo
    	ON (po.IdTipoProducto = tpo.IdTipoProducto)
    JOIN sucursal s
    	ON (v.IdSucursal = s.IdSucursal)
WHERE v.Outlier = 1;
		
CREATE OR REPLACE VIEW v_gasto_dia AS
SELECT 	c.anio,
		c.trimestre,
		c.mes,
        g.Fecha,
        s.Sucursal,
        s.IdSucursal,
        t.Tipo_Gasto,
        l.Localidad,
        p.Provincia,
        g.Monto
FROM gasto g JOIN sucursal s
    	ON (g.IdSucursal = s.IdSucursal)
    JOIN localidad l
    	ON (s.IdLocalidad = l.IdLocalidad)
    JOIN provincia p
    	ON (l.IdProvincia = p.IdProvincia)
    JOIN tipo_gasto t
    	ON (g.IdTipoGasto = t.IdTipoGasto)
    JOIN calendario c
    	ON (g.Fecha = c.fecha);
		
CREATE OR REPLACE VIEW v_compra_dia AS
SELECT 	c.anio,
		c.trimestre,
        c.mes,
        co.Fecha,
        p.IdProducto,
        p.Producto,
        t.TipoProducto,
        co.Precio,
        co.Cantidad
FROM compra co JOIN producto p
		ON (co.IdProducto = p.IdProducto)
    JOIN tipo_producto t
    	ON (p.IdTipoProducto = t.IdTipoProducto)
    JOIN calendario c
    	ON (co.Fecha = c.fecha);
		
CREATE OR REPLACE VIEW v_venta_mes_sucursal AS
SELECT c.anio,
		c.mes,
        s.IdSucursal,
        s.Sucursal,
        l.Localidad,
        p.Provincia,
        SUM(v.Precio * v.Cantidad)	AS venta,
        SUM(v.Cantidad)				AS venta_cantidad,
        COUNT(v.IdVenta)			AS venta_volumen
FROM venta v JOIN sucursal s
    	ON (v.IdSucursal = s.IdSucursal)
    JOIN localidad l
    	ON (s.IdLocalidad = l.IdLocalidad)
    JOIN provincia p
    	ON (l.IdProvincia = p.IdProvincia)
    JOIN calendario c
    	ON (v.Fecha = c.fecha)
WHERE v.Outlier = 1
GROUP BY c.anio,
		c.mes,
        s.IdSucursal,
        s.Sucursal,
        l.Localidad,
        p.Provincia;

CREATE OR REPLACE VIEW v_venta_mes_producto AS
SELECT 	c.anio,
		c.trimestre,
        c.mes,
        p.IdProducto,
        p.Producto,
        t.TipoProducto,
        SUM(v.Precio * v.Cantidad)	AS venta,
        SUM(v.Cantidad)				AS venta_cantidad,
        COUNT(v.IdVenta)			AS venta_volumen
FROM venta v JOIN producto p
		ON (v.IdProducto = p.IdProducto)
    JOIN tipo_producto t
    	ON (p.IdTipoProducto = t.IdTipoProducto)
    JOIN calendario c
    	ON (v.Fecha = c.fecha)
WHERE v.Outlier = 1
GROUP BY c.anio,
		c.trimestre,
        c.mes,
        p.IdProducto,
        p.Producto,
        t.TipoProducto;
		
CREATE OR REPLACE VIEW v_gasto_mes_sucursal AS
SELECT 	c.anio,
		c.mes,
        s.IdSucursal,
        s.Sucursal,
        t.Tipo_Gasto,
        l.Localidad,
        p.Provincia,
        SUM(g.Monto)		AS gasto,
        COUNT(g.IdGasto)	AS gasto_volumen
FROM gasto g JOIN sucursal s
    	ON (g.IdSucursal = s.IdSucursal)
    JOIN localidad l
    	ON (s.IdLocalidad = l.IdLocalidad)
    JOIN provincia p
    	ON (l.IdProvincia = p.IdProvincia)
    JOIN tipo_gasto t
    	ON (g.IdTipoGasto = t.IdTipoGasto)
    JOIN calendario c
    	ON (g.Fecha = c.fecha)
GROUP BY c.anio,
		c.mes,
        s.IdSucursal,
        s.Sucursal,
        t.Tipo_Gasto,
        l.Localidad,
        p.Provincia;
		
CREATE OR REPLACE VIEW v_compra_mes_producto AS
SELECT 	c.anio,
		c.trimestre,
        c.mes,
        p.IdProducto,
        p.Producto,
        t.TipoProducto,
        SUM(co.Precio * co.Cantidad)	AS compra,
        SUM(co.Cantidad)				AS compra_cantidad,
        COUNT(co.IdCompra)				AS compra_volumen
FROM compra co JOIN producto p
		ON (co.IdProducto = p.IdProducto)
    JOIN tipo_producto t
    	ON (p.IdTipoProducto = t.IdTipoProducto)
    JOIN calendario c
    	ON (co.Fecha = c.fecha)
GROUP BY c.anio,
		c.trimestre,
        c.mes,
        p.IdProducto,
        p.Producto,
        t.TipoProducto;

CREATE OR REPLACE VIEW v_compra_dia AS
SELECT 	c.anio,
		c.trimestre,
        c.mes,
        co.Fecha,
        p.IdProducto,
        p.Producto,
        t.TipoProducto,
        pr.Nombre as Proveedor,
        co.Precio,
        co.Cantidad
FROM compra co JOIN producto p
		ON (co.IdProducto = p.IdProducto)
    JOIN tipo_producto t
    	ON (p.IdTipoProducto = t.IdTipoProducto)
    JOIN calendario c
    	ON (co.Fecha = c.fecha)
    JOIN proveedor pr
    	ON (co.IdProveedor = pr.IdProveedor);
		
CREATE OR REPLACE VIEW v_venta_dia AS
SELECT 	ca.anio,
		ca.trimestre,
		ca.mes,
		v.Fecha,
		v.Fecha_Entrega,
        DATEDIFF(v.Fecha_Entrega, v.Fecha) AS Demora_Entrega,
        c.Nombre_y_Apellido,
		c.Rango_Etario,
        l.Localidad,
        p.Provincia,
        cn.Canal,
        po.IdProducto,
        po.Producto,
        tpo.TipoProducto,
        s.IdSucursal,
        s.Sucursal,
        CONCAT(e.CodigoEmpleado, " - ", e.Apellido, ", ", e.Nombre) as Vendedor,
        v.Precio,
		v.Costo,
        v.Cantidad
FROM venta v JOIN cliente c
		ON (v.IdCliente = c.IdCliente)
    JOIN localidad l
    	ON (c.IdLocalidad = l.IdLocalidad)
    JOIN provincia p
    	ON (l.IdProvincia = p.IdProvincia)
    JOIN calendario ca
    	ON (v.Fecha = ca.fecha)
	JOIN canal_venta cn
    	ON (v.IdCanal = cn.IdCanal)
    JOIN producto po
    	ON (v.IdProducto = po.IdProducto)
    JOIN tipo_producto tpo
    	ON (po.IdTipoProducto = tpo.IdTipoProducto)
    JOIN sucursal s
    	ON (v.IdSucursal = s.IdSucursal)
    JOIN empleado e
    	ON (v.IdEmpleado = e.IdEmpleado)
WHERE v.Outlier = 1;

SELECT DISTINCT v.Distancia_Entrega, l1.Localidad, p1.Provincia, l2.Localidad, p2.Provincia, s.Sucursal
FROM venta v JOIN cliente c
		ON (v.IdCliente = c.IdCliente)
    JOIN sucursal s
    	ON (v.IdSucursal = s.IdSucursal)
    JOIN localidad l1
    	ON (l1.IdLocalidad = c.IdLocalidad)
    JOIN provincia p1
    	ON (p1.IdProvincia = l1.IdProvincia)
    JOIN localidad l2
    	ON (l2.IdLocalidad = s.IdLocalidad)
    JOIN provincia p2
    	ON (p2.IdProvincia = l2.IdProvincia)
where c.Latitud < 0 And c.Longitud < 0
ORDER BY 3, 2, 1;

CREATE OR REPLACE VIEW v_venta_mes_producto AS
SELECT 	c.anio,
		c.trimestre,
        c.mes,
        p.IdProducto,
        p.Producto,
        t.TipoProducto,
        lo.Latitud,
        lo.Longitud,
        lo.Localidad,
        pr.Provincia,
        SUM(v.Precio * v.Cantidad)	AS venta,
        SUM(v.Cantidad)				AS venta_cantidad,
        COUNT(v.IdVenta)			AS venta_volumen
FROM venta v JOIN producto p
		ON (v.IdProducto = p.IdProducto)
    JOIN tipo_producto t
    	ON (p.IdTipoProducto = t.IdTipoProducto)
    JOIN cliente cl
    	ON (v.IdCliente = cl.IdCliente)
    JOIN Localidad lo
    	ON (cl.IdLocalidad = lo.IdLocalidad)
    JOIN provincia pr
    	ON (lo.IdProvincia = pr.IdProvincia)
    JOIN calendario c
    	ON (v.Fecha = c.fecha)
WHERE v.Outlier = 1
GROUP BY c.anio,
		c.trimestre,
        c.mes,
        p.IdProducto,
        p.Producto,
        t.TipoProducto,
        lo.Latitud,
        lo.Longitud,
        lo.Localidad,
        pr.Provincia;
		
CREATE OR REPLACE VIEW v_venta_mes_sucursal AS
SELECT c.anio,
		c.mes,
        s.IdSucursal,
        s.Sucursal,
        s.Latitud,
        s.Longitud,
        l.Localidad,
        p.Provincia,
		cv.Canal,
        SUM(v.Precio * v.Cantidad)	AS venta,
        SUM(v.Cantidad)				AS venta_cantidad,
        COUNT(v.IdVenta)			AS venta_volumen
FROM venta v JOIN sucursal s
    	ON (v.IdSucursal = s.IdSucursal)
    JOIN localidad l
    	ON (s.IdLocalidad = l.IdLocalidad)
    JOIN provincia p
    	ON (l.IdProvincia = p.IdProvincia)
	JOIN canal_venta cv
		ON (cv.IdCanal = v.IdCanal)
    JOIN calendario c
    	ON (v.Fecha = c.fecha)
WHERE v.Outlier = 1
GROUP BY c.anio,
		c.mes,
        s.IdSucursal,
        s.Sucursal,
        s.Latitud,
        s.Longitud,
        l.Localidad,
        p.Provincia,
		cv.Canal;
		
CREATE OR REPLACE VIEW v_venta_mes_cliente AS
SELECT 	c.anio,
		c.semestre,
		c.trimestre,
		c.mes,
		cl.Rango_Etario,
        cl.Nombre_y_Apellido,
        cl.Domicilio,
        cl.Latitud,
        cl.Longitud,
        l.Localidad,
        p.Provincia,
		cv.Canal,
        SUM(v.Precio * v.Cantidad)	AS venta,
        SUM(v.Cantidad)				AS venta_cantidad,
        COUNT(v.IdVenta)			AS venta_volumen
FROM venta v JOIN cliente cl
    	ON (v.IdCliente = cl.IdCliente)
    JOIN localidad l
    	ON (cl.IdLocalidad = l.IdLocalidad)
    JOIN provincia p
    	ON (l.IdProvincia = p.IdProvincia)
	JOIN canal_venta cv
		ON (cv.IdCanal = v.IdCanal)
    JOIN calendario c
    	ON (v.Fecha = c.fecha)
WHERE v.Outlier = 1
GROUP BY c.anio,
		c.semestre,
		c.trimestre,
		c.mes,
		cl.Rango_Etario,
        cl.Nombre_y_Apellido,
        cl.Domicilio,
        cl.Latitud,
        cl.Longitud,
        l.Localidad,
        p.Provincia,
		cv.Canal;
		
CREATE OR REPLACE VIEW v_estructura_base AS
SELECT * FROM information_schema.table_constraints
WHERE table_schema    = DATABASE();

/*Vistas para modelo Estrella*/
CREATE OR REPLACE VIEW v_modelo_fact_inicial AS SELECT * FROM fact_inicial;

CREATE OR REPLACE VIEW v_modelo_fact_venta AS 
SELECT 	v.IdProducto * 10000000000 + v.IdSucursal * 100000000 + c.IdFecha IdProductoSucursalFecha,
		v.Fecha_Entrega,
        DATEDIFF(v.Fecha_Entrega, v.Fecha) AS Dias_Entrega,
        v.IdCanal,
        v.IdCliente,
        v.IdEmpleado,
        v.Precio,
        v.Cantidad
FROM venta v JOIN calendario c
	ON (c.fecha = v.Fecha)
WHERE v.Outlier = 1;
	
CREATE OR REPLACE VIEW v_modelo_fact_gasto AS 
SELECT 	g.IdSucursal * 100000000 + c.IdFecha IdSucursalFecha,
		g.IdTipoGasto,
        g.Monto
FROM gasto g JOIN calendario c
	ON (c.fecha = g.Fecha);

CREATE OR REPLACE VIEW v_modelo_fact_compra AS 
SELECT  co.IdProducto * 100000000 + c.IdFecha AS  IdProductoFecha,
		co.IdProveedor,
        co.Precio,
        co.Cantidad
FROM compra co JOIN calendario c
	ON (c.fecha = co.Fecha);
	
CREATE OR REPLACE VIEW v_modelo_dim_calendario AS
SELECT 	c.IdFecha,
		c.Fecha,
        c.dia_nombre,
        c.semana,
        c.mes,
        c.mes_nombre,
        c.trimestre,
        c.anio
FROM calendario c;

CREATE OR REPLACE VIEW v_modelo_dim_cliente AS
SELECT 	c.IdCliente,
		c.Nombre_y_Apellido,
        c.Domicilio,
        c.Latitud,
        c.Longitud,
        c.Edad,
        c.Rango_Etario
FROM cliente c;

CREATE OR REPLACE VIEW v_modelo_dim_producto AS
SELECT 	p.IdProducto,
		p.Producto,
        p.IdTipoProducto,
        p.Precio
FROM producto p;

CREATE OR REPLACE VIEW v_modelo_dim_tipo_producto AS
SELECT 	tp.IdTipoProducto,
		tp.TipoProducto
FROM tipo_producto tp;

CREATE OR REPLACE VIEW v_modelo_dim_sucursal AS
SELECT 	s.IdSucursal,
		s.Sucursal,
        s.Domicilio,
        s.Latitud,
        s.Longitud
FROM sucursal s;

CREATE OR REPLACE VIEW v_modelo_dim_proveedor AS
SELECT  p.IdProveedor,
		p.Nombre as Proveedor
FROM proveedor p;

CREATE OR REPLACE VIEW v_modelo_dim_canal_venta AS
SELECT  c.IdCanal,
		c.Canal
FROM canal_venta c;

CREATE OR REPLACE VIEW v_modelo_dim_tipo_gasto AS
SELECT  t.IdTipoGasto,
		t.Tipo_Gasto
FROM tipo_gasto t;

CREATE OR REPLACE VIEW v_modelo_dim_empleado AS
SELECT  e.IdEmpleado,
		e.CodigoEmpleado,
        e.Apellido,
        e.Nombre,
        e.Salario,
        e.IdSector,
        e.IdCargo
FROM empleado e;

CREATE OR REPLACE VIEW v_modelo_dim_cargo AS
SELECT  c.IdCargo,
		c.Cargo
FROM cargo c;

CREATE OR REPLACE VIEW v_modelo_dim_sector AS
SELECT  s.IdSector,
		s.Sector
FROM sector s;