import express from 'express';

import {
  getAllRequests,
  getRequestById,
  createRequest,
  updateRequest,
  deleteRequest
} from '../controllers/service-request.controller.js';

const router = express.Router();

// GET all requests
router.get('/', getAllRequests);

// GET request by ID
router.get('/:id', getRequestById);

// CREATE request
router.post('/', createRequest);

// UPDATE request
router.put('/:id', updateRequest);

// DELETE request
router.delete('/:id', deleteRequest);

export default router;