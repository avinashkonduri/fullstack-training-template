
import pool from '../config/db.js';

// Map PostgreSQL snake_case columns to Angular camelCase
const columns = `
  id,
  request_id AS "requestId",
  title,
  description,
  category,
  priority,
  status,
  requested_by AS "requestedBy",
  assigned_to AS "assignedTo",
  TO_CHAR(created_at, 'YYYY-MM-DD') AS "createdAt"
`;

// GET all service requests with filters
export const getAllRequests = async (filters = {}) => {
  let query = `
    SELECT ${columns}
    FROM service_requests
    WHERE 1 = 1
  `;

  const values = [];

  if (filters.status) {
    values.push(filters.status);
    query += ` AND LOWER(status) = LOWER($${values.length})`;
  }

  if (filters.priority) {
    values.push(filters.priority);
    query += ` AND LOWER(priority) = LOWER($${values.length})`;
  }

  if (filters.category) {
    values.push(filters.category);
    query += ` AND LOWER(category) = LOWER($${values.length})`;
  }

  if (filters.search) {
    values.push(`%${filters.search}%`);

    query += `
      AND (
        title ILIKE $${values.length}
        OR description ILIKE $${values.length}
        OR request_id ILIKE $${values.length}
      )
    `;
  }

  query += ' ORDER BY id DESC';

  const result = await pool.query(query, values);

  return result.rows;
};

// GET request by ID
export const getRequestById = async (id) => {
  const query = `
    SELECT ${columns}
    FROM service_requests
    WHERE id = $1
  `;

  const result = await pool.query(query, [id]);

  return result.rows[0] ?? null;
};

// CREATE request
export const createRequest = async (requestData) => {
  const {
    title,
    description,
    category,
    priority = 'Medium',
    status = 'Open',
    requestedBy,
    assignedTo = 'Unassigned'
  } = requestData;

  const query = `
    WITH inserted AS (
      INSERT INTO service_requests (
        request_id,
        title,
        description,
        category,
        priority,
        status,
        requested_by,
        assigned_to
      )
      VALUES (
        'SR-' || EXTRACT(YEAR FROM CURRENT_DATE)::TEXT
          || '-' || LPAD(
            nextval('service_request_number_seq')::TEXT,
            3,
            '0'
          ),
        $1, $2, $3, $4, $5, $6, $7
      )
      RETURNING id
    )
    SELECT ${columns}
    FROM service_requests
    WHERE id = (SELECT id FROM inserted)
  `;

  const values = [
    title,
    description,
    category,
    priority,
    status,
    requestedBy,
    assignedTo
  ];

  const result = await pool.query(query, values);

  return result.rows[0];
};

// UPDATE request
export const updateRequest = async (id, requestData) => {
  // Only allow editable fields
  const allowedFields = {
    title: 'title',
    description: 'description',
    category: 'category',
    priority: 'priority',
    status: 'status',
    requestedBy: 'requested_by',
    assignedTo: 'assigned_to'
  };

  const fields = Object.entries(requestData).filter(
    ([key, value]) =>
      Object.hasOwn(allowedFields, key) &&
      value !== undefined
  );

  if (fields.length === 0) {
    const error = new Error('No valid fields provided');
    error.status = 400;
    throw error;
  }

  const values = [];

  const setClause = fields.map(([key, value]) => {
    values.push(value);
    return `${allowedFields[key]} = $${values.length}`;
  }).join(', ');

  values.push(id);

  const query = `
    WITH updated AS (
      UPDATE service_requests
      SET ${setClause}
      WHERE id = $${values.length}
      RETURNING id
    )
    SELECT ${columns}
    FROM service_requests
    WHERE id = (SELECT id FROM updated)
  `;

  const result = await pool.query(query, values);

  return result.rows[0] ?? null;
};

// DELETE request
export const deleteRequest = async (id) => {
  const query = `
    DELETE FROM service_requests
    WHERE id = $1
  `;

  const result = await pool.query(query, [id]);

  return result.rowCount > 0;
};
