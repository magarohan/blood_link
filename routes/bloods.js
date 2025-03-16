const express = require('express');
const {
    getBloodByBank,
    getBloodById,
    addBlood,
    updateBlood,
    deleteBlood,
    searchBlood,
} = require('../controllers/bloodController');

const router = express.Router();

// Get all blood records for a specific blood bank
router.get('/bank/:bloodBankId', getBloodByBank);

// Search blood records by type and Rh factor (across all blood banks)
router.get('/search', searchBlood);

// Get a single blood record by ID
router.get('/:id', getBloodById);

// Add a new blood record to a blood bank
router.post('/', addBlood);

// Update a blood record by ID
router.patch('/:id', updateBlood);

// Delete a blood record by ID
router.delete('/:id', deleteBlood);

module.exports = router;
