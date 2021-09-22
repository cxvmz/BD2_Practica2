CREATE TABLE Cliente(
    id_cliente INT NOT NULL PRIMARY KEY,
    nombre_cliente VARCHAR(50) NOT NULL,
    apellido_cliente VARCHAR(50) NOT NULL,
    direccion_cliente VARCHAR(50) NOT NULL,
    dpi_cliente VARCHAR(50) NOT NULL
);

CREATE TABLE Vendedor(
    id_vendedor INT NOT NULL PRIMARY KEY,
    nombre_vendedor VARCHAR(50) NOT NULL,
    apellido_vendedor VARCHAR(50) NOT NULL,
    correo_vendedor VARCHAR(50) NOT NULL,
    dpi_vendedor VARCHAR(50) NOT NULL
);

CREATE TABLE Producto(
    id_producto INT NOT NULL PRIMARY KEY,
    nombre_producto VARCHAR(30) NOT NULL,
    precio_producto INT NOT NULL,
    stock_producto INT NOT NULL
);

CREATE TABLE Factura(
    id_factura INT NOT NULL PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_vendedor INT NOT NULL,
    fecha_factura DATE NOT NULL,

    FOREIGN KEY(id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY(id_vendedor) REFERENCES Vendedor(id_vendedor)
);

CREATE TABLE Detalle(
    id_detalle INT NOT NULL PRIMARY KEY,
    id_factura INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    sub_total INT NOT NULL,

    FOREIGN KEY(id_factura) REFERENCES Factura(id_factura),
    FOREIGN KEY(id_producto) REFERENCES Producto(id_producto)
);

/*
    TOP 10 DE LOS VENDEDORES QUE HAN CONCRETADO MÁS VENTAS
*/
SELECT
    nombre_vendedor,
    COUNT(Factura.id_vendedor) AS Ventas
FROM Vendedor
    INNER JOIN Factura
        ON Factura.id_vendedor = Vendedor.id_vendedor
GROUP BY Vendedor.id_vendedor
ORDER BY Ventas DESC
WHERE ROWNUM <= 10;

/*
    TOP 3 DE PRODUCTOS MAS VENDIDOS EN EL AÑO 2020
*/
SELECT
    nombre_producto,
    SUM(cantidad) AS Veces_Vendidas
FROM Producto
    INNER JOIN Detalle
        ON Detalle.id_producto = Producto.id_producto
    INNER JOIN Factura
        ON Factura.id_factura = Detalle.id_factura
GROUP BY Producto.id_producto
ORDER BY Veces_Vendidas DESC
WHERE
    ROWNUM <= 3 AND
    Factura.fecha_factura >= TO_DATE("01/JAN/2020", "dd/mon/yyyy") AND
    Factura.fecha_factura <= TO_DATE("31/DEC/2020", "dd/mon/yyyy");

/*
    TOP 5 DE LOS PRODUCTOS QUE MENOS SE HAN VENDIDO EN EL AÑO 2021
*/
SELECT
    nombre_producto,
    SUM(cantidad) AS Veces_Vendidas
FROM Producto
    INNER JOIN Detalle
        ON Detalle.id_producto = Producto.id_producto
    INNER JOIN Factura
        ON Factura.id_factura = Detalle.id_factura
GROUP BY Producto.id_producto
ORDER BY Veces_Vendidas ASC
WHERE
    ROWNUM <= 5 AND
    Factura.fecha_factura >= TO_DATE("01/JAN/2021", "dd/mon/yyyy") AND
    Factura.fecha_factura <= TO_DATE("31/DEC/2021", "dd/mon/yyyy");

/*
    TOP 5 DE VENDEDORES QUE HAN ATENDIDO UNA MAYOR CANTIDAD DE CLIENTES
*/
SELECT
    nombre_vendedor,
    COUNT(id_cliente) AS Clientes
FROM Vendedor
    INNER JOIN Factura
        ON Factura.id_vendedor = Vendedor.id_vendedor
GROUP BY nombre_vendedor, id_cliente
ORDER BY Clientes DESC
WHERE ROWNUM <= 5;