const express = require('express');
const Request = require('../models/requestModel');
const router = express.Router();
const {getAllRequests,
    getRequestbyId,
    addRequest,
    updateRequest,
    deleteRequest,
searchRequest} = require('../controllers/requestController');

// Get all requests
router.get('/', getAllRequests);

//Search a request by type and Rh factor
router.get('/search', searchRequest);

// Get a single request record by ID
router.get('/:id', getRequestbyId);

// Add a new request record
router.post('/', addRequest);

// Update a equest record by ID
router.patch('/:id', updateRequest);

// Delete a request record by ID
router.delete('/:id', deleteRequest);

module.exports = router