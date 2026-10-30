import * as service from '../services/service-request.service.js';

// GET all requests
export const getAllRequests = async (req, res, next) => {
  try {
    const requests = await service.getAllRequests(req.query);

    res.status(200).json({
      success: true,
      count: requests.length,
      data: requests
    });
  } catch (error) {
    next(error);
  }
};

// GET request by ID
export const getRequestById = async (req, res, next) => {
  try {
    const request = await service.getRequestById(req.params.id);

    if (!request) {
      return res.status(404).json({
        success: false,
        message: 'Service request not found'
      });
    }

    res.status(200).json({
      success: true,
      data: request
    });
  } catch (error) {
    next(error);
  }
};

// CREATE request
export const createRequest = async (req, res, next) => {
  try {
    const request = await service.createRequest(req.body);

    res.status(201).json({
      success: true,
      message: 'Service request created successfully',
      data: request
    });
  } catch (error) {
    next(error);
  }
};

// UPDATE request
export const updateRequest = async (req, res, next) => {
  try {
    const request = await service.updateRequest(
      req.params.id,
      req.body
    );

    if (!request) {
      return res.status(404).json({
        success: false,
        message: 'Service request not found'
      });
    }

    res.status(200).json({
      success: true,
      message: 'Service request updated successfully',
      data: request
    });
  } catch (error) {
    next(error);
  }
};

// DELETE request
export const deleteRequest = async (req, res, next) => {
  try {
    const deleted = await service.deleteRequest(req.params.id);

    if (!deleted) {
      return res.status(404).json({
        success: false,
        message: 'Service request not found'
      });
    }

    res.status(200).json({
      success: true,
      message: 'Service request deleted successfully'
    });
  } catch (error) {
    next(error);
  }
};