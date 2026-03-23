# Metadata Dictionary - Demo

## Customers Table
| Column Name    | Type     | Description                     | Notes                     |
|----------------|---------|---------------------------------|---------------------------|
| customer_id     | INT     | Identificador único del cliente | Primary Key               |
| first_name      | VARCHAR | Nombre del cliente              | No nulo                  |
| last_name       | VARCHAR | Apellido del cliente            | No nulo                  |
| email           | VARCHAR | Email del cliente               | Formato válido, no nulo  |
| created_at      | DATETIME| Fecha de creación               | Registro inicial          |

## Orders Table 
| Column Name    | Type     | Description                     | Notes                     |
|----------------|---------|---------------------------------|---------------------------|
| order_id        | INT     | Identificador único del pedido  | Primary Key               |
| customer_id     | INT     | Cliente asociado                | Foreign Key -> customers  |
| order_date      | DATE    | Fecha del pedido                | No nulo                  |
| ship_date       | DATE    | Fecha de envío                  | Debe ser >= order_date   |
| amount          | DECIMAL | Total del pedido                | Debe ser positivo        |
