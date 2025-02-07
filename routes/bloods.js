const express = require('express');
const {
    getAllBlood,
    getBloodById,
    addBlood,
    updateBlood,
    deleteBlood,
    searchBlood,
} = require('../controllers/bloodController');

const router = express.Router();

// Get all blood records
router.get('/', getAllBlood);

// Search blood records by type and Rh factor
router.get('/search', searchBlood);

// Get a single blood record by ID
router.get('/:id', getBloodById);

// Add a new blood record
router.post('/', addBlood);

// Update a blood record by ID
router.patch('/:id', updateBlood);

// Delete a blood record by ID
router.delete('/:id', deleteBlood);

//search
router.get('/search', searchBlood);

module.exports = router;