const express = require('express');
const {
    getAllHospitalBlood,
    getHospitalBloodById,
    addHospitalBlood,
    updateHospitalBlood,
    deleteHospitalBlood,
    searchHospitalBlood,
} = require('../controllers/hospitalInventoryController');

const router = express.Router();

// Get all blood records
router.get('/', getAllHospitalBlood);

// Search blood records by type and Rh factor
router.get('/search', searchHospitalBlood);

// Get a single blood record by ID
router.get('/:id', getHospitalBloodById);

// Add a new blood record
router.post('/', addHospitalBlood);

// Update a blood record by ID
router.patch('/:id', updateHospitalBlood);

// Delete a blood record by ID
router.delete('/:id', deleteHospitalBlood);

module.exports = router;