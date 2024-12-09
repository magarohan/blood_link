const express = require('express')
const User = require('../models/userModel')
const router = express.Router()
const {getUsers, getUser, createUser, deleteUser, updateUser} = require('../controllers/userController')

// get all users
router.get('/', getUsers)

//get single user
router.get('/:id', getUser)

//post a new user
router.post('/', createUser)

//delete a user
router.delete('/:id', deleteUser)

//update a user
router.patch('/:id', updateUser)

module.exports = router