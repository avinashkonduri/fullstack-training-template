import express from 'express';
import cors from 'cors';

import serviceRequestRoutes from './routes/service-request.routes.js';
import loggerMiddleware from './middleware/logger.middleware.js';

const app = express();

// Built-in middleware
app.use(cors());
app.use(express.json());

// Custom middleware
app.use(loggerMiddleware);

// Health check
app.get('/api/health', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'ServiceHub API is running'
  });
});

// API routes
app.use('/api/service-requests', serviceRequestRoutes);

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: `Route not found: ${req.method} ${req.originalUrl}`
  });
});

// Global error handler
app.use((err, req, res, next) => {
  console.error(err);

  res.status(err.status || 500).json({
    success: false,
    message: err.message || 'Internal Server Error'
  });
});

export default app;