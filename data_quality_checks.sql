-- =============================================
-- Metadata & Data Quality Checks
-- Proyecto: Gestión de metadatos y validación de datos
-- =============================================

-- =============================================
-- 1. Tabla: customers
-- Validación de integridad y calidad de datos
-- =============================================

-- 1.1 Detectar valores nulos en columnas críticas
SELECT customer_id, first_name, last_name, email
FROM customers
WHERE customer_id IS NULL
   OR first_name IS NULL
   OR last_name IS NULL
   OR email IS NULL;

-- 1.2 Detección de duplicados
SELECT customer_id, COUNT(*) AS duplicates
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- 1.3 Validación de formato de email
SELECT customer_id, email
FROM customers
WHERE email NOT LIKE '%_@__%.__%';

-- 1.4 Comprobación de longitud de campos
SELECT customer_id, LENGTH(first_name) AS fname_len, LENGTH(last_name) AS lname_len
FROM customers
WHERE LENGTH(first_name) < 2
   OR LENGTH(last_name) < 2;

-- =============================================
-- 2. Tabla: orders
-- Integridad referencial y consistencia de datos
-- =============================================

-- 2.1 Detectar órdenes sin cliente asociado
SELECT o.order_id, o.customer_id
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- 2.2 Verificar fechas lógicas: order_date <= ship_date
SELECT order_id, order_date, ship_date
FROM orders
WHERE order_date > ship_date;

-- 2.3 Detectar pedidos duplicados
SELECT customer_id, order_date, COUNT(*) AS duplicates
FROM orders
GROUP BY customer_id, order_date
HAVING COUNT(*) > 1;

-- =============================================
-- 3. Validaciones combinadas / métricas de calidad
-- =============================================

-- 3.1 Porcentaje de registros con datos completos
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN first_name IS NOT NULL AND last_name IS NOT NULL AND email IS NOT NULL THEN 1 ELSE 0 END) AS complete_records,
    ROUND(SUM(CASE WHEN first_name IS NOT NULL AND last_name IS NOT NULL AND email IS NOT NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_complete
FROM customers;

-- 3.2 Resumen de duplicados
SELECT
    'customers' AS table_name,
    COUNT(*) AS duplicate_count
FROM (
    SELECT customer_id
    FROM customers
    GROUP BY customer_id
    HAVING COUNT(*) > 1
) dup

UNION ALL

SELECT
    'orders' AS table_name,
    COUNT(*) AS duplicate_count
FROM (
    SELECT customer_id, order_date
    FROM orders
    GROUP BY customer_id, order_date
    HAVING COUNT(*) > 1
) dup;

-- =============================================
-- 4. Script de limpieza 
-- =============================================

-- 4.1 Eliminar duplicados temporales 
-- CREATE TABLE customers_clean AS
-- SELECT *
-- FROM customers
-- WHERE customer_id IS NOT NULL
-- QUALIFY ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY created_at DESC) = 1;

-- 4.2 Normalización de emails 
-- UPDATE customers
-- SET email = LOWER(TRIM(email))
-- WHERE email IS NOT NULL;
