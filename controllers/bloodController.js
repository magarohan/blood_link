const mongoose = require('mongoose');
const Blood = require('../models/bloodModel');

// Get all blood entries
const getAllBlood = async (req, res) => {
    try {
        const bloodRecords = await Blood.find({}).sort({ createdAt: -1 });
        res.status(200).json(bloodRecords);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Get a single blood record
const getBloodById = async (req, res) => {
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) {
        return res.status(404).json({ error: "No such blood record" });
    }

    try {
        const bloodRecord = await Blood.findById(id);
        if (!bloodRecord) {
            return res.status(404).json({ error: "No such blood record" });
        }
        res.status(200).json(bloodRecord);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Add a new blood record
const addBlood = async (req, res) => {
    const { bloodType, rhFactor, components } = req.body;

    try {
        const newBloodRecord = await Blood.create({ bloodType, rhFactor, components });
        res.status(201).json(newBloodRecord);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};

// Update an existing blood record
const updateBlood = async (req, res) => {
    const { id } = req.params;
    const updates = req.body;

    if (!mongoose.Types.ObjectId.isValid(id)) {
        return res.status(404).json({ error: "No such blood record" });
    }

    try {
        const updatedBloodRecord = await Blood.findByIdAndUpdate(id, updates, {
            new: true,
            runValidators: true,
        });

        if (!updatedBloodRecord) {
            return res.status(404).json({ error: "No such blood record" });
        }
        res.status(200).json(updatedBloodRecord);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};

// Delete a blood record
const deleteBlood = async (req, res) => {
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) {
        return res.status(404).json({ error: "No such blood record" });
    }

    try {
        const deletedBloodRecord = await Blood.findByIdAndDelete(id);
        if (!deletedBloodRecord) {
            return res.status(404).json({ error: "No such blood record" });
        }
        res.status(200).json({ message: "Blood record deleted successfully" });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Search blood by type and Rh factor
const searchBlood = async (req, res) => {
    const { bloodType, rhFactor } = req.query; // Use req.query instead of req.params

    try {
        const bloodRecords = await Blood.find({ bloodType, rhFactor });
        if (bloodRecords.length === 0) {
            return res.status(404).json({ error: "No matching blood records found" });
        }
        res.status(200).json(bloodRecords);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

module.exports = {
    getAllBlood,
    getBloodById,
    addBlood,
    updateBlood,
    deleteBlood,
    searchBlood,
};