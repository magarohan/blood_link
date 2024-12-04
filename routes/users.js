const express = require('express')
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
router.post('/', (req, res) => {
    res.json({message: "create a new user"})
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