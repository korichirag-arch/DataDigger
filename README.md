# Data Digger - E-Commerce Store Database

## Description
A comprehensive MySQL database project demonstrating CRUD operations, primary keys, foreign keys, clauses, operators, and aggregate functions for an E-Commerce Store.

## Database Schema
- **Customers**: Stores customer information
- **Products**: Stores product catalog
- **Orders**: Stores order transactions
- **OrderDetails**: Stores individual items in each order

## Features
- Complete CRUD operations on all tables
- Primary and foreign key relationships
- Data filtering with WHERE, BETWEEN, LIKE
- Sorting with ORDER BY
- Aggregate functions: MAX(), MIN(), AVG(), SUM(), COUNT()
- JOIN operations for relational queries
- Date-based filtering with INTERVAL

## Assumptions
- MySQL 8.0+ is used
- Currency is in Indian Rupees (₹)
- Sample data is fictional
- "Last 30 days" is relative to CURDATE()

## How to Run
1. Install MySQL 8.0 or higher
2. Open MySQL Workbench or command line
3. Execute: `SOURCE schema.sql;`
4. Execute: `SOURCE sample_data.sql;`
5. Run individual queries from `queries.sql`

## Files
| File | Description |
|------|-------------|
| schema.sql | Database and table creation scripts |
| sample_data.sql | INSERT statements for sample data |
| queries.sql | All CRUD and aggregate queries |

## Author
[Chirag Kori]
