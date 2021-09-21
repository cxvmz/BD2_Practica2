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

    FOREIGN KEY(id_cliente) REFERENCE Cliente(id_cliente),
    FOREIGN KEY(id_vendedor) REFERENCE Vendedor(id_vendedor)
);

CREATE TABLE Detalle(
    id_detalle INT NOT NULL PRIMARY KEY,
    id_factura INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    sub_total INT NOT NULL,

    FOREIGN KEY(id_factura) REFERENCE Factura(id_factura),
    FOREIGN KEY(id_producto) REFERENCE Producto(id_producto)
);