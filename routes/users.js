const express = require('express')
const User = require('../models/userModel')
const router = express.Router()

// get all users
router.get('/', (req, res) => {
    res.json({message: "get all users"})
})

//get single user
router.get('/:id', (req, res) => {
    res.json({message: "get a single user"})
})

//post a new user
router.post('/', async (req, res) => {
    const {fullName, bloodGroup, location, email, phoneNumber, password} = req.body
    try{
        const user = await User.create({
            fullName, bloodGroup, location, email, phoneNumber, password
        })
        res.status(200).json(user)
    }catch(error){
        res.status(400).json({error: error.message})
    }
})

//delete a user
router.delete('/:id', (req, res) => {
    res.json({message: "delete a user"})
})

//update a user
router.patch('/:id', (req, res) => {
    res.json({message: "update a user"})
})

module.exports = router