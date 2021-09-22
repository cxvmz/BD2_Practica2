CREATE OR REPLACE PROCEDURE INSERT_CLIENTES
IS
    v_file UTL_FILE.FILE_TYPE;
    v_string VARCHAR(23767);
    id_cliente INT;
    nombre_cliente VARCHAR(50);
    apellido_cliente VARCHAR(50);
    direccion_cliente VARCHAR(50);
    dpi_cliente VARCHAR(50);
BEGIN
    v_file := UTL_FILE.FOPEN('RUTA_CSVS', 'Clientes.csv', 'r');
    UTL_FILE.GET_LINE(v_file, v_string);
    LOOP
        BEGIN
            UTL_FILE.GET_LINE(v_file, v_string);
            IF v_string IS NULL THEN
                EXIT;
            END IF;
            id_cliente := TO_NUMBER(regexp_substr(v_string, '[^,]+', 1, 1));
            nombre_cliente := regexp_substr(v_string, '[^,]+', 1, 2);
            apellido_cliente := regexp_substr(v_string, '[^,]+', 1, 3);
            direccion_cliente := regexp_substr(v_string, '[^,]+', 1, 4);
            dpi_cliente := regexp_substr(v_string, '[^,]+', 1, 5);

            IF id_cliente IS NULL OR nombre_cliente IS NULL OR apellido_cliente IS NULL OR direccion_cliente IS NULL OR dpi_cliente IS NULL THEN
                CONTINUE;
            END IF;

            INSERT INTO Cliente VALUES(id_cliente, nombre_cliente, apellido_cliente, direccion_cliente, dpi_cliente);
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN
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
    id_vendedor INT;
    nombre_vendedor VARCHAR(50);
    apellido_vendedor VARCHAR(50);
    correo_vendedor VARCHAR(50);
    dpi_vendedor VARCHAR(50);
BEGIN
    v_file := UTL_FILE.FOPEN('RUTA_CSVS', 'Vendedores.csv', 'r');
    UTL_FILE.GET_LINE(v_file, v_string);
    LOOP
        BEGIN
            UTL_FILE.GET_LINE(v_file, v_string);
            IF v_string IS NULL THEN
                EXIT;
            END IF;
            id_vendedor := TO_NUMBER(regexp_substr(v_string, '[^,]+', 1, 1));
            nombre_vendedor := regexp_substr(v_string, '[^,]+', 1, 2);
            apellido_vendedor := regexp_substr(v_string, '[^,]+', 1, 3);
            correo_vendedor := regexp_substr(v_string, '[^,]+', 1, 4);
            dpi_vendedor := regexp_substr(v_string, '[^,]+', 1, 5);

            IF id_vendedor IS NULL OR nombre_vendedor IS NULL OR apellido_vendedor IS NULL OR correo_vendedor IS NULL OR dpi_vendedor IS NULL THEN
                CONTINUE;
            END IF;

            INSERT INTO Vendedor VALUES(id_vendedor, nombre_vendedor, apellido_vendedor, correo_vendedor, dpi_vendedor);
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN
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
    id_producto INT;
    nombre_producto VARCHAR(50);
    precio_producto VARCHAR(50);
    precio_producto_final NUMBER(6,2);
    stock_producto INT;
BEGIN
    v_file := UTL_FILE.FOPEN('RUTA_CSVS', 'Productos.csv', 'r');
    UTL_FILE.GET_LINE(v_file, v_string);
    LOOP
        BEGIN
            UTL_FILE.GET_LINE(v_file, v_string);
            id_producto := TO_NUMBER(regexp_substr(v_string, '[^;]+', 1, 1));
            nombre_producto := regexp_substr(v_string, '[^;]+', 1, 2);
            precio_producto := LTRIM(regexp_substr(v_string, '[^;]+', 1, 3), '$');
            stock_producto := TO_NUMBER(regexp_substr(v_string, '[^;]+', 1, 4));
            
            IF id_producto IS NULL OR nombre_producto IS NULL OR precio_producto IS NULL OR stock_producto IS NULL THEN
                CONTINUE;
            END IF;
            precio_producto_final := TO_NUMBER(precio_producto);

            INSERT INTO Producto VALUES(id_producto, nombre_producto, precio_producto_final, stock_producto);
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN
                    CONTINUE;
                WHEN VALUE_ERROR THEN
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
    id_factura INT;
    id_client INT;
    id_vend INT;
    aux INT;
    fecha_factura VARCHAR(50);
BEGIN
    v_file := UTL_FILE.FOPEN('RUTA_CSVS', 'Facturas.csv', 'r');
    UTL_FILE.GET_LINE(v_file, v_string);
    LOOP
        BEGIN
            UTL_FILE.GET_LINE(v_file, v_string);
            IF v_string IS NULL THEN
                EXIT;
            END IF;
            id_factura := TO_NUMBER(regexp_substr(v_string, '[^,]+', 1, 1));
            id_client := TO_NUMBER(regexp_substr(v_string, '[^,]+', 1, 2));
            id_vend := TO_NUMBER(regexp_substr(v_string, '[^,]+', 1, 3));
            fecha_factura := regexp_substr(v_string, '[^,]+', 1, 4);

            IF id_factura IS NULL OR id_client IS NULL OR id_vend IS NULL OR fecha_factura IS NULL THEN
                CONTINUE;
            END IF;

            SELECT COUNT(*) INTO aux FROM DUAL WHERE EXISTS(SELECT * FROM VENDEDOR WHERE id_vendedor=id_vend);
            IF aux = 0 THEN
                CONTINUE;
            END IF;
            SELECT COUNT(*) INTO aux FROM DUAL WHERE EXISTS(SELECT * FROM CLIENTE WHERE id_cliente=id_client);
            IF aux = 0 THEN
                CONTINUE;
            END IF;

            INSERT INTO Factura VALUES(id_factura, id_client, id_vend, TO_DATE(fecha_factura, 'DD/MM/YYYY'));
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN
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

    id_fact INT;
    id_prod INT;
    cantidad INT;
    sub_total NUMBER(6,2);
    aux NUMBER(6,2);
BEGIN
    v_file := UTL_FILE.FOPEN('RUTA_CSVS', 'Detalle.csv', 'r');
    UTL_FILE.GET_LINE(v_file, v_string);
    LOOP
        BEGIN
            UTL_FILE.GET_LINE(v_file, v_string);
            id_fact := TO_NUMBER(regexp_substr(v_string, '[^,]+', 1, 1));
            id_prod := TO_NUMBER(regexp_substr(v_string, '[^,]+', 1, 2));
            cantidad := TO_NUMBER(regexp_substr(v_string, '[^,]+', 1, 3));

            IF id_fact IS NULL OR id_prod IS NULL OR cantidad IS NULL THEN
                CONTINUE;
            END IF;
            
            SELECT COUNT(*) INTO aux FROM DUAL WHERE EXISTS(SELECT * FROM Factura WHERE id_factura=id_fact);
            IF aux = 0 OR aux > 1 THEN
                CONTINUE;
            END IF;
            SELECT COUNT(*) INTO aux FROM DUAL WHERE EXISTS(SELECT * FROM Producto WHERE id_producto=id_prod);
            IF aux = 0 OR aux > 1 THEN
                CONTINUE;
            END IF;
            SELECT precio_producto INTO aux FROM Producto WHERE id_producto=id_prod;
            sub_total := cantidad * aux;

            INSERT INTO Detalle(id_factura, id_producto, cantidad, sub_total) VALUES(id_fact, id_prod, cantidad, sub_total);
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN
                    CONTINUE;
        END;
    END LOOP;
    UTL_FILE.FCLOSE(v_file);
EXCEPTION
    WHEN no_data_found THEN
        UTL_FILE.FCLOSE(v_file);
END;
/