
CREATE TABLE service_requests_practice (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    request_id VARCHAR(30) NOT NULL UNIQUE,

    title VARCHAR(100) NOT NULL,

    priority VARCHAR(20)
        CHECK (priority IN ('Low', 'Medium', 'High', 'Critical')),

    status VARCHAR(20) DEFAULT 'Open',

    created_at DATE DEFAULT CURRENT_DATE
);

-- Valid
INSERT INTO service_requests_practice
(request_id, title, priority)
VALUES ('SR-001', 'Laptop not booting', 'High');

-- Invalid: title is missing
INSERT INTO service_requests_practice
(request_id, priority)
VALUES ('SR-002', 'Medium');


-- Invalid: SR-001 already exists
INSERT INTO service_requests_practice
(request_id, title, priority)
VALUES ('SR-001', 'Printer issue', 'Low');



-- Valid
INSERT INTO service_requests_practice
(request_id, title, priority)
VALUES ('SR-003', 'VPN issue', 'Critical');

-- Invalid
INSERT INTO service_requests_practice
(request_id, title, priority)
VALUES ('SR-004', 'Email issue', 'Urgent');


INSERT INTO service_requests_practice
(request_id, title, priority)
VALUES ('SR-005', 'Mouse not working', 'Low');

SELECT request_id, title, priority, status, created_at
FROM service_requests_practice
WHERE request_id = 'SR-005';


CREATE TABLE employees_practice (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL
);

CREATE TABLE requests_fk_practice (
    id INT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    assigned_to INT,
    CONSTRAINT fk_assigned_employee
        FOREIGN KEY (assigned_to)
        REFERENCES employees_practice(employee_id)
);

INSERT INTO employees_practice
VALUES (101, 'Ravi Kumar');

-- Valid: Employee 101 exists
INSERT INTO requests_fk_practice
VALUES (1, 'Laptop issue', 101);

-- Invalid: Employee 999 does not exist
INSERT INTO requests_fk_practice
VALUES (2, 'VPN issue', 999);


ALTER TABLE service_requests_practice
ADD CONSTRAINT chk_request_status
CHECK (status IN (
    'Open',
    'In Progress',
    'Waiting',
    'Resolved'
));


