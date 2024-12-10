const express = require('express')
const User = require('../models/userModel')
const router = express.Router()
const {getUsers, getUser, signupUser, deleteUser, updateUser, loginUser} = require('../controllers/userController')

// get all users
router.get('/', getUsers)

//get single user
router.get('/:id', getUser)

//delete a user
router.delete('/:id', deleteUser)

//update a user
router.patch('/:id', updateUser)

//login user
router.post('/login', loginUser)

//signup user
router.post('/signup', signupUser)

module.exports = router