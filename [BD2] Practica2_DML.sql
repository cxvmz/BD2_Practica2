CREATE OR REPLACE PROCEDURE INSERT_CLIENTES
IS
    v_file UTL_FILE.FILE_TYPE;
    v_string VARCHAR(23767);
    v_line NUMBER := 1;
    /*
        PARA LA TABLA
    */
    id_cliente INT;
    nombre_cliente VARCHAR(50);
    apellido_cliente VARCHAR(50);
    direccion_cliente VARCHAR(50);
    dpi_cliente VARCHAR(50);
BEGIN
    v_file := UTL_FILE.FOPEN('RUTA_CSVs', 'Clientes.csv', 'r');
    LOOP
        BEGIN
            UTL_FILE.GET_LINE(v_file, v_string);
            id_cliente := TO_NUMBER(regexp_substr(v_string, '[^,]+', 1, 1));
            nombre_cliente := regexp_substr(v_string, '[^,]+', 1, 2);
            apellido_cliente := regexp_substr(v_string, '[^,]+', 1, 3);
            direccion_cliente := regexp_substr(v_string, '[^,]+', 1, 4);
            dpi_cliente := regexp_substr(v_string, '[^,]+', 1, 5);

            INSERT INTO Cliente VALUES(id_cliente, nombre_cliente, apellido_cliente, direccion_cliente, dpi_cliente);
            v_line := v_line + 1;
            EXCEPTION
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('An error occurred.');
                    CONTINUE;
        END;
    END LOOP;
    UTL_FILE.FCLOSE(v_file);
EXCEPTION
    WHEN no_data_found THEN
        UTL_FILE.FCLOSE(v_file);
END;
/

CREATE OR REPLACE PROCEDURE INSERT_VENDEDORES
IS
    v_file UTL_FILE.FILE_TYPE;
    v_string VARCHAR(23767);
    v_line NUMBER := 1;
    /*
        PARA LA TABLA
    */
    id_vendedor INT;
    nombre_vendedor VARCHAR(50);
    apellido_vendedor VARCHAR(50);
    correo_vendedor VARCHAR(50);
    dpi_vendedor VARCHAR(50);
BEGIN
    v_file := UTL_FILE.FOPEN('RUTA_CSVs', 'Vendedores.csv', 'r');
    LOOP
        BEGIN
            UTL_FILE.GET_LINE(v_file, v_string);
            id_vendedor := TO_NUMBER(regexp_substr(v_string, '[^,]+', 1, 1));
            nombre_vendedor := regexp_substr(v_string, '[^,]+', 1, 2);
            apellido_vendedor := regexp_substr(v_string, '[^,]+', 1, 3);
            correo_vendedor := regexp_substr(v_string, '[^,]+', 1, 4);
            dpi_vendedor := regexp_substr(v_string, '[^,]+', 1, 5);

            INSERT INTO Vendedor VALUES(id_vendedor, nombre_vendedor, apellido_vendedor, correo_vendedor, dpi_vendedor);
            v_line := v_line + 1;
            EXCEPTION
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('An error occurred.');
                    CONTINUE;
        END;
    END LOOP;
    UTL_FILE.FCLOSE(v_file);
EXCEPTION
    WHEN no_data_found THEN
        UTL_FILE.FCLOSE(v_file);
END;
/

CREATE OR REPLACE PROCEDURE INSERT_PRODUCTOS
IS
    v_file UTL_FILE.FILE_TYPE;
    v_string VARCHAR(23767);
    v_line NUMBER := 1;
    /*
        PARA LA TABLA
    */
    id_producto INT;
    nombre_producto VARCHAR(30);
    precio_producto INT;
    stock_producto INT;
BEGIN
    v_file := UTL_FILE.FOPEN('RUTA_CSVs', 'Productos.csv', 'r');
    LOOP
        BEGIN
            UTL_FILE.GET_LINE(v_file, v_string);
            id_producto := TO_NUMBER(regexp_substr(v_string, '[^,]+', 1, 1));
            nombre_producto := regexp_substr(v_string, '[^,]+', 1, 2);
            precio_producto := TO_NUMBER(regexp_substr(v_string, '[^,]+', 1, 3));
            stock_producto := TO_NUMBER(regexp_substr(v_string, '[^,]+', 1, 4));
            
            INSERT INTO Producto VALUES(id_producto, nombre_producto, precio_producto, stock_producto);
            v_line := v_line + 1;
            EXCEPTION
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('An error occurred.');
                    CONTINUE;
        END;
    END LOOP;
    UTL_FILE.FCLOSE(v_file);
EXCEPTION
    WHEN no_data_found THEN
        UTL_FILE.FCLOSE(v_file);
END;
/

CREATE OR REPLACE PROCEDURE INSERT_FACTURAS
IS
    v_file UTL_FILE.FILE_TYPE;
    v_string VARCHAR(23767);
    v_line NUMBER := 1;
    /*
        PARA LA TABLA
    */
    id_factura INT;
    id_cliente INT;
    id_vendedor INT;
    fecha_factura DATE;
BEGIN
    v_file := UTL_FILE.FOPEN('RUTA_CSVs', 'Facturas.csv', 'r');
    LOOP
        BEGIN
            UTL_FILE.GET_LINE(v_file, v_string);
            id_factura := TO_NUMBER(regexp_substr(v_string, '[^,]+', 1, 1));
            id_cliente := TO_NUMBER(regexp_substr(v_string, '[^,]+', 1, 2));
            id_vendedor := TO_NUMBER(regexp_substr(v_string, '[^,]+', 1, 3));
            fecha_factura := regexp_substr(v_string, '[^,]+', 1, 4);    -- READ DATE

            INSERT INTO Factura VALUES(id_factura, id_cliente, id_vendedor, fecha_factura);
            v_line := v_line + 1;
            EXCEPTION
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('An error occurred.');
                    CONTINUE;
        END;
    END LOOP;
    UTL_FILE.FCLOSE(v_file);
EXCEPTION
    WHEN no_data_found THEN
        UTL_FILE.FCLOSE(v_file);
END;
/

CREATE OR REPLACE PROCEDURE INSERT_DETALLE
IS
    v_file UTL_FILE.FILE_TYPE;
    v_string VARCHAR(23767);
    v_line NUMBER := 1;
    /*
        PARA LA TABLA
    */
    id_factura INT;
    id_producto INT;
    cantidad INT;
    sub_total INT;
    aux INT;
BEGIN
    v_file := UTL_FILE.FOPEN('RUTA_CSVs', 'Detalle.csv', 'r');
    LOOP
        BEGIN
            UTL_FILE.GET_LINE(v_file, v_string);
            id_factura := TO_NUMBER(regexp_substr(v_string, '[^,]+', 1, 1));
            id_producto := TO_NUMBER(regexp_substr(v_string, '[^,]+', 1, 2));
            cantidad := TO_NUMBER(regexp_substr(v_string, '[^,]+', 1, 3));
            
            SELECT precio_producto INTO aux FROM Producto WHERE id_producto=id_producto
            -- CALCULAR SUBTOTAL
            sub_total := cantidad * aux;

            INSERT INTO Detalle(id_factura, id_producto, cantidad, sub_total) VALUES(id_factura, id_producto, cantidad, sub_total);
            v_line := v_line + 1;
            EXCEPTION
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('An error occurred.');
                    CONTINUE;
        END;
    END LOOP;
    UTL_FILE.FCLOSE(v_file);
EXCEPTION
    WHEN no_data_found THEN
        UTL_FILE.FCLOSE(v_file);
END;
/