
CREATE TABLE departments (
    department_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE employees (
    employee_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    department_id INTEGER NOT NULL,
    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

CREATE TABLE service_requests (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    request_id VARCHAR(30) NOT NULL UNIQUE,
    title VARCHAR(150) NOT NULL,
    priority VARCHAR(20) NOT NULL
        CHECK (priority IN ('Low', 'Medium', 'High', 'Critical')),
    status VARCHAR(30) NOT NULL DEFAULT 'Open',
    assigned_to INTEGER,
    created_at DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (assigned_to)
        REFERENCES employees(employee_id)
);


INSERT INTO departments (department_name)
VALUES
('IT Support'),
('Network'),
('HR'),
('Finance');

INSERT INTO employees (employee_name, email, department_id)
VALUES
('Ravi Kumar', 'ravi@example.com', 1),
('Priya Sharma', 'priya@example.com', 2),
('Arjun Reddy', 'arjun@example.com', 1),
('Sneha Rao', 'sneha@example.com', 3);

INSERT INTO service_requests
(request_id, title, priority, status, assigned_to)
VALUES
('SR-001', 'Laptop not booting', 'High', 'Open', 1),
('SR-002', 'VPN not connecting', 'Critical', 'In Progress', 2),
('SR-003', 'Email access issue', 'Medium', 'Resolved', 1),
('SR-004', 'Printer not working', 'Low', 'Open', NULL),
('SR-005', 'Network outage', 'Critical', 'Open', 2);


INSERT INTO service_requests
(request_id, title, priority, status)
VALUES ('SR-006', 'Monitor issue', 'Medium', 'Open')
RETURNING *;


SELECT * FROM service_requests;

SELECT request_id, title, priority
FROM service_requests
WHERE priority = 'Critical'
ORDER BY id DESC;


UPDATE service_requests
SET status = 'Resolved'
WHERE request_id = 'SR-001'
RETURNING *;


DELETE FROM service_requests
WHERE request_id = 'SR-006'
RETURNING *;

-- Business requirement: Display each request with its assigned employee and department.
SELECT
    sr.request_id,
    sr.title,
    sr.priority,
    e.employee_name,
    d.department_name
FROM service_requests sr
LEFT JOIN employees e
    ON sr.assigned_to = e.employee_id
LEFT JOIN departments d
    ON e.department_id = d.department_id
ORDER BY sr.id;

-- Real-time requirement: Display the number of service requests assigned to each employee.
SELECT
    e.employee_name,
    COUNT(sr.id) AS total_requests
FROM employees e
LEFT JOIN service_requests sr
    ON e.employee_id = sr.assigned_to
GROUP BY e.employee_id, e.employee_name
ORDER BY total_requests DESC;

-- To show only employees with more than one request:
SELECT
    e.employee_name,
    COUNT(sr.id) AS total_requests
FROM employees e
JOIN service_requests sr
    ON e.employee_id = sr.assigned_to
GROUP BY e.employee_id, e.employee_name
HAVING COUNT(sr.id) > 1;

--Find employees who have at least one critical-priority request.
SELECT employee_name
FROM employees
WHERE employee_id IN (
    SELECT assigned_to
    FROM service_requests
    WHERE priority = 'Critical'
);

--Use CASE to create a readable priority label.

SELECT
    request_id,
    title,
    CASE
        WHEN priority = 'Critical' THEN 'Immediate Action'
        WHEN priority = 'High' THEN 'Urgent'
        WHEN priority = 'Medium' THEN 'Normal'
        ELSE 'Low Priority'
    END AS action_required
FROM service_requests;

-- Common Table Expression (CTE)
-- A CTE makes a complex query easier to understand and maintain.

WITH employee_workload AS (
    SELECT
        e.employee_id,
        e.employee_name,
        COUNT(sr.id) AS total_requests
    FROM employees e
    LEFT JOIN service_requests sr
        ON sr.assigned_to = e.employee_id
    GROUP BY e.employee_id, e.employee_name
)
SELECT *
FROM employee_workload
WHERE total_requests > 0;

-- Create a reusable view

CREATE OR REPLACE VIEW vw_service_request_details AS
SELECT
    sr.request_id,
    sr.title,
    sr.priority,
    sr.status,
    e.employee_name,
    d.department_name
FROM service_requests sr
LEFT JOIN employees e
    ON sr.assigned_to = e.employee_id
LEFT JOIN departments d
    ON e.department_id = d.department_id;

SELECT * FROM vw_service_request_details;
-- An index can improve filtering performance on large tables. For small tables, PostgreSQL may correctly choose a sequential scan instead.
-- Create an index

CREATE INDEX idx_service_requests_priority
ON service_requests(priority);

EXPLAIN ANALYZE
SELECT *
FROM service_requests
WHERE priority = 'Critical';

-- Scenario: A support manager wants to assign an unassigned service request to Arjun Reddy.

BEGIN;

UPDATE service_requests
SET assigned_to = 3,
    status = 'In Progress'
WHERE request_id = 'SR-004';

SELECT *
FROM service_requests
WHERE request_id = 'SR-004';

-- Save the change:
COMMIT;

-- Alternatively, use ROLLBACK instead
-- of COMMIT to cancel the transaction.
