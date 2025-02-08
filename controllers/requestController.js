const mongoose = require('mongoose');
const Request = require('../models/requestModel');
const { request } = require('express');

//get all requests
const getAllRequests = async (req, res) => {
    try {
            const requests = await Request.find({}).sort({ createdAt: -1 });
            res.status(200).json(requests);
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
}

// Get a single request record
const getRequestbyId = async (req, res) => {
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) {
        return res.status(404).json({ error: "No such request record" });
    }

    try {
        const request = await Request.findById(id);
        if (!request) {
            return res.status(404).json({ error: "No such request record" });
        }
        res.status(200).json(request);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Add a new request record
const addRequest = async (req, res) => {
    const { name, bloodType, rhFactor, location } = req.body;

    try {
        const newRequestRecord = await Request.create({ name, bloodType, rhFactor, location });
        res.status(201).json(newRequestRecord);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};

// Update an existing request record
const updateRequest = async (req, res) => {
    const { id } = req.params; // Get ID from request params

    if (!mongoose.Types.ObjectId.isValid(id)) {
        return res.status(404).json({ error: "Invalid request ID" });
    }

    try {
        const updatedRequestRecord = await Request.findByIdAndUpdate(
            id,
            { $set: req.body }, // Update only the provided fields
            { new: true, runValidators: true }
        );

        if (!updatedRequestRecord) {
            return res.status(404).json({ error: "No such request record" });
        }

        res.status(200).json(updatedRequestRecord);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};


// Delete a blood record
const deleteRequest = async (req, res) => {
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) {
        return res.status(404).json({ error: "No such request record" });
    }

    try {
        const deletedRequestRecord = await Request.findByIdAndDelete(id);
        if (!deletedRequestRecord) {
            return res.status(404).json({ error: "No such blood record" });
        }
        res.status(200).json({ message: "Blood record deleted successfully" });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

//search a request
const searchRequest = async (req, res) => {
    const { bloodType, rhFactor } = req.query;

    try {
        const requestRecords = await Request.find({ bloodType, rhFactor });
        if(!bloodType|| !rhFactor){
            return res.status(404).json({ error: "both bloodType and rhFactor are needed" });
        }
        if (requestRecords.length === 0) {
            return res.status(404).json({ error: "No matching request records found" });
        }
        res.status(200).json(requestRecords);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};



module.exports = {
    getAllRequests,
    getRequestbyId,
    addRequest,
    updateRequest,
    deleteRequest,
    searchRequest}