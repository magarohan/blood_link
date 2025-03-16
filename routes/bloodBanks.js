const express = require('express');
const { getAllBloodBanks, addBloodBank } = require('../controllers/bloodBankController');

const router = express.Router();

// Get all blood banks
router.get('/', getAllBloodBanks);

// Add a new blood bank
router.post('/', addBloodBank);

module.exports = router;
