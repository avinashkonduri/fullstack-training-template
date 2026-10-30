import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const DATA_FILE = path.resolve(
  __dirname,
  '../data/service-requests.json'
);

// Read all records
const readData = async () => {
  const content = await fs.readFile(DATA_FILE, 'utf-8');
  return JSON.parse(content);
};

// Write all records
const writeData = async (data) => {
  await fs.writeFile(
    DATA_FILE,
    JSON.stringify(data, null, 2),
    'utf-8'
  );
};

// GET all service requests
export const getAllRequests = async (filters = {}) => {
  let requests = await readData();

  if (filters.status) {
    requests = requests.filter(
      item => item.status.toLowerCase() === filters.status.toLowerCase()
    );
  }

  if (filters.priority) {
    requests = requests.filter(
      item => item.priority.toLowerCase() === filters.priority.toLowerCase()
    );
  }

  if (filters.category) {
    requests = requests.filter(
      item => item.category.toLowerCase() === filters.category.toLowerCase()
    );
  }

  if (filters.search) {
    const search = filters.search.toLowerCase();

    requests = requests.filter(item =>
      item.title.toLowerCase().includes(search) ||
      item.description.toLowerCase().includes(search) ||
      item.requestId.toLowerCase().includes(search)
    );
  }

  return requests;
};

// GET request by ID
export const getRequestById = async (id) => {
  const requests = await readData();

  return requests.find(item => item.id === Number(id));
};

// CREATE request
export const createRequest = async (requestData) => {
  const requests = await readData();

  const newId = requests.length
    ? Math.max(...requests.map(item => item.id)) + 1
    : 1001;

  const newRequest = {
    id: newId,
    requestId: `SR-2026-${String(newId - 1000).padStart(3, '0')}`,
    ...requestData,
    createdAt: new Date().toISOString().slice(0, 10)
  };

  requests.push(newRequest);

  await writeData(requests);

  return newRequest;
};

// UPDATE request
export const updateRequest = async (id, requestData) => {
  const requests = await readData();

  const index = requests.findIndex(
    item => item.id === Number(id)
  );

  if (index === -1) return null;

  requests[index] = {
    ...requests[index],
    ...requestData,
    id: requests[index].id,
    requestId: requests[index].requestId,
    createdAt: requests[index].createdAt
  };

  await writeData(requests);

  return requests[index];
};

// DELETE request
export const deleteRequest = async (id) => {
  const requests = await readData();

  const index = requests.findIndex(
    item => item.id === Number(id)
  );

  if (index === -1) return false;

  requests.splice(index, 1);

  await writeData(requests);

  return true;
};