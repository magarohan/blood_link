const express = require('express');
const { getAllBloodBanks, addBloodBank, loginBloodBank } = require('../controllers/bloodBankController');

const router = express.Router();

// Get all blood banks
router.get('/', getAllBloodBanks);

// Add a new blood bank
router.post('/', addBloodBank);

// Login a blood bank
router.post('/login', loginBloodBank);

module.exports = router;
