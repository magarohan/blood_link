const express = require('express')
const Donor = require('../models/donorModel')
const router = express.Router()
const {getAllDonors, getDonor, signupDonor, deleteDonor, updateDonor, loginDonor} = require('../controllers/donorController')

// get all donors
router.get('/', getAllDonors)

//get single donor
router.get('/:id', getDonor)

//delete a donor
router.delete('/:id', deleteDonor)

//update a donor
router.patch('/:id', updateDonor)

//login donor
router.post('/login', loginDonor)

//signup donor
router.post('/signup', signupDonor)

module.exports = router